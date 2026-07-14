import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_button_utils.dart';
import '../../../../core/widget/text_utils.dart';

/// The reset-flow resend control.
///
/// A faithful port of the original `TimerWidget`
/// (`forget_password/data/widgets/time_widget.dart`): while counting, an
/// **"إعادة الإرسال"** label beside a `SlideCountdown` forced to the `en` locale
/// (so the digits render as Latin numerals, as they did originally); once done,
/// a **"لم تستلم الرمز؟ أعد الإرسال"** text button, switching to
/// **"أعد الإرسال..."** while the request is in flight.
///
/// ## The original never actually resent
///
/// It had two independent bugs that each made it a no-op: the network call was
/// commented out, and the countdown reset was written `_restartCountdown;` — a
/// tear-off, not an invocation. Here [onResend] really fires, and [restart] is
/// invoked (with parentheses) once a new code has been sent. The *look* is the
/// original's; the behaviour is the one it was supposed to have.
class ResetResendTimer extends StatefulWidget {
  const ResetResendTimer({
    super.key,
    required this.onResend,
    required this.isResending,
  });

  final VoidCallback onResend;
  final bool isResending;

  @override
  State<ResetResendTimer> createState() => ResetResendTimerState();
}

class ResetResendTimerState extends State<ResetResendTimer> {
  static const Duration _countdown = Duration(seconds: 60);

  Duration _duration = _countdown;
  bool _isDone = false;

  /// Call after a successful resend to begin the wait again.
  void restart() {
    setState(() {
      _isDone = false;
      _duration = _countdown;
    });
  }

  void _onDone() => setState(() => _isDone = true);

  @override
  Widget build(BuildContext context) =>
      _isDone ? _resendButton() : _countdownRow();

  Widget _resendButton() => Align(
    alignment: Alignment.centerRight,
    child: TextButtonUtils(
      onPressed: widget.isResending ? () {} : widget.onResend,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: mainColor,
      text: widget.isResending
          ? 'أعد الإرسال...'.tr()
          : 'لم تستلم الرمز؟ أعد الإرسال'.tr(),
    ),
  );

  Widget _countdownRow() => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      TextUtils(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: blackclr,
        text: 'إعادة الإرسال'.tr(),
      ),
      // Forced to `en` so the countdown renders Latin digits, as the original
      // did — Arabic-Indic numerals here looked wrong next to the code boxes.
      Localizations.override(
        context: context,
        locale: const Locale('en'),
        child: SlideCountdown(
          duration: _duration,
          decoration: const BoxDecoration(color: Colors.transparent),
          style: const TextStyle(
            color: blackclr,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          onDone: _onDone,
        ),
      ),
    ],
  );
}
