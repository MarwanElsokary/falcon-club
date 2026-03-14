import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/constants.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widget/padding_utils.dart';
import '../../../main_screen/data/model/my_profile_model.dart';
import '../../cubit/scout_cubit.dart';

class ScoutProfileScreen extends StatefulWidget {
  const ScoutProfileScreen({super.key});

  @override
  State<ScoutProfileScreen> createState() => _ScoutProfileScreenState();
}

class _ScoutProfileScreenState extends State<ScoutProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ScoutCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.displayWidth,
        height: context.displayHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Frame 1011 1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<ScoutCubit, ScoutState>(
                builder: (context, state) {
                  if (state is ScoutProfileLoading) {
                    return Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 15.w,
                      ),
                    );
                  }
                  if (state is ScoutProfileError) {
                    return _buildError(state.error);
                  }
                  if (state is ScoutProfileSuccess) {
                    return _buildProfile(state.profile);
                  }
                  // Show cached profile if available
                  final cached = context.read<ScoutCubit>().cachedProfile;
                  if (cached != null) return _buildProfile(cached);
                  return Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                      radius: 15.w,
                    ),
                  );
                },
              ),
              // Logout button — top-end (RTL: appears at top-right)
              PositionedDirectional(
                top: 4.h,
                end: 4.w,
                child: IconButton(
                  icon: Icon(Icons.logout, color: mainColor, size: 24.w),
                  onPressed: () => _showLogoutDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(dynamic profileData) {
    MyProfileModel? profile;
    try {
      profile = profileData is MyProfileModel ? profileData : null;
    } catch (_) {}

    final firstName = profile?.data.firstName ?? '';
    final lastName = profile?.data.lastName ?? '';
    final phone = profile?.data.phoneNumber ?? '';
    final photo = profile?.data.photo ?? '';
    final gender = profile?.data.gender;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpace(20),
          // Profile image
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 98.w,
              height: 139.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: secondMainColor, width: 5.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: photo.isNotEmpty
                    ? CachedNetworkImage(
                        width: 98.w,
                        height: 139.w,
                        imageUrl: photo,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Skeletonizer(
                          enabled: true,
                          child: Container(
                            width: 98.w,
                            height: 139.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40.w,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40.w,
                        ),
                      ),
              ),
            ),
          ),
          verticalSpace(10),
          // Scout badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: mainColor.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, color: Colors.white, size: 14.w),
                horizontalSpace(4),
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  text: 'كشاف'.tr(),
                ),
              ],
            ),
          ),
          verticalSpace(8),
          // Full name
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: '$firstName $lastName',
          ),
          verticalSpace(20),
          // Info card: phone | gender
          Container(
            width: context.displayWidth,
            padding: paddingUtils(),
            decoration: BoxDecoration(
              color: secondMainColor,
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(30.r),
                bottomStart: Radius.circular(30.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _infoItem(
                    title: 'الهاتف'.tr(),
                    value: phone,
                  ),
                ),
                Container(
                  height: 40.h,
                  width: 1,
                  color: greyClr.withOpacity(0.3),
                ),
                Expanded(
                  child: _infoItem(
                    title: 'الجنس'.tr(),
                    value: _genderText(gender),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(100),
        ],
      ),
    );
  }

  String _genderText(dynamic gender) {
    if (gender == null) return '';
    if (gender == 0 || gender == 'ذكر') return 'ذكر';
    if (gender == 1 || gender == 'أنثى') return 'أنثى';
    return '$gender';
  }

  Widget _infoItem({required String title, required String value}) {
    return Column(
      children: [
        TextUtils(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: title,
        ),
        verticalSpace(2),
        TextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: value,
          maxlines: 1,
        ),
      ],
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 60.w),
            verticalSpace(20),
            TextUtils(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              text: 'حدث خطأ'.tr(),
            ),
            verticalSpace(10),
            TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
              text: error,
            ),
            verticalSpace(20),
            ElevatedButton(
              onPressed: () => context.read<ScoutCubit>().fetchProfile(),
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              child: Text(
                'إعادة المحاولة'.tr(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: CenterTextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: 'هل تريد تسجيل الخروج؟'.tr(),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await SharedPrefHelper.clearSpecificSecureData(
                        SharedPrefKeys.userToken,
                      );
                      await SharedPrefHelper.clearAllData();
                      Navigator.of(dialogContext).pop();
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
                        fontSize: 16,
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
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: primerymainColor,
                      ),
                      child: CenterTextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        text: 'لا'.tr(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
