import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/widget/showSuccesSnackBar.dart';
import 'package:falconclubapp/feature/signup/ui/widget/club_pinput_screen_with_navigation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/anmiate_builder.dart';
import '../../../../core/widget/app_bar_utils.dart';
import '../../../../core/widget/button_utils.dart';
import '../../../../core/widget/loading_button_utils.dart';
import '../../../../core/widget/padding_nav_bar.dart';
import '../../../../core/widget/padding_utils.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
import '../../../../core/widget/slide_enimation_widget.dart';
import '../../../../core/widget/text_from_field_utils_widget.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../login/cubit/login_cubit.dart';
import '../../../login/cubit/login_state.dart';
import '../widget/gender_widget.dart';
import '../widget/phone_auth_text_from_field.dart';
import '../widget/select_collage_widget.dart';
import '../widget/select_uni_widget.dart';
import '../widget/show_password_icon_widget.dart';
import '../widget/upload_profile_image_widget.dart';

class ClubSignUpScreen extends StatefulWidget {
  const ClubSignUpScreen({super.key});

  @override
  State<ClubSignUpScreen> createState() => _ClubSignUpScreenState();
}

class _ClubSignUpScreenState extends State<ClubSignUpScreen> {
  late LoginCubit _cubit;
  final FocusNode _passwordFocusNode = FocusNode();
  final ValueNotifier<String> _passwordNotifier = ValueNotifier('');
  final ValueNotifier<bool> _showValidation = ValueNotifier(false);
  bool _agreedToTerms = false;
  List<String> _termsAndPolicies = [];

  @override
  void initState() {
    super.initState();
    _cubit = context.read<LoginCubit>();

    _cubit.controller.password.addListener(() {
      _passwordNotifier.value = _cubit.controller.password.text;
    });

    _passwordFocusNode.addListener(() {
      _showValidation.value =
          _passwordFocusNode.hasFocus ||
          _cubit.controller.password.text.isNotEmpty;
    });

    _loadTermsAndPolicies();
  }

