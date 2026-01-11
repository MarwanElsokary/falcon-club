import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/helpers/extensions.dart';
import '../thems/thems.dart';
import 'text_utils.dart';

PreferredSizeWidget appBarClose({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    centerTitle: false,
    backgroundColor: whiteclr,
    leading: Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: offWhiteClr,
              shape: BoxShape.circle,
            ),
            child: const Center(child: Icon(Icons.close)),
          ),
        ),
      ],
    ),
    surfaceTintColor: Colors.white,
    forceMaterialTransparency: true,
    scrolledUnderElevation: 0,
    title: TextUtils(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      text: title,
    ),
  );
}
