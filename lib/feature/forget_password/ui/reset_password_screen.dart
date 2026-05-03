import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';
import '../../../core/helpers/app_regex.dart';
import '../../../core/routing/routes.dart';
import '../../../core/widget/button_utils.dart';
import '../../../core/widget/showSuccesSnackBar.dart';
import '../cubit/forget_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final ValueNotifier<String> _passwordNotifier = ValueNotifier('');
  final ValueNotifier<bool> _showValidation = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _passwordFocusNode.addListener(() {
      _showValidation.value =
          _passwordFocusNode.hasFocus || (_passwordNotifier.value.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _passwordNotifier.dispose();
    _showValidation.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        state.whenOrNull(
          passwordReset: (message) {
            showSuccesSnackBar(context: context, title: message);

            // العودة إلى شاشة تسجيل الدخول
            Future.delayed(const Duration(milliseconds: 1500), () {
              context.pushNamedAndRemoveUntil(
                AppRoute.loginScreen,
                predicate: (Route<dynamic> route) {
                  return false;
                },
              );
            });
          },
          error: (message) {
            showErrorSnackBar(context: context, title: message);
          },
        );
      },
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: mainColor),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'الرجوع'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: mainColor,
              ),
            ),
          ),
          body: Padding(
            padding: paddingUtils(),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة توضيحية
                    Center(
                      child: Image.asset(
                        'assets/images/Frame 1059 (2).png',
                        height: 200.h,
                        width: 200.h,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.lock_reset,
                          size: 100.w,
                          color: mainColor,
                        ),
                      ),
                    ),
                    verticalSpace(24),

                    Align(
                      alignment: Alignment.center,
                      child: TextUtils(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: mainColor.withAlpha(150),
                        text: 'انشأ كلمة سر جديدة'.tr(),
                      ),
                    ),
                    verticalSpace(30),

                    // حقل كلمة المرور الجديدة
                    ValueListenableBuilder(
                      valueListenable: cubit.showPassword,
                      builder: (context, showPassword, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: cubit.passwordController,
                              focusNode: _passwordFocusNode,
                              obscureText: showPassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: fillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.w),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.w),
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.w),
                                  borderSide: BorderSide(
                                    color: mainColor,
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.w),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                hintText: '********',
                                labelText: 'كلمة المرور الجديدة'.tr(),
                                labelStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    cubit.showPassword.value = !showPassword;
                                  },
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 14.h,
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                              onChanged: (value) {
                                _passwordNotifier.value = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'من فضلك أدخل كلمة المرور'.tr();
                                }
                                if (!AppRegex.isPasswordValid(value)) {
                                  return 'كلمة المرور غير صالحة'.tr();
                                }
                                return null;
                              },
                            ),
                            verticalSpace(10),

                            // متطلبات كلمة المرور
                            ValueListenableBuilder<bool>(
                              valueListenable: _showValidation,
                              builder: (context, showValidation, _) {
                                if (!showValidation) return const SizedBox();

                                return ValueListenableBuilder<String>(
                                  valueListenable: _passwordNotifier,
                                  builder: (context, password, _) {
                                    return _buildPasswordValidationWidget(
                                      password,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    verticalSpace(20),

                    // حقل تأكيد كلمة المرور
                    ValueListenableBuilder(
                      valueListenable: cubit.showConfirmPassword,
                      builder: (context, showConfirmPassword, _) {
                        return TextFormField(
                          controller: cubit.confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          obscureText: showConfirmPassword,
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
                              borderSide: BorderSide(
                                color: mainColor,
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.w),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            hintText: '********',
                            labelText: 'تأكيد كلمة المرور'.tr(),
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey.shade600,
                              ),
                              onPressed: () {
                                cubit.showConfirmPassword.value =
                                    !showConfirmPassword;
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'من فضلك أكد كلمة المرور'.tr();
                            }
                            if (value != cubit.passwordController.text) {
                              return 'كلمات المرور غير متطابقة'.tr();
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    verticalSpace(40),

                    // زر التأكيد
                    state.maybeWhen(
                      resetting: () => Center(
                        child: CircularProgressIndicator(
                          color: mainColor,
                          strokeWidth: 2.0,
                        ),
                      ),
                      orElse: () => SizedBox(
                        width: double.infinity,
                        child: ButtonUtils(
                          text: 'تأكيد تغيير كلمة المرور'.tr(),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (cubit.passwordController.text !=
                                  cubit.confirmPasswordController.text) {
                                showErrorSnackBar(
                                  context: context,
                                  title: 'كلمات المرور غير متطابقة'.tr(),
                                );
                                return;
                              }

                              if (!AppRegex.isPasswordValid(
                                cubit.passwordController.text,
                              )) {
                                showErrorSnackBar(
                                  context: context,
                                  title: 'كلمة المرور غير قوية بما يكفي'.tr(),
                                );
                                return;
                              }

                              cubit.resetPassword(widget.token);
                            } else {
                              showErrorSnackBar(
                                context: context,
                                title: 'من فضلك أدخل بيانات صحيحة'.tr(),
                              );
                            }
                          },
                          colorstext: Colors.white,
                          background: mainColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordValidationWidget(String password) {
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
