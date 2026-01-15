// file name: complete_profile_screen.dart
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
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

// استيراد الـ widgets
import '../widget/compact_height_weight_section.dart';
import '../widget/compact_height_weight_selector.dart';
import '../widget/date_of_birth_widget.dart';
import '../widget/gender_widget.dart';
import '../widget/position/select_position_widget.dart';
import '../widget/select_best_foot_widget.dart';
import '../widget/select_collage_widget.dart';
import '../widget/select_uni_widget.dart';
import '../widget/upload_profile_image_widget.dart';

// استيراد الـ height/weight selector

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  @override
  void initState() {
    super.initState();
    // تحميل بيانات المدن عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().emitcountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: 'إكمال الملف الشخصي'.tr()),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is updateProfileSuccess) {
            log('Profile updated successfully');
            // الانتقال للشاشة الرئيسية بعد نجاح التحديث
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/main', (route) => false);
          }
          if (state is updateProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return SingleChildScrollView(
            padding: paddingUtils(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // حقل الطول والوزن
                const CompactHeightWeightSection(),
                verticalSpace(0),

                // الجنس وتاريخ الميلاد في صف واحد
                Row(
                  children: [
                    Expanded(child: const EditGenderWidget()),
                    horizontalSpace(20),
                    Expanded(child: const DateOfBirthWidget()),
                  ],
                ),
                verticalSpace(20),

                // المدينة والجامعة في صف واحد
                Row(
                  children: [
                    Expanded(child: const SelectUniWidget()),
                    horizontalSpace(20),
                    Expanded(child: const SelectCollageWidget()),
                  ],
                ),
                verticalSpace(20),

                // القدم المفضلة والمركز في صف واحد
                Row(
                  children: [
                    Expanded(child: const SelectBestFootWidget()),
                    horizontalSpace(20),
                    Expanded(child: const SelectPositionWidget()),
                  ],
                ),
                verticalSpace(30),
                Center(
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
                ),
                verticalSpace(40),

                // زر الحفظ
                _buildSaveButton(state, cubit),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSaveButton(LoginState state, LoginCubit cubit) {
    return Column(
      children: [
        if (state is updateProfileLoading)
          const CircularProgressIndicator()
        else
          ButtonUtils(
            text: 'حفظ والمتابعة'.tr(),
            onPressed: () {
              _saveProfile(cubit);
            },
            colorstext: Colors.white,
            background: mainColor,
            border: 100.r,
          ),

        verticalSpace(20),

        // زر التخطي
        OutlinedButton(
          onPressed: () async {
            // جلب بيانات المستخدم أولاً إذا كان مسجل دخول
            try {
              // هنا يمكنك إضافة دالة لجلب بيانات البروفايل
              // await cubit.getUserProfile();

              // الانتقال للشاشة الرئيسية
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoute.mainScreen, (route) => false);
            } catch (e) {
              log('Error fetching user data: $e');
              // الانتقال حتى مع وجود خطأ
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoute.mainScreen, (route) => false);
            }
          },
          child: Text(
            'تخطي وإكمال لاحقاً'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: mainColor,
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile(LoginCubit cubit) async {
    // التحقق من البيانات الأساسية
    if (cubit.controller.height.text.isEmpty ||
        cubit.controller.weight.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك أدخل الطول والوزن'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (cubit.gender == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك اختر الجنس'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (cubit.birthDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك اختر تاريخ الميلاد'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (cubit.positionID.value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك اختر المركز'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (cubit.direction == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك اختر القدم المفضلة'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (cubit.selectedUniversityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك اختر الجامعة'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (cubit.selectedCollegesId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('من فضلك اختر الكلية'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Call Complete Registration (Step2)
    cubit.emitCompleteRegistration();
  }
}
