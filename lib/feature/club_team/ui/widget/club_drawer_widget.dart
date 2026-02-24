import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/cache/cach_Helper.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/core/widget/url-call.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/widget/show_photo_widget.dart';
import '../../../main_screen/ui/widget/log_out_widget.dart';
import '../../cubit/club_team_cubit.dart';

class ClubDrawerWidget extends StatelessWidget {
  const ClubDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List itemData = [
      {
        'width': 20.w,
        'icon': 'assets/svgs/profile.svg',
        'title': 'الملف الشخصي'.tr(),
        'ontap': () {
          context.pop();
          context.read<ClubTeamCubit>().currentIndex.value = 0;
        },
      },
      {
        'width': 20.w,
        'icon': 'assets/svgs/lock-svgrepo-com.svg',
        'title': 'سياسة الخصوصية'.tr(),
        'ontap': () {
          urlCall(
            context: context,
            url: 'https://falconai.net/api/Website/GetPrivacy',
          );
        },
      },
      {
        'width': 15.w,
        'icon': 'assets/svgs/logout_icon.svg',
        'title': 'تسجيل الخروج'.tr(),
        'ontap': () {
          context.pop();
          showLogoutDialog(
            context,
            () {
              context.pushNamedAndRemoveUntil(
                AppRoute.loginScreen,
                predicate: (route) => false,
              );
            },
            'هل انت متأكد انك تريد تسجيل الخروج من هذا الحساب'.tr(),
            'assets/lottie/Log out.json',
          );
        },
      },
      {
        'width': 20.w,
        'icon': 'assets/svgs/delete-02.svg',
        'title': 'حذف الحساب'.tr(),
        'ontap': () {
          context.pop();
          showLogoutDialog(
            context,
            () {
              context.pushNamedAndRemoveUntil(
                AppRoute.loginScreen,
                predicate: (route) => false,
              );
            },
            'هل انت متأكد انك تريد حذف هذا الحساب'.tr(),
            'assets/lottie/Log out.json',
          );
        },
      },
    ];

    return Drawer(
      width: context.displayWidth / 1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/drawer_back_ground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // user data
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () {
                                showPhotoDialog(
                                  context: context,
                                  image: CacheHelper.getmyProfile() == null
                                      ? ''
                                      : CacheHelper.getmyProfile()!.data
                                              .photo ??
                                          '',
                                  name: CacheHelper.getmyProfile() == null
                                      ? ''
                                      : CacheHelper.getmyProfile()!.data
                                              .firstName ??
                                          '',
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.w,
                                  ),
                                ),
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 48.w,
                                    height: 48.w,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          CacheHelper.getmyProfile() == null
                                              ? ''
                                              : CacheHelper.getmyProfile()!
                                                      .data
                                                      .photo ??
                                                  '',
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Skeletonizer(
                                        enabled: true,
                                        child: Container(
                                          height: 48.w,
                                          width: 48.w,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        padding: EdgeInsets.all(12.w),
                                        decoration: const BoxDecoration(
                                          color: offWhiteClr,
                                        ),
                                        child: Image.asset(
                                          'assets/images/Mask group.png',
                                          width: 48.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            horizontalSpace(10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextUtils(
                                    maxlines: 1,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    text:
                                        'هلا ${CacheHelper.getmyProfile() == null ? '' : CacheHelper.getmyProfile()!.data.firstName ?? ''}!',
                                  ),
                                  verticalSpace(3),
                                  TextUtils(
                                    maxlines: 1,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    text: 'مدرب نادي'.tr(),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                final key = context
                                    .read<ClubTeamCubit>()
                                    .sliderDrawerKey;
                                if (key.currentState!.isDrawerOpen) {
                                  key.currentState?.closeDrawer();
                                } else {
                                  key.currentState?.openDrawer();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: offWhiteClr.withOpacity(0.06),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 25.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      verticalSpace(7),
                      Divider(
                        color: offWhiteClr.withOpacity(0.3),
                        endIndent: 20.w,
                        indent: 20.w,
                      ),
                      verticalSpace(20),
                      ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: itemData.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: itemData[index]['ontap'],
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      itemData[index]['icon'],
                                      width: itemData[index]['width'],
                                      color: itemData[index]['title'] ==
                                              'حذف الحساب'.tr()
                                          ? redClr
                                          : Colors.white,
                                    ),
                                    horizontalSpace(9),
                                    Expanded(
                                      child: TextUtils(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: itemData[index]['title'] ==
                                                'حذف الحساب'.tr()
                                            ? redClr
                                            : Colors.white,
                                        text: itemData[index]['title'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              verticalSpace(10),
                              Visibility(
                                visible: index != itemData.length - 1,
                                child: Divider(
                                  color: greyClr.withOpacity(0.08),
                                ),
                              ),
                              verticalSpace(10),
                            ],
                          );
                        },
                      ),
                      verticalSpace(30),
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
}
