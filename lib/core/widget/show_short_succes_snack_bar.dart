// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lottie/lottie.dart';

import '../thems/thems.dart';
import 'slide_enimation_widget.dart';
import 'text_utils.dart';

void showShortSuccesSnackBar({
  required BuildContext context,
  required String title,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 2200),
      backgroundColor: Colors.transparent,
      closeIconColor: Colors.transparent,
      elevation: 0,
      padding: const EdgeInsets.all(0),
      behavior: SnackBarBehavior.floating,
      content: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideEnimationWidget(
              index: 0,
              child: Container(
                margin: EdgeInsetsDirectional.only(bottom: 10.w),
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: greenClr,
                  boxShadow: [
                    BoxShadow(
                      color: greenClr,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 35,
                      height: 35,
                      child: Lottie.asset(
                        'assets/lottie/succes_animation.json',
                        width: 35.w,
                        height: 35.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: 5.w),
                      child: TextUtils(
                        fontSize: 16,
                        maxlines: 1,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        text: title,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
