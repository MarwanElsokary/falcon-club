import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';

/// Counts down, then offers "resend".
///
/// ## The original never worked
///
/// `pinput/ui/widget/timer_widget.dart` had two independent bugs that each made
/// resend a no-op:
///
/// * the network call was commented out, so tapping it sent nothing; and
/// * the countdown reset was written `_restartCountdown;` — a **tear-off**, not
///   an invocation. The statement evaluated the function and threw it away.
///
/// Here the tap actually calls [onResend], and [restart] is invoked (with
/// parentheses) when a new code has been sent.
class OtpResendTimer extends StatefulWidget {
  const OtpResendTimer({
    super.key,
    required this.onResend,
    required this.isResending,
  });

  final VoidCallback onResend;
  final bool isResending;

  @override
  State<OtpResendTimer> createState() => OtpResendTimerState();
}

class OtpResendTimerState extends State<OtpResendTimer> {
  static const int _countdownSeconds = 60;

  Timer? _timer;
  int _remaining = _countdownSeconds;

  bool get _canResend => _remaining == 0 && !widget.isResending;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Call after a successful resend to begin the wait again.
  void restart() {
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _remaining = _countdownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remaining == 0) {
        timer.cancel();
        return;
      }
      setState(() => _remaining--);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _canResend ? _resendButton() : _countdownLabel();
  }

  Widget _resendButton() => TextButton(
    onPressed: widget.onResend,
    child: TextUtils(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: mainColor,
      text: 'إعادة إرسال الرمز'.tr(),
    ),
  );

  Widget _countdownLabel() => Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    child: TextUtils(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: greyClr,
      text: widget.isResending
          ? 'جاري الإرسال...'.tr()
          : '${'إعادة الإرسال خلال'.tr()} $_remaining',
    ),
  );
}
