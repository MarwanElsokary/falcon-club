// ignore_for_file: file_names

import 'package:falcon/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lottie/lottie.dart';

import 'show_short_succes_snack_bar.dart';
import 'slide_enimation_widget.dart';
import 'text_utils.dart';

void showSuccesSnackBar({
  required BuildContext context,
  required String title,
}) {
  if (title.length <= 36) {
    showShortSuccesSnackBar(context: context, title: title);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        backgroundColor: Colors.transparent,
        closeIconColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(0),
        behavior: SnackBarBehavior.floating,
        content: SlideEnimationWidget(
          index: 0,
          child: Container(
            margin: EdgeInsetsDirectional.only(bottom: 10.w),
            padding: EdgeInsetsDirectional.only(bottom: 10.w),
            decoration: const BoxDecoration(
              color: greenClr,

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: Lottie.asset(
                        'assets/lottie/succes_animation.json',
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: TextUtils(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          text: title,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
