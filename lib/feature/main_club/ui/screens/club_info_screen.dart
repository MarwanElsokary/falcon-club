import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/widget/padding_utils.dart';
import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../club_team/cubit/club_team_state.dart';
import '../../../main_screen/data/model/my_profile_model.dart';

class ClubInfoScreen extends StatefulWidget {
  const ClubInfoScreen({super.key});

  @override
  State<ClubInfoScreen> createState() => _ClubInfoScreenState();
}

class _ClubInfoScreenState extends State<ClubInfoScreen> {
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
          child: BlocBuilder<ClubTeamCubit, ClubTeamState>(
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
    final data = profile.data;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpace(20),

          // ── صورة النادي ───────────────────────────────────────────────
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: secondMainColor, width: 4.w),
                color: secondMainColor.withOpacity(0.2),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: data.photo ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 110.w,
                      height: 110.w,
                      color: Colors.white24,
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.shield, color: Colors.white, size: 50.w),
                ),
              ),
            ),
          ),
          verticalSpace(12),

          // ── اسم النادي ────────────────────────────────────────────────
          TextUtils(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: data.firstName ?? '',
          ),

          // ── حالة الاشتراك ─────────────────────────────────────────────
          verticalSpace(6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: (data.isSubscribed == true ? Colors.green : Colors.red)
                  .withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: data.isSubscribed == true ? Colors.green : Colors.red,
              ),
            ),
            child: TextUtils(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: data.isSubscribed == true ? Colors.green : Colors.red,
              text: data.isSubscribed == true ? 'مشترك'.tr() : 'غير مشترك'.tr(),
            ),
          ),

          verticalSpace(20),

          // ── بطاقة المعلومات الأساسية ──────────────────────────────────
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
                    icon: Icons.phone,
                    title: 'الهاتف'.tr(),
                    value: data.phoneNumber ?? '—',
                  ),
                ),
                Container(height: 40.h, width: 1, color: Colors.white24),
                Expanded(
                  child: _infoItem(
                    icon: Icons.email_outlined,
                    title: 'البريد'.tr(),
                    value: data.email ?? '—',
                  ),
                ),
              ],
            ),
          ),

          verticalSpace(24),

          // ── بطاقة تفاصيل إضافية ───────────────────────────────────────
          Padding(
            padding: paddingUtils(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: secondMainColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  _detailRow(
                    icon: Icons.badge_outlined,
                    label: 'رقم الحساب'.tr(),
                    value: data.accountNumber ?? '—',
                  ),
                  _divider(),
                  _detailRow(
                    icon: Icons.sports_soccer,
                    label: 'النادي'.tr(),
                    value: data.clubName ?? '—',
                  ),
                  _divider(),
                  // _detailRow(
                  //   icon: Icons.person_outline,
                  //   label: 'الجنس'.tr(),
                  //   value: _genderText(data.gender),
                  // ),
                ],
              ),
            ),
          ),

          verticalSpace(100),
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18.w),
        verticalSpace(4),
        TextUtils(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
          text: title,
        ),
        verticalSpace(2),
        TextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: value,
          maxlines: 1,
        ),
      ],
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20.w),
          horizontalSpace(12),
          Expanded(
            child: TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              text: label,
            ),
          ),
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: value,
            maxlines: 1,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.white.withOpacity(0.1), height: 1);

  String _genderText(dynamic gender) {
    if (gender == null) return '—';
    if (gender == 0 || gender == 'ذكر') return 'ذكر';
    if (gender == 1 || gender == 'أنثى') return 'أنثى';
    return '$gender';
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 60.w),
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
              onPressed: () => context.read<ClubTeamCubit>().emitMyProfile(),
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
}
