import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
        width: context.displayWidth / 1,
        height: context.displayHeight / 1,
        decoration: BoxDecoration(
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
          // profile image
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
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40.w,
                    ),
                  ),
                ),
              ),
            ),
          ),
          verticalSpace(10),
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text:
                '${profile.data.firstName ?? ''} ${profile.data.lastName ?? ''}',
          ),
          verticalSpace(5),
          TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: greyClr,
            text: profile.data.clubName ?? 'مدرب نادي'.tr(),
          ),
          verticalSpace(20),
          // info cards
          Container(
            width: context.displayWidth / 1,
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
                    value: '${profile.data.phoneNumber ?? ''}',
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
                    value: _genderText(profile.data.gender),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(30),
          // edit button
          Padding(
            padding: paddingUtils(),
            child: InkWell(
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
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: TextUtils(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text: 'تعديل الملف الشخصي'.tr(),
                  ),
                ),
              ),
            ),
          ),
          verticalSpace(40),
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
              onPressed: () =>
                  context.read<ClubTeamCubit>().emitMyProfile(),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
              ),
              child: Text(
                'إعادة المحاولة'.tr(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
