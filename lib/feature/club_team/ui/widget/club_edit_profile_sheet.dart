import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/button_utils.dart';
import 'package:falconclubapp/core/widget/loading_button_utils.dart';
import 'package:falconclubapp/core/widget/text_from_field_utils_widget.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../cubit/club_team_cubit.dart';
import '../../cubit/club_team_state.dart';

class ClubEditProfileSheet extends StatefulWidget {
  const ClubEditProfileSheet({super.key});

  @override
  State<ClubEditProfileSheet> createState() => _ClubEditProfileSheetState();
}

class _ClubEditProfileSheetState extends State<ClubEditProfileSheet> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ClubTeamCubit>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 16.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: cubit.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: greyClr,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              verticalSpace(16),
              TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'تعديل الملف الشخصي'.tr(),
              ),
              verticalSpace(20),
              // photo picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundColor: fillColor,
                    backgroundImage: cubit.imagePath.isNotEmpty
                        ? FileImage(File(cubit.imagePath))
                        : null,
                    child: cubit.imagePath.isEmpty
                        ? Icon(
                            Icons.camera_alt,
                            color: mainColor,
                            size: 30.w,
                          )
                        : null,
                  ),
                ),
              ),
              verticalSpace(5),
              Center(
                child: TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: blackclr,
                  text: 'تغيير الصورة'.tr(),
                ),
              ),
              verticalSpace(16),
              // first name
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                text: 'الاسم الأول'.tr(),
              ),
              verticalSpace(8),
              TextFromFieldUtilsWidget(
                controller: cubit.firstNameController,
                obscureText: false,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                hintText: 'الاسم الأول'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الأول'.tr();
                  }
                  return null;
                },
              ),
              verticalSpace(12),
              // last name
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                text: 'الاسم الأخير'.tr(),
              ),
              verticalSpace(8),
              TextFromFieldUtilsWidget(
                controller: cubit.lastNameController,
                obscureText: false,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                hintText: 'الاسم الأخير'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الأخير'.tr();
                  }
                  return null;
                },
              ),
              verticalSpace(12),
              // phone number
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                text: 'رقم الهاتف'.tr(),
              ),
              verticalSpace(8),
              TextFromFieldUtilsWidget(
                controller: cubit.phoneController,
                obscureText: false,
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                hintText: 'رقم الهاتف'.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم الهاتف'.tr();
                  }
                  return null;
                },
              ),
              verticalSpace(12),
              // gender
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                text: 'الجنس'.tr(),
              ),
              verticalSpace(8),
              Row(
                children: [
                  Expanded(
                    child: _genderButton(
                      title: 'ذكر'.tr(),
                      value: 0,
                      selected: cubit.gender == 0,
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: _genderButton(
                      title: 'أنثى'.tr(),
                      value: 1,
                      selected: cubit.gender == 1,
                    ),
                  ),
                ],
              ),
              verticalSpace(24),
              // submit button
              BlocConsumer<ClubTeamCubit, ClubTeamState>(
                listener: (context, state) {
                  if (state is clubUpdateProfileSuccess) {
                    Navigator.pop(context);
                  }
                },
                buildWhen: (prev, curr) =>
                    curr is clubUpdateProfileLoading ||
                    curr is clubUpdateProfileSuccess ||
                    curr is clubUpdateProfileError,
                builder: (context, state) {
                  if (state is clubUpdateProfileLoading) {
                    return LoadButtonUtils(backGroundColor: mainColor);
                  }
                  return ButtonUtils(
                    onPressed: () {
                      cubit.emitUpdateProfile();
                    },
                    text: 'حفظ التغييرات'.tr(),
                    colorstext: Colors.white,
                    background: mainColor,
                  );
                },
              ),
              verticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderButton({
    required String title,
    required int value,
    required bool selected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          context.read<ClubTeamCubit>().gender = value;
        });
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? mainColor : fillColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? mainColor : greyClr.withOpacity(0.3),
          ),
        ),
        child: Center(
          child: TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : blackclr,
            text: title,
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        context.read<ClubTeamCubit>().imagePath = image.path;
      });
    }
  }
}
