import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/constants.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widget/center_text_utils.dart';
import '../../../../../core/widget/slide_enimation_widget.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/fav_icon_click.dart';

showLogoutDialog(
  BuildContext context,
  VoidCallback onLogout,
  String title,
  String icon,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        actionsPadding: EdgeInsets.all(0.w),
        actionsAlignment: MainAxisAlignment.center,
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        actions: <Widget>[
          SlideEnimationWidget(
            index: 0,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 45.w),
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  width: context.displayWidth / 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      verticalSpace(60),
                      Align(
                        alignment: Alignment.center,
                        child: CenterTextUtils(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          maxlines: 2,
                          text: title,
                        ),
                      ),
                      verticalSpace(20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  await SharedPrefHelper.clearSpecificSecureData(
                                    SharedPrefKeys.userToken,
                                  );
                                  await SharedPrefHelper.clearAllData();
                                  context.pop();

                                  context.pushNamedAndRemoveUntil(
                                    AppRoute.loginScreen,
                                    predicate: (route) => false,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.w),
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: CenterTextUtils(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    text: 'نعم'.tr(),
                                  ),
                                ),
                              ),
                            ),
                            horizontalSpace(15),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pop(false); // Dismiss the dialog
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: primerymainColor,
                                    // border: Border.all(color: mainColor),
                                  ),
                                  child: CenterTextUtils(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    text: 'لا '.tr(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpace(25),
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: 0.w,
                  start: 0.w,
                  end: 0.w,
                  child: Container(
                    padding: EdgeInsets.all(0.w),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: FavIconClick(
                        width: 100.w,
                        lottiePath: icon,
                        start: true,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
