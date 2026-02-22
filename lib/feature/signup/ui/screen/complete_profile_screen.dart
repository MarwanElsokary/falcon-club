import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/cubit/user_type_cubit.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/app_bar_utils.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/login/cubit/login_cubit.dart';
import 'package:falcon/feature/login/cubit/login_state.dart';

import '../widget/compact_height_weight_section.dart';
import '../widget/date_of_birth_widget.dart';
import '../widget/gender_widget.dart';
import '../widget/position/select_position_widget.dart';
import '../widget/select_best_foot_widget.dart';
import '../widget/select_collage_widget.dart';
import '../widget/select_uni_widget.dart';
import '../widget/upload_profile_image_widget.dart';

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: 'إكمال الملف الشخصي'.tr()),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: paddingUtils(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CompactHeightWeightSection(),
                verticalSpace(10),

                _buildGenderAndBirthRow(),
                verticalSpace(20),

                _buildLocationRow(),
                verticalSpace(20),

                _buildFootAndPositionRow(),
                verticalSpace(30),

                _buildProfileImageSection(),
                verticalSpace(40),

                _buildActionButtons(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, LoginState state) {
    state.maybeWhen(
      updateProfilesuccess: (_) async {
        log('✅ Profile completed successfully');
        // Reload user type before navigating to main screen
        await context.read<UserTypeCubit>().loadUserType();
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoute.mainScreen,
                (route) => false,
          );
        }
      },
      updateProfileerror: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      orElse: () {},
    );
  }

  Widget _buildGenderAndBirthRow() {
    return Row(
      children: [
        const Expanded(child: EditGenderWidget()),
        horizontalSpace(20),
        const Expanded(child: DateOfBirthWidget()),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        const Expanded(child: SelectUniWidget()),
        horizontalSpace(20),
        const Expanded(child: SelectCollageWidget()),
      ],
    );
  }

  Widget _buildFootAndPositionRow() {
    return Row(
      children: [
        const Expanded(child: SelectBestFootWidget()),
        horizontalSpace(20),
        const Expanded(child: SelectPositionWidget()),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          const UploadProfileImageWidget(),
          verticalSpace(10),
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
            text: 'اضغط لإضافة صورة شخصية'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, LoginState state) {
    final cubit = context.read<LoginCubit>();
    final isLoading = state is updateProfileLoading;

    return Column(
      children: [
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ButtonUtils(
            text: 'حفظ والمتابعة'.tr(),
            onPressed: () => cubit.completeRegistration(),
            colorstext: Colors.white,
            background: mainColor,
            border: 100.r,
          ),

        verticalSpace(20),

        SizedBox(
          width: double.infinity, // عشان يكون نفس طول زرار الحفظ
          child: OutlinedButton(
            onPressed: isLoading ? null : () => _skipToMain(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: mainColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'تخطي وإكمال لاحقاً'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: mainColor,
              ),
            ),
          ),
        ),

      ],
    );
  }

  void _skipToMain(BuildContext context) async {
    // Reload user type before navigating to main screen
    await context.read<UserTypeCubit>().loadUserType();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoute.mainScreen,
            (route) => false,
      );
    }
  }
}