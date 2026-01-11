// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../thems/thems.dart';

class TextFromFieldUtilsWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?) validator;
  final String? Function(String?)? onChange;
  final TextInputType textInputType;
  final Widget? suffix;
  final Widget? suffixWidget;
  final Widget? prefix;
  final String hintText;
  final String? lableText;
  final Color? fillColor;
  final int? maxLength;

  final TextInputAction textInputAction; // Add this parameter

  const TextFromFieldUtilsWidget({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.validator,
    required this.textInputType,
    required this.hintText,
    this.fillColor,
    this.onChange,
    this.suffix,
    this.suffixWidget,
    this.prefix,
    this.lableText,
    required this.textInputAction,
    this.maxLength,
  });

  InputDecoration _inputDecoration() {
    return InputDecoration(
      fillColor: fillColor ?? Colors.transparent,
      prefixIcon: (prefix is Text && (prefix as Text).data?.isEmpty == true)
          ? null
          : prefix,
      suffixIcon: suffix,
      suffix: suffixWidget,
      hintText: hintText,

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
      labelText: lableText,
      labelStyle: GoogleFonts.cairo(
        color: mainColor.withOpacity(0.5),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.30,
      ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: GoogleFonts.cairo(
        color: Colors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.30,
      ),
      controller: controller,
      maxLength: maxLength,
      buildCounter:
          (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) => null,
      obscureText: obscureText,
      cursorColor: Colors.black,
      keyboardType: textInputType,
      validator: validator,
      onChanged: onChange,
      textInputAction: textInputAction,
      decoration: _inputDecoration(),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );
  }
}
