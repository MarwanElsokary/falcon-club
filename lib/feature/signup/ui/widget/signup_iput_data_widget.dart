import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:falcon/core/thems/thems.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../../../../core/widget/text_from_field_utils_widget.dart';
import '../../../login/cubit/login_cubit.dart';

// استيراد الـ widgets الأخرى
import 'date_of_birth_widget.dart';
import 'gender_widget.dart';
import 'phone_auth_text_from_field.dart';
import 'position/select_position_widget.dart';
import 'select_best_foot_widget.dart';
import 'select_collage_widget.dart';
import 'select_uni_widget.dart';
import 'show_password_icon_widget.dart';
import 'upload_profile_image_widget.dart';

class SignupIputDataWidget extends StatefulWidget {
  const SignupIputDataWidget({super.key, required this.update});

  final bool update;

  @override
  State<SignupIputDataWidget> createState() => _SignupIputDataWidgetState();
}

class _SignupIputDataWidgetState extends State<SignupIputDataWidget> {
  late LoginCubit _cubit;
  final FocusNode _passwordFocusNode = FocusNode();
  final ValueNotifier<String> _passwordNotifier = ValueNotifier('');
  final ValueNotifier<bool> _showValidation = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    _cubit = context.read<LoginCubit>();

    // تحديث الـ notifier عند تغيير النص
    _cubit.controller.password.addListener(() {
      _passwordNotifier.value = _cubit.controller.password.text;
    });

    _passwordFocusNode.addListener(() {
      _showValidation.value =
          _passwordFocusNode.hasFocus ||
          _cubit.controller.password.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _passwordNotifier.dispose();
    _showValidation.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _cubit.formKey,
      child: Column(
        children: [
          // صورة البروفايل (للـ update فقط)
          if (widget.update) ...[
            const UploadProfileImageWidget(),
            verticalSpace(20),
          ],

          // الحقول المشتركة
          _buildCommonFields(),

          verticalSpace(20),

          // حقل الباسورد (للتسجيل فقط)
          if (!widget.update) ...[_buildPasswordField(), verticalSpace(20)],
        ],
      ),
    );
  }

  Widget _buildCommonFields() {
    if (widget.update) {
      return _buildUpdateFields();
    } else {
      return _buildRegisterFields();
    }
  }

  Widget _buildUpdateFields() {
    return Column(
      children: [
        // الاسم الأول والاسم الأخير
        Row(
          children: [
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 0,
                child: _buildNameField(
                  controller: _cubit.controller.name,
                  hintText: 'ادخل الاسم الاول'.tr(),
                  labelText: 'الاسم الأول'.tr(),
                ),
              ),
            ),
            horizontalSpace(20),
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 1,
                child: _buildNameField(
                  controller: _cubit.controller.lastName,
                  hintText: 'ادخل الاسم الاخير'.tr(),
                  labelText: 'الاسم الاخير'.tr(),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(20),

        // الإيميل والهاتف
        Row(
          children: [
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 2,
                child: _buildEmailField(),
              ),
            ),
            horizontalSpace(20),
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 3,
                child: _buildPhoneField(),
              ),
            ),
          ],
        ),
        verticalSpace(20),

