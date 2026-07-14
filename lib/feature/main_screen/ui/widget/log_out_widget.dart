import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/thems/thems.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widget/center_text_utils.dart';
import '../../../../../core/widget/slide_enimation_widget.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/fav_icon_click.dart';
import '../../../auth/domain/usecases/log_out.dart';

/// Confirmation dialog for signing out.
///
/// Clearing used to happen *here*, in a button callback: this widget reached for
/// `SharedPrefHelper.clearSpecificSecureData`, `SharedPrefHelper.clearAllData`
/// and `CacheHelper.clearShared` directly, then navigated itself — while the
/// [onLogout] callback every call site dutifully passed was never invoked at all.
///
/// Now the widget knows only that signing out is a thing you can ask for. What
/// that *means* — which keys, which stores, in what order — lives behind
/// [LogOut] → `SessionRepository`, the one place that owns session storage. The
/// callback is finally honoured, so where to go next is the caller's decision
/// rather than something hardcoded in a dialog.
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
                                  await getIt<LogOut>()();
                                  if (!context.mounted) return;
                                  context.pop();
                                  onLogout();
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
                                  Navigator.of(context).pop(false);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    color: primerymainColor,
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