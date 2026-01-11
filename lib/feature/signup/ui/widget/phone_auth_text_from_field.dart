import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';

// ignore: must_be_immutable
class PhoneAuthTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Function validator;
  final TextInputType textInputType;
  final Widget suffix;
  final int maxLength;
  final String hintText;
  void Function(String)? onChanged;

  PhoneAuthTextFormField({
    super.key,
    this.onChanged,
    required this.controller,
    required this.obscureText,
    required this.validator,
    required this.textInputType,
    required this.hintText,
    required this.suffix,
    required this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style: GoogleFonts.cairo(
        color: Colors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.30,
      ),
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.black,
      maxLength: maxLength,
      buildCounter:
          (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) => null,
      onChanged: onChanged,
      keyboardType: textInputType,
      validator: (value) => validator(value),
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        suffix: TextUtils(
          color: blackclr,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          text:
              ' '
              '966 '
              '+',
        ),

        hintText: '5X XXX XXXX',
        hintTextDirection: TextDirection.ltr, // ✅ إضافة اتجاه الـ hint
        labelText: hintText,
        labelStyle: GoogleFonts.cairo(
          color: mainColor.withOpacity(0.5),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.30,
        ),
        hintStyle: GoogleFonts.cairo(
          color: mainColor.withOpacity(0.5),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.30,
        ),

        floatingLabelStyle: GoogleFonts.cairo(
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.30,
        ),
        errorStyle: GoogleFonts.cairo(
          color: redClr,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.30,
        ),
        filled: true,
        fillColor: fillColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: whiteclr),
          borderRadius: BorderRadius.circular(100.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(100.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: whiteclr),
          borderRadius: BorderRadius.circular(100.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // ignore: deprecated_member_use
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}
