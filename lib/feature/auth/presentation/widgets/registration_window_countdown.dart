import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../../domain/entities/registration_credential.dart';

/// Shows how long the registration window has left, and fires [onExpired] when
/// it closes.
///
/// ## Why this exists
///
/// The registration token lives ~15 minutes. When it lapses, **both** confirming
/// and resending the code start returning 401, and the backend will not issue
/// another. The account is then stranded: it cannot log in (phone unconfirmed)
/// and it cannot be re-registered (phone taken).
///
/// Without this the user sees only "الرمز غير صالح" and has no way to know their
/// window shut — they would keep retrying a code that was never the problem.
/// Making the deadline visible turns a silent, permanent lockout into something
/// the user can act on while there is still time.
///
/// The deadline comes from the token's own `exp` claim via
/// [RegistrationCredential.remainingValidity] — nothing here hard-codes 15
/// minutes.
class RegistrationWindowCountdown extends StatefulWidget {
  const RegistrationWindowCountdown({
    super.key,
    required this.credential,
    required this.onExpired,
  });

  final RegistrationCredential credential;
  final VoidCallback onExpired;

  /// `mm:ss`, clamped to the registration window and never negative.
  ///
  /// Pure and public so the *format itself* can be pinned by a test. The bug
  /// this replaces was invisible to every test we had, because they all asserted
  /// booleans (expired / not expired) — nothing ever asserted what the user
  /// actually sees.
  ///
  /// The clamp is a guard, not decoration. This widget rendered `23476350:12` —
  /// tens of millions of minutes — because the deadline was read from the
  /// token's JWT `exp`, which lands in the year 2071. The duration now comes
  /// from a 15-minute window and *cannot* exceed it, so clamping means any
  /// future bug in the duration surfaces as a pinned `15:00` rather than as
  /// garbage on the user's screen.
  static String formatRemaining(Duration duration) {
    final Duration bounded = _clamp(duration);
    final String minutes = bounded.inMinutes.toString().padLeft(2, '0');
    final String seconds = (bounded.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  static Duration _clamp(Duration duration) {
    if (duration.isNegative) return Duration.zero;
    if (duration > RegistrationCredential.registrationWindow) {
      return RegistrationCredential.registrationWindow;
    }
    return duration;
  }

  @override
  State<RegistrationWindowCountdown> createState() =>
      _RegistrationWindowCountdownState();
}

class _RegistrationWindowCountdownState
    extends State<RegistrationWindowCountdown> {
  /// Below this, the countdown turns red — enough time to still finish, but a
  /// clear signal to stop waiting for an SMS that may not arrive.
  static const Duration _warningThreshold = Duration(minutes: 2);

  Timer? _ticker;
  late Duration _remaining;

  bool get _isUrgent => _remaining <= _warningThreshold;

  @override
  void initState() {
    super.initState();
    _remaining = widget.credential.remainingValidity;
    _startTicking();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicking() {
    if (_remaining == Duration.zero) {
      // Already dead when the screen opened — e.g. reopened from the login
      // screen after the window closed.
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onExpired());
      return;
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final Duration left = widget.credential.remainingValidity;
      if (left == Duration.zero) {
        timer.cancel();
        widget.onExpired();
      }
      if (mounted) setState(() => _remaining = left);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: _accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.timer_outlined, color: _accent, size: 16.w),
          SizedBox(width: 6.w),
          TextUtils(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _accent,
            text: '${'ينتهي التسجيل خلال'.tr()} ${_formatted(_remaining)}',
          ),
        ],
      ),
    );
  }

  Color get _accent => _isUrgent ? redColor : greyClr;

  String _formatted(Duration duration) =>
      RegistrationWindowCountdown.formatRemaining(duration);
}