        // الطول والوزن
        Row(
          children: [
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 4,
                child: _buildHeightField(),
              ),
            ),
            horizontalSpace(20),
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 5,
                child: _buildWeightField(),
              ),
            ),
          ],
        ),
        verticalSpace(20),

        // الجنس وتاريخ الميلاد
        Row(
          children: [
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 6,
                child: const EditGenderWidget(),
              ),
            ),
            horizontalSpace(20),
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 7,
                child: const DateOfBirthWidget(),
              ),
            ),
          ],
        ),
        verticalSpace(20),

        // الجامعة والكلية
        Row(
          children: [
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 8,
                child: const SelectUniWidget(),
              ),
            ),
            horizontalSpace(20),
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 9,
                child: const SelectCollageWidget(),
              ),
            ),
          ],
        ),
        verticalSpace(20),

        // القدم المفضلة والمركز
        Row(
          children: [
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 10,
                child: const SelectBestFootWidget(),
              ),
            ),
            horizontalSpace(20),
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 11,
                child: const SelectPositionWidget(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegisterFields() {
    return Column(
      children: [
        // الاسم الأول والاسم الأخير
        Row(
          children: [
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 0,
                child: _buildNameField(
                  controller: _cubit.controller.name,
                  hintText: 'ادخل الاسم الاول'.tr(),
                  labelText: 'الاسم الأول'.tr(),
                ),
              ),
            ),
            horizontalSpace(20),
            Expanded(
              child: AnimateBuilder(
                columnCount: 2,
                position: 1,
                child: _buildNameField(
                  controller: _cubit.controller.lastName,
                  hintText: 'ادخل الاسم الاخير'.tr(),
                  labelText: 'الاسم الاخير'.tr(),
                ),
              ),
            ),
          ],
        ),
        verticalSpace(20),

        // الإيميل
        AnimateBuilder(columnCount: 1, position: 2, child: _buildEmailField()),
        verticalSpace(20),

        // الهاتف
        AnimateBuilder(columnCount: 1, position: 3, child: _buildPhoneField()),
      ],
    );
  }

  Widget _buildPasswordField() {
    return ValueListenableBuilder(
      valueListenable: _cubit.showPassword,
      builder: (context, showPassword, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimateBuilder(
              columnCount: 1,
              position: 4,
              child: TextFormField(
                controller: _cubit.controller.password,
                focusNode: _passwordFocusNode,
                obscureText: showPassword,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'من فضلك أدخل كلمة المرور'.tr();
                  }
                  if (!AppRegex.isPasswordValid(v)) {
                    return 'كلمة المرور غير صالحة'.tr();
                  }
                  return null;
                },
                onChanged: (value) {
                  _passwordNotifier.value = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: BorderSide(color: mainColor, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.w),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  hintText: '********',
                  labelText: 'كلمة المرور'.tr(),
                  labelStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.sp,
                  ),
                  suffixIcon: ShowPasswordIconWidget(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ),

            // عرض شروط الفاليديشن
            ValueListenableBuilder<bool>(
              valueListenable: _showValidation,
              builder: (context, showValidation, _) {
                if (!showValidation) return SizedBox();

                return ValueListenableBuilder<String>(
                  valueListenable: _passwordNotifier,
                  builder: (context, password, _) {
                    return _buildValidationRequirements(password);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildValidationRequirements(String password) {
    final requirements = [
      _ValidationRequirement(
        text: '8 أحرف على الأقل',
        isValid: AppRegex.hasMinLength(password),
        icon: Icons.text_fields,
      ),
      _ValidationRequirement(
        text: 'حرف كبير (A-Z)',
        isValid: AppRegex.hasUpperCase(password),
        icon: Icons.text_format,
      ),
      _ValidationRequirement(
        text: 'حرف صغير (a-z)',
        isValid: AppRegex.hasLowerCase(password),
        icon: Icons.text_fields_outlined,
      ),
      _ValidationRequirement(
        text: 'رقم (0-9)',
        isValid: AppRegex.hasNumber(password),
        icon: Icons.numbers,
      ),
      _ValidationRequirement(
        text: 'رمز خاص (!@#...)',
        isValid: AppRegex.hasSpecialCharacter(password),
        icon: Icons.star,
      ),
    ];

    final completedCount = requirements.where((r) => r.isValid).length;
    final totalCount = requirements.length;
    final progress = completedCount / totalCount;

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط التقدم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'متطلبات كلمة المرور'.tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '$completedCount/$totalCount',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _getProgressColor(progress),
                ),
              ),
            ],
          ),
          verticalSpace(8),

          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: _getProgressColor(progress),
            minHeight: 4.h,
            borderRadius: BorderRadius.circular(2.w),
          ),
          verticalSpace(12),

          // قائمة المتطلبات
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: requirements.map((requirement) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: requirement.isValid
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(
                    color: requirement.isValid
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      requirement.icon,
                      size: 14.sp,
                      color: requirement.isValid ? Colors.green : Colors.red,
                    ),
                    horizontalSpace(6),
                    Text(
                      requirement.text.tr(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: requirement.isValid ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          // مؤشر القوة
          if (password.isNotEmpty) ...[
            verticalSpace(12),
            _buildPasswordStrengthIndicator(password),
          ],
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator(String password) {
    final strength = _calculatePasswordStrength(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'قوة كلمة المرور:'.tr(),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            Text(
              strength.label.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: strength.color,
              ),
            ),
          ],
        ),
        verticalSpace(6),
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4.h,
                margin: EdgeInsets.only(right: index < 3 ? 4.w : 0),
                decoration: BoxDecoration(
                  color: index < strength.level
                      ? strength.color
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.4) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    if (progress < 1.0) return Colors.blue;
    return Colors.green;
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    int score = 0;

    if (AppRegex.hasMinLength(password)) score++;
    if (AppRegex.hasUpperCase(password)) score++;
    if (AppRegex.hasLowerCase(password)) score++;
    if (AppRegex.hasNumber(password)) score++;
    if (AppRegex.hasSpecialCharacter(password)) score++;

    if (score <= 1) return PasswordStrength(1, 'ضعيفة', Colors.red);
    if (score <= 2) return PasswordStrength(2, 'متوسطة', Colors.orange);
    if (score <= 3) return PasswordStrength(3, 'جيدة', Colors.blue);
    return PasswordStrength(4, 'قوية', Colors.green);
  }

  // Widgets مساعدة للحقول
  Widget _buildNameField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
  }) {
    return TextFromFieldUtilsWidget(
      controller: controller,
      obscureText: false,
      validator: (v) {
        if (v!.isEmpty) {
          return 'من فضلك تأكد من ادخال الاسم'.tr();
        }
        return null;
      },
      fillColor: fillColor,
      textInputType: TextInputType.text,
      hintText: hintText,
      lableText: labelText,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildEmailField() {
    return TextFromFieldUtilsWidget(
      controller: _cubit.controller.email,
      obscureText: false,
      validator: (v) {
        if (v!.isEmpty) {
          return 'من فضلك تأكد من ادخال البريد الاكتروني'.tr();
        }
        if (!AppRegex.isEmailValid(v)) {
          return 'من فضلك أدخل بريد إلكتروني صحيح'.tr();
        }
        return null;
      },
      fillColor: fillColor,
      textInputType: TextInputType.emailAddress,
      hintText: 'email@gmail.com',
      lableText: 'البريد الاكتروني'.tr(),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPhoneField() {
    return PhoneAuthTextFormField(
      onChanged: (value) {
        _cubit.changeButtonStatus();
        if (value.toString().length == _cubit.maxLength) {
          FocusScope.of(context).nextFocus();
        }
      },
      maxLength: _cubit.maxLength,
      controller: _cubit.controller.phone,
      obscureText: false,
      validator: (validator) {
        if (validator.toString().length != _cubit.maxLength) {
          return 'من فضلك ادخل رقم الهاتف صحيح'.tr();
        }
        if (!AppRegex.isPhoneNumberValid(validator.toString())) {
          return 'رقم الهاتف غير صالح'.tr();
        }
        return null;
      },
      textInputType: TextInputType.phone,
      hintText: 'رقم الهاتف'.tr(),
      suffix: const Text(''),
    );
  }

  Widget _buildHeightField() {
    return TextFromFieldUtilsWidget(
      controller: _cubit.controller.height,
      obscureText: false,
      validator: (v) {
        if (v!.isEmpty) {
          return 'من فضلك تأكد من أدخل الطول'.tr();
        }
        final height = double.tryParse(v);
        if (height == null || height <= 0) {
          return 'الطول غير صالح'.tr();
        }
        return null;
      },
      fillColor: fillColor,
      textInputType: TextInputType.number,
      hintText: 'أدخل الطول (سم)'.tr(),
      lableText: 'الطول'.tr(),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildWeightField() {
    return TextFromFieldUtilsWidget(
      controller: _cubit.controller.weight,
      obscureText: false,
      validator: (v) {
        if (v!.isEmpty) {
          return 'من فضلك تأكد من ادخال الوزن'.tr();
        }
        final weight = double.tryParse(v);
        if (weight == null || weight <= 0) {
          return 'الوزن غير صالح'.tr();
        }
        return null;
      },
      fillColor: fillColor,
      textInputType: TextInputType.number,
      hintText: 'أدخل الوزن (كجم)'.tr(),
      lableText: 'الوزن'.tr(),
      textInputAction: TextInputAction.next,
    );
  }
}

// كائنات مساعدة
class _ValidationRequirement {
  final String text;
  final bool isValid;
  final IconData icon;

  _ValidationRequirement({
    required this.text,
    required this.isValid,
    required this.icon,
  });
}

class PasswordStrength {
  final int level; // 1-4
  final String label;
  final Color color;

  PasswordStrength(this.level, this.label, this.color);
}
