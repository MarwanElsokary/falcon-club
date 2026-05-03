import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/shared_pref_helper.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/core/widget/url-call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/widget/padding_utils.dart';
import '../../../main_screen/data/model/my_profile_model.dart';
import '../../cubit/club_team_cubit.dart';
import '../../cubit/club_team_state.dart';
import '../widget/club_edit_profile_sheet.dart';

class ClubProfileScreen extends StatefulWidget {
  const ClubProfileScreen({super.key});

  @override
  State<ClubProfileScreen> createState() => _ClubProfileScreenState();
}

class _ClubProfileScreenState extends State<ClubProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ClubTeamCubit>().emitMyProfile();
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
          child: BlocConsumer<ClubTeamCubit, ClubTeamState>(
            listener: (context, state) {
              if (state is clubUpdateProfileSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم تحديث الملف الشخصي بنجاح'.tr()),
                    backgroundColor: Colors.green,
                  ),
                );
              }
              if (state is clubUpdateProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: redClr,
                  ),
                );
              }
            },
            buildWhen: (previous, current) =>
            current is clubProfileLoading ||
                current is clubProfileSuccess ||
                current is clubProfileError,
            builder: (context, state) {
              return state.maybeWhen(
                myProfileloading: () => Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 15.w,
                  ),
                ),
                myProfileerror: (error) => _buildError(error),
                myProfilesuccess: (profile) => _buildProfile(profile),
                orElse: () => Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 15.w,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(MyProfileModel profile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpace(20),

          // ── صورة البروفايل ────────────────────────────────────────────
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
                child: CachedNetworkImage(
                  width: 98.w,
                  height: 139.w,
                  imageUrl: profile.data.photo ?? '',
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
                    child: Icon(Icons.person, color: Colors.white, size: 40.w),
                  ),
                ),
              ),
            ),
          ),
          verticalSpace(10),

          // ── الاسم ─────────────────────────────────────────────────────
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text:
            '${profile.data.firstName ?? ''} ${profile.data.lastName ?? ''}',
          ),
          verticalSpace(20),

          // ── بطاقة المعلومات: هاتف | جنس | نادي ──────────────────────
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
                    value: profile.data.phoneNumber ?? '',
                  ),
                ),
                Container(
                    height: 40.h, width: 1, color: greyClr.withOpacity(0.3)),
                Expanded(
                  child: _infoItem(
                    title: 'الجنس'.tr(),
                    value: _genderText(profile.data.gender),
                  ),
                ),
                Container(
                    height: 40.h, width: 1, color: greyClr.withOpacity(0.3)),
                Expanded(
                  child: _infoItem(
                    title: 'النادي'.tr(),
                    value: profile.data.clubName ?? '',
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(30),

          // ── قائمة الإجراءات ───────────────────────────────────────────
          Padding(
            padding: paddingUtils(),
            child: Column(
              children: [
                // ── تعديل الملف الشخصي ──────────────────────────────────
                _buildActionItem(
                  icon: 'assets/svgs/svgexport-18 (1) 2.svg',
                  iconWidth: 20.w,
                  title: 'تعديل الملف الشخصي'.tr(),
                  onTap: () {
                    final cubit = context.read<ClubTeamCubit>();
                    cubit.initProfileForm();
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => BlocProvider.value(
                        value: cubit,
                        child: const ClubEditProfileSheet(),
                      ),
                    );
                  },
                ),
                _buildDivider(),

                // ── سياسة الخصوصية ───────────────────────────────────────
                // _buildActionItem(
                //   icon: 'assets/svgs/lock-svgrepo-com.svg',
                //   iconWidth: 20.w,
                //   title: 'سياسة الخصوصية'.tr(),
                //   onTap: () => urlCall(
                //     context: context,
                //     url: 'https://falconclubappai.net/api/Website/GetPrivacy',
                //   ),
                // ),
                // _buildDivider(),

                // ── تسجيل الخروج ─────────────────────────────────────────
                // _buildActionItem(
                //   icon: 'assets/svgs/logout_icon.svg',
                //   iconWidth: 15.w,
                //   title: 'تسجيل الخروج'.tr(),
                //   onTap: () => _showLogoutDialog(context),
                // ),
              ],
            ),
          ),

          verticalSpace(100),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String icon,
    required double iconWidth,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? redClr : Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
                text: title,
              ),
            ),
            SizedBox(width: 12.w),
            SvgPicture.asset(icon, width: iconWidth, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() =>
      Divider(color: Colors.white.withOpacity(0.15), height: 1);

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
            text: title),
        verticalSpace(2),
        TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: value,
            maxlines: 1),
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
                text: 'حدث خطأ'.tr()),
            verticalSpace(10),
            TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
                text: error),
            verticalSpace(20),
            ElevatedButton(
              onPressed: () => context.read<ClubTeamCubit>().emitMyProfile(),
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              child: Text('إعادة المحاولة'.tr(),
                  style: const TextStyle(color: Colors.white)),
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
              borderRadius: BorderRadius.circular(12.r)),
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
                          SharedPrefKeys.userToken);
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
                          borderRadius: BorderRadius.circular(20.r)),
                      child: CenterTextUtils(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          text: 'نعم'.tr()),
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
                          color: primerymainColor),
                      child: CenterTextUtils(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          text: 'لا'.tr()),
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(10),
          ],
        );
      },
    );
  }
}