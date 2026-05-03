import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';

import '../thems/thems.dart';

class ButtonUtils extends StatelessWidget {
  final Color colorstext;
  final Color background;
  final String text;
  final Function() onPressed;
  final String? sameBorder;
  final Color? borderColor;
  final double? border;
  final Widget? contantWidget;

  /// ✅ العرض الاختياري
  final double? customWidth;

  const ButtonUtils({
    required this.text,
    this.border,
    required this.onPressed,
    super.key,
    required this.colorstext,
    required this.background,
    this.sameBorder,
    this.borderColor,
    this.customWidth,
    this.contantWidget, // <== الإضافة هنا
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: customWidth ?? width, // ✅ استخدم العرض المخصص لو متوفر
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(300.w, 50.w),
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  borderColor ??
                  (background == mainColor.withOpacity(0.2)
                      ? mainColor.withOpacity(0.2)
                      : sameBorder == null
                      ? (background == greyClr ? greyClr : mainColor)
                      : background),
            ),
            borderRadius: BorderRadius.circular(border ?? 100.r),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CenterTextUtils(
              fontSize: 16,
              fontWeight: colorstext == mainColor
                  ? FontWeight.w500
                  : FontWeight.w700,
              color: background == greyClr ? dark : colorstext,
              text: text,
            ),
            ?contantWidget,
          ],
        ),
      ),
    );
  }
}
