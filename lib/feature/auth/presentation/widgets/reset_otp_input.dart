import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/thems/thems.dart';
import '../../domain/value_objects/otp_code.dart';

/// The reset-flow code field.
///
/// A faithful port of `PinPutWidgetForget` (`forget_password/data/widgets/
/// pin_put.dart`, which is being deleted): the same full-width LTR `Pinput`, the
/// same white boxes with an 8px radius, the same 60×45 default / 62×47 focused
/// sizing, the same `greyClr` → `mainColor` border transition at 1.8w, and the
/// same 20px digits.
///
/// It is deliberately a **separate widget** from `OtpInput` (the registration
/// one), because the two originals looked different and the brief is to restore
/// each screen's original design exactly.
///
/// The code stays a **String** all the way out — `OtpCode` keeps leading zeros
/// intact.
class ResetOtpInput extends StatelessWidget {
  const ResetOtpInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          controller: controller,
          length: OtpCode.length,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          onCompleted: onCompleted,
          defaultPinTheme: PinTheme(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            height: 45.w,
            width: 60.w,
            textStyle: const TextStyle(fontSize: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: greyClr),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          focusedPinTheme: PinTheme(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            height: 47.w,
            width: 62.w,
            textStyle: const TextStyle(fontSize: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: mainColor, width: 1.8.w),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
