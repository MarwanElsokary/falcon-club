// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../thems/thems.dart';
import 'text_utils.dart';

void showErrorSnackBar({required BuildContext context, required String title}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: redClr.withOpacity(0.6),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(
        children: [
          SizedBox(
            width: 50.w,
            height: 50.w,
            child: Lottie.asset(
              'assets/lottie/Animation - 1737365629148.json',
              width: 50.w,
              height: 50.w,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                text: title,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
