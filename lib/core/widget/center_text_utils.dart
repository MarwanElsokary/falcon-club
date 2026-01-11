import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CenterTextUtils extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final int? maxlines;

  const CenterTextUtils({
    super.key,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
    required this.text,
    this.maxlines,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Text(
        text,
        maxLines: maxlines,
        textAlign: TextAlign.center,
        style: GoogleFonts.cairo(
          color: color,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          letterSpacing: -0.30,
        ),
      ),
    );
  }
}
