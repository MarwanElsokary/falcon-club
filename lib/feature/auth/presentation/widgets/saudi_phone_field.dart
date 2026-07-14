// `easy_localization` re-exports intl's TextDirection, which collides with
// Flutter's. The original widget did not import easy_localization at all, so it
// never hit this; hide it rather than prefix every use.
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';

/// The Saudi phone field.
///
/// A faithful port of `PhoneAuthTextFormField` (which lives under the legacy
/// `signup/` tree being deleted): the same pill shape (100r border radius), the
/// same `fillColor` fill, the same LTR text direction with the `+966` suffix,
/// the same Cairo typography, the same hidden counter, and the same 9-character
/// cap.
///
/// The [suffix] slot lets the reset screen add its `phone_android` icon exactly
/// as the original did.
class SaudiPhoneField extends StatelessWidget {
  const SaudiPhoneField({
    super.key,
    required this.controller,
    required this.validator,
    this.onChanged,
    this.label,
    this.trailingIcon,
  });

  final TextEditingController controller;
  final String? Function(String?) validator;
  final ValueChanged<String>? onChanged;
  final String? label;

  /// The original reset screen put a grey `phone_android` icon here.
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      textInputAction: TextInputAction.done,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      keyboardType: TextInputType.phone,
      cursorColor: Colors.black,
      textDirection: TextDirection.ltr,
      maxLength: PhoneNumber.saudiInputLength,
      buildCounter:
          (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) => null,
      style: GoogleFonts.cairo(
        color: Colors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.30,
      ),
      decoration: InputDecoration(
        icon: trailingIcon,
        suffix: TextUtils(
          color: blackclr,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          text: ' 966 +',
        ),
        hintText: '5X XXX XXXX',
        hintTextDirection: TextDirection.ltr,
        labelText: label?.tr(),
        labelStyle: GoogleFonts.cairo(
          color: mainColor.withValues(alpha: 0.5),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.30,
        ),
        hintStyle: GoogleFonts.cairo(
          color: mainColor.withValues(alpha: 0.5),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.30,
        ),
        floatingLabelStyle: GoogleFonts.cairo(
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.cairo(
          color: redClr,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: whiteclr),
          borderRadius: BorderRadius.circular(100.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(100.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: whiteclr),
          borderRadius: BorderRadius.circular(100.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}
