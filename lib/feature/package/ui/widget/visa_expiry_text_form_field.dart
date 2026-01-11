import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/thems/thems.dart';

class VisaExpiryTextFormField extends StatelessWidget {
  final TextEditingController controller;

  const VisaExpiryTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      buildCounter:
          (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) => null,
      maxLength: 5,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: 'MM/YY'.tr(),

        fillColor: fillColor,

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
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CardExpiryInputFormatter(),
      ],

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ادخل تاريخ الانتهاء';
        }

        if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value)) {
          return 'تاريخ غير صحيح';
        }

        final parts = value.split('/');
        final month = int.parse(parts[0]);
        final year = int.parse('20${parts[1]}');

        final now = DateTime.now();
        final expiryDate = DateTime(year, month + 1, 0);

        if (expiryDate.isBefore(now)) {
          return 'الكارت منتهي';
        }

        return null;
      },
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}

class CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');

    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    String formatted = text;
    if (text.length >= 3) {
      formatted = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
