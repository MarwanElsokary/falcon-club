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

import '../../../../shared/domain/entities/gender.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';
import '../cubit/profile_edit_cubit.dart';
import '../cubit/profile_edit_state.dart';

/// The self-profile edit bottom sheet.
///
/// Moved out of `club_team` and onto [ProfileEditCubit] in Phase 3: the form now
/// lives in the profile feature over the domain, gender is a [Gender] preselected
/// from the real value, the phone is validated through
/// [PhoneNumber.forSaudiRegistration], and the current photo previews until a new
/// one is picked. The `Form` key is local UI state; the cubit holds the data.
class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({super.key});

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _genderError;

  @override
  Widget build(BuildContext context) {
    final ProfileEditCubit cubit = context.read<ProfileEditCubit>();
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
          key: _formKey,
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
              // photo picker — previews the current photo until a new one is
              // picked (the picked file wins).
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundColor: fillColor,
                    backgroundImage: _avatarImage(cubit),
                    child: _avatarImage(cubit) == null
                        ? Icon(Icons.camera_alt, color: mainColor, size: 30.w)
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
              // phone number — strict Saudi format via the value object.
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
                validator: (value) => PhoneNumber.forSaudiRegistration(
                  value ?? '',
                ).fold((failure) => failure.message, (_) => null),
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
                      value: Gender.male,
                      selected: cubit.gender == Gender.male,
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: _genderButton(
                      title: 'أنثى'.tr(),
                      value: Gender.female,
                      selected: cubit.gender == Gender.female,
                    ),
                  ),
                ],
              ),
              if (_genderError != null) ...[
                verticalSpace(6),
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: redClr,
                  text: _genderError!,
                ),
              ],
              verticalSpace(24),
              // submit button
              BlocConsumer<ProfileEditCubit, ProfileEditState>(
                listener: (context, state) {
                  if (state is ProfileEditSuccess) {
                    Navigator.pop(context);
                  }
                },
                buildWhen: (prev, curr) =>
                    curr is ProfileEditSubmitting ||
                    curr is ProfileEditSuccess ||
                    curr is ProfileEditFailure ||
                    curr is ProfileEditInitial,
                builder: (context, state) {
                  if (state is ProfileEditSubmitting) {
                    return LoadButtonUtils(backGroundColor: mainColor);
                  }
                  return ButtonUtils(
                    onPressed: _onSave,
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

  ImageProvider? _avatarImage(ProfileEditCubit cubit) {
    if (cubit.newImagePath != null && cubit.newImagePath!.isNotEmpty) {
      return FileImage(File(cubit.newImagePath!));
    }
    if (cubit.currentPhotoUrl != null && cubit.currentPhotoUrl!.isNotEmpty) {
      return NetworkImage(cubit.currentPhotoUrl!);
    }
    return null;
  }

  void _onSave() {
    final ProfileEditCubit cubit = context.read<ProfileEditCubit>();
    final bool formOk = _formKey.currentState?.validate() ?? false;
    final bool genderOk = cubit.gender != null;
    setState(() => _genderError = genderOk ? null : 'يرجى اختيار الجنس'.tr());
    if (formOk && genderOk) cubit.submit();
  }

  Widget _genderButton({
    required String title,
    required Gender value,
    required bool selected,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          context.read<ProfileEditCubit>().selectGender(value);
          _genderError = null;
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
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => context.read<ProfileEditCubit>().setImage(image.path));
    }
  }
}
