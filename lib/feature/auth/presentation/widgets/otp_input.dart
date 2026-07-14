import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/thems/thems.dart';
import '../../domain/value_objects/otp_code.dart';

/// The 6-digit code field.
///
/// Forced LTR so the digits read left-to-right inside the app's RTL layout —
/// the same treatment the original `PinPutWidget` applied.
///
/// It hands the raw **String** upward. Nothing on this path parses the code as
/// an int, so a leading zero survives.
class OtpInput extends StatelessWidget {
  const OtpInput({
    super.key,
    required this.controller,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: controller,
        length: OtpCode.length,
        keyboardType: TextInputType.number,
        defaultPinTheme: _theme(mainColor.withValues(alpha: 0.3)),
        focusedPinTheme: _theme(mainColor),
        submittedPinTheme: _theme(mainColor),
        onCompleted: onCompleted,
      ),
    );
  }

  PinTheme _theme(Color borderColor) => PinTheme(
    width: 56.w,
    height: 56.w,
    textStyle: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: blackclr,
    ),
    decoration: BoxDecoration(
      color: fillColor,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: borderColor),
    ),
  );
}
