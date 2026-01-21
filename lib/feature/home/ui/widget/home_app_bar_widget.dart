import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/anmiate_builder.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/main_screen/cubit/main_cubit.dart';
import 'package:falcon/feature/main_screen/cubit/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBarWidget extends StatelessWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      width: context.displayWidth / 1,
      height: 50.h,
      child: SingleChildScrollView(
        child: Column(
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset('assets/images/Mask group.png', width: 32.w),
                      horizontalSpace(5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextUtils(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: blackclr,
                            text: 'صباح الخير'.tr(),
                          ),
                          verticalSpace(1),
                          BlocBuilder<MainCubit, MainState>(
                            buildWhen: (previous, current) =>
                                current is myProfileLoading ||
                                current is myProfileSuccess ||
                                current is myProfileError,
                            builder: (context, state) {
                              return state.maybeWhen(
                                myProfilesuccess: (myProfiledata) {
                                  return AnimateBuilder(
                                    columnCount: 1,
                                    position: 0,
                                    child: TextUtils(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      text: myProfiledata.data.firstName,
                                    ),
                                  );
                                },
                                orElse: () {
                                  return TextUtils(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    text: '',
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                horizontalSpace(10),

                BlocBuilder<MainCubit, MainState>(
                  buildWhen: (previous, current) =>
                  current is myProfileLoading ||
                      current is myProfileSuccess ||
                      current is myProfileError,
                  builder: (context, state) {
                    return state.maybeWhen(
                      myProfilesuccess: (myProfiledata) {
                        final isCompleted = myProfiledata.data.isCompleted;

                        if (isCompleted) {
                          return const SizedBox.shrink();
                        }

                        return InkWell(
                          onTap: () {
                            context.pushNamed(
                              AppRoute.completeProfileScreen,
                            );
                          },
                          child: Container(
                            height: 45.h,
                            width: 45.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: mainColor.withOpacity(0.1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/svgs/hugeicons_date-time.svg', // أو أي أيقونة
                                  width: 18.w,
                                  color: mainColor,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
                horizontalSpace(10),

                InkWell(
                  onTap: () {
                    if (context
                        .read<MainCubit>()
                        .sliderDrawerKey
                        .currentState!
                        .isDrawerOpen) {
                      context
                          .read<MainCubit>()
                          .sliderDrawerKey
                          .currentState
                          ?.closeDrawer();
                    } else {
                      context
                          .read<MainCubit>()
                          .sliderDrawerKey
                          .currentState
                          ?.openDrawer();
                    }
                  },
                  child: Container(
                    height: 45.h,
                    width: 45.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mainColor.withOpacity(0.1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/drawer_icon.svg',
                          width: 18.w,
                        ),
                      ],
                    ),
                  ),
                ),
                horizontalSpace(10),
                Container(
                  height: 45.h,
                  width: 45.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: mainColor.withOpacity(0.1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/notification_icon.svg',
                        width: 18.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