  void _loadTermsAndPolicies() {
    _termsAndPolicies = _cubit.termsAndPolicies;

    if (_termsAndPolicies.isEmpty) {
      _cubit.getTermsAndPolicies().then((_) {
        if (mounted) {
          setState(() {
            _termsAndPolicies = _cubit.termsAndPolicies;
          });
        }
      });
    }
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
    return Scaffold(
      appBar: appBarUtils(context: context, title: ''),
      bottomNavigationBar: _buildBottomNav(),
      body: Container(
        padding: paddingUtils(),
        child: SingleChildScrollView(
          child: Form(
            key: _cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  text: 'تسجيل نادي'.tr(),
                ),
                verticalSpace(30),

                // First name & Last name
                Row(
                  children: [
                    Expanded(
                      child: AnimateBuilder(
                        columnCount: 2,
                        position: 0,
                        child: TextFromFieldUtilsWidget(
                          controller: _cubit.controller.name,
                          obscureText: false,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'من فضلك تأكد من ادخال الاسم'.tr();
                            }
                            return null;
                          },
                          fillColor: fillColor,
                          textInputType: TextInputType.text,
                          hintText: 'ادخل الاسم الاول'.tr(),
                          lableText: 'الاسم الأول'.tr(),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    horizontalSpace(20),
                    Expanded(
                      child: AnimateBuilder(
                        columnCount: 2,
                        position: 1,
                        child: TextFromFieldUtilsWidget(
                          controller: _cubit.controller.lastName,
                          obscureText: false,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'من فضلك تأكد من ادخال الاسم'.tr();
                            }
                            return null;
                          },
                          fillColor: fillColor,
                          textInputType: TextInputType.text,
                          hintText: 'ادخل الاسم الاخير'.tr(),
                          lableText: 'الاسم الاخير'.tr(),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(20),

                // Email
                AnimateBuilder(
                  columnCount: 1,
                  position: 2,
                  child: TextFromFieldUtilsWidget(
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
                  ),
                ),
                verticalSpace(20),

                // Phone
                AnimateBuilder(
                  columnCount: 1,
                  position: 3,
                  child: PhoneAuthTextFormField(
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
                        return 'من فضلك ادخل رقم الجوال صحيح'.tr();
                      }
                      if (!AppRegex.isPhoneNumberValid(validator.toString())) {
                        return 'رقم الجوال غير صالح'.tr();
                      }
                      return null;
                    },
                    textInputType: TextInputType.phone,
                    hintText: 'رقم الجوال'.tr(),
                    suffix: const Text(''),
                  ),
                ),
                verticalSpace(20),

                // Gender
                AnimateBuilder(
                  columnCount: 1,
                  position: 4,
                  child: const EditGenderWidget(),
                ),
                verticalSpace(20),

                // City Selection
                AnimateBuilder(
                  columnCount: 1,
                  position: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtils(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        text: 'المدينة'.tr(),
                      ),
                      verticalSpace(8),
                      const SelectUniWidget(),
                    ],
                  ),
                ),
                verticalSpace(20),

                // Club Selection
                AnimateBuilder(
                  columnCount: 1,
                  position: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtils(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        text: 'النادي'.tr(),
                      ),
                      verticalSpace(8),
                      const SelectCollageWidget(),
                    ],
                  ),
                ),
                verticalSpace(20),

                // Profile Image
                AnimateBuilder(
                  columnCount: 1,
                  position: 7,
                  child: Center(
                    child: Column(
                      children: [
                        const UploadProfileImageWidget(),
                        TextUtils(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          text: 'اضغط لإضافة صورة شخصية'.tr(),
                        ),
                      ],
                    ),
                  ),
                ),
                verticalSpace(20),

                // Password
                _buildPasswordField(),
                verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
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
              position: 8,
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
            ValueListenableBuilder<bool>(
              valueListenable: _showValidation,
              builder: (context, showValidation, _) {
                if (!showValidation) return const SizedBox();

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
      _ValidationItem('8 أحرف على الأقل', AppRegex.hasMinLength(password), Icons.text_fields),
      _ValidationItem('حرف كبير (A-Z)', AppRegex.hasUpperCase(password), Icons.text_format),
      _ValidationItem('حرف صغير (a-z)', AppRegex.hasLowerCase(password), Icons.text_fields_outlined),
      _ValidationItem('رقم (0-9)', AppRegex.hasNumber(password), Icons.numbers),
      _ValidationItem('رمز خاص (!@#...)', AppRegex.hasSpecialCharacter(password), Icons.star),
    ];

    final completedCount = requirements.where((r) => r.isValid).length;
    final totalCount = requirements.length;
    final progress = completedCount / totalCount;

    Color progressColor;
    if (progress < 0.4) {
      progressColor = Colors.red;
    } else if (progress < 0.7) {
      progressColor = Colors.orange;
    } else if (progress < 1.0) {
      progressColor = Colors.blue;
    } else {
      progressColor = Colors.green;
    }

    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: Colors.grey[200]!),
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
                  color: progressColor,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            color: progressColor,
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
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: paddingNavBar(),
      height: 180.w,
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is registerSuccess) {
            showCupertinoModalBottomSheet(
              expand: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (c) => BlocProvider(
                create: (context) => getIt<LoginCubit>(),
                child: ClubPinputScreenWithNavigation(
                  phoneNumber: context.read<LoginCubit>().controller.email.text,
                ),
              ),
            );
            showSuccesSnackBar(
              context: context,
              title: 'تم ارسال الرمز الي بريدك الاكتروني'.tr(),
            );
          }
          if (state is registerError) {
            showErrorSnackBar(context: context, title: state.error);
          }
        },
        builder: (context, state) {
          return SlideEnimationWidget(
            index: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: state is registerLoading
                  ? LoadButtonUtils()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Terms checkbox
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreedToTerms = value ?? false;
                                  });
                                },
                                activeColor: mainColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                      fontFamily: 'Cairo',
                                    ),
                                    children: [
                                      TextSpan(text: 'أوافق على '.tr()),
                                      TextSpan(
                                        text: 'الشروط والسياسات'.tr(),
                                        style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _showTermsDialog(context);
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(10),
                        ButtonUtils(
                          text: 'تسجيل نادي'.tr(),
                          onPressed: () {
                            if (!_agreedToTerms) {
                              showErrorSnackBar(
                                context: context,
                                title: 'يجب الموافقة على الشروط والسياسات للمتابعة'.tr(),
                              );
                              return;
                            }

                            if (_cubit.formKey.currentState!.validate()) {
                              _cubit.registerClub();
                            } else {
                              showErrorSnackBar(
                                context: context,
                                title: 'من فضلك ادخل بيناتك'.tr(),
                              );
                            }
                          },
                          colorstext: Colors.white,
                          background: mainColor,
                        ),
                        InkWell(
                          onTap: () {
                            context.pushNamed(AppRoute.loginScreen);
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'لديك حساب ب الفعل؟'.tr(),
                                  style: GoogleFonts.cairo(
                                    color: blackclr,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: 'تسجيل الدخول'.tr(),
                                  style: GoogleFonts.cairo(
                                    color: mainColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: TextUtils(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: mainColor,
          text: 'الشروط والسياسات'.tr(),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_termsAndPolicies.isEmpty)
                Center(
                  child: CircularProgressIndicator(color: mainColor),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _termsAndPolicies
                      .map((term) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: TextUtils(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                              text: '• $term',
                            ),
                          ))
                      .toList(),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: mainColor,
              text: 'فهمت'.tr(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidationItem {
  final String text;
  final bool isValid;
  final IconData icon;

  _ValidationItem(this.text, this.isValid, this.icon);
}
