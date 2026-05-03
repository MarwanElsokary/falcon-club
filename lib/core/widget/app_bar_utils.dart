import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import '../thems/thems.dart';
import 'text_utils.dart';

PreferredSizeWidget appBarUtils({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    centerTitle: false,
    backgroundColor: whiteclr,

    leading: Row(
      children: [
        const Spacer(),
        Visibility(
          visible: Navigator.canPop(context),
          child: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              margin: EdgeInsets.symmetric(vertical: 3.w),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                // border: Border.all(color: blackclr.withOpacity(0.2)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Platform.isAndroid
                      ? Icons.arrow_back_outlined
                      : Icons.arrow_back_ios_new,
                  size: 20.w,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    surfaceTintColor: Colors.white,

    // forceMaterialTransparency: true,
    title: TextAppBarUtils(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      text: title,
    ),
  );
}

class TextAppBarUtils extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const TextAppBarUtils({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TextAppBarUtilsState createState() => _TextAppBarUtilsState();
}

class _TextAppBarUtilsState extends State<TextAppBarUtils>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward(); // يبدأ الحركة أول ما يظهر
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        //
        final angle = _controller.value * 3 * pi;
        final dy = -1.5 * sin(angle); // حركة عمودية خفيفة جدًا

        return Transform.translate(
          offset: Offset(0, dy), // بس على المحور Y
          child: TextUtils(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.color,
            text: widget.text,
          ),
        );
      },
    );
  }
}
