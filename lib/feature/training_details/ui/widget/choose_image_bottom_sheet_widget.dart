import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/thems/thems.dart';

Future chooseImageBootomShet({
  required String title,
  required Function() cameratab,
  required Function() galleryatab,
  required BuildContext context,
}) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: offWhiteClr,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              height: 4.w,
              width: 100.w,
              decoration: BoxDecoration(
                color: greyClr.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            verticalSpace(10),

            // Title
            CenterTextUtils(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: mainColor,
              text: 'اختر الطريقه'.tr(),
            ),
            verticalSpace(15),

            // Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera Option
                Expanded(
                  child: InkWell(
                    onTap: cameratab,
                    borderRadius: BorderRadius.circular(15.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(
                        color: primerymainColor,
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: mainColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: mainColor.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 30.sp,
                              color: mainColor,
                            ),
                          ),
                          verticalSpace(10),
                          TextUtils(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: mainColor,
                            text: 'كاميرا'.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                horizontalSpace(15),

                // Gallery Option
                Expanded(
                  child: InkWell(
                    onTap: galleryatab,
                    borderRadius: BorderRadius.circular(15.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(
                        color: blueClr.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: blueClr.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: blueClr.withOpacity(0.15),
                            ),
                            child: Icon(
                              Icons.photo_library_outlined,
                              size: 30.sp,
                              color: blueClr,
                            ),
                          ),
                          verticalSpace(10),
                          TextUtils(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: blueClr,
                            text: 'المعرض'.tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(20),
          ],
        ),
      );
    },
  );
}
