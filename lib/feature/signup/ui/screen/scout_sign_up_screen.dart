import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
import '../../../../core/widget/showSuccesSnackBar.dart';
import '../../../../core/widget/slide_enimation_widget.dart';
import '../../../../core/widget/text_from_field_utils_widget.dart';
import '../../../../core/widget/text_utils.dart';
import '../../cubit/scout_register_cubit.dart';

class ScoutSignUpScreen extends StatefulWidget {
  const ScoutSignUpScreen({super.key});

  @override
  State<ScoutSignUpScreen> createState() => _ScoutSignUpScreenState();
}

class _ScoutSignUpScreenState extends State<ScoutSignUpScreen> {
  late ScoutRegisterCubit _cubit;
  final FocusNode _passwordFocusNode = FocusNode();
  final ValueNotifier<String> _passwordNotifier = ValueNotifier('');
  final ValueNotifier<bool> _showValidation = ValueNotifier(false);
  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ScoutRegisterCubit>();

    _cubit.password.addListener(() {
      _passwordNotifier.value = _cubit.password.text;
    });

    _passwordFocusNode.addListener(() {
      _showValidation.value =
          _passwordFocusNode.hasFocus || _cubit.password.text.isNotEmpty;
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
                  text: 'إنشاء حساب كشاف'.tr(),
                ),
                verticalSpace(30),

                // ── First name & Last name ────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: AnimateBuilder(
                        columnCount: 2,
                        position: 0,
                        child: TextFromFieldUtilsWidget(
                          controller: _cubit.firstName,
                          obscureText: false,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
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
                          controller: _cubit.lastName,
                          obscureText: false,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
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

                // ── Email ─────────────────────────────────────────────────────
                AnimateBuilder(
                  columnCount: 1,
                  position: 2,
                  child: TextFromFieldUtilsWidget(
                    controller: _cubit.email,
                    obscureText: false,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'من فضلك تأكد من ادخال البريد الاكتروني'.tr();
                      }
                      if (!AppRegex.isEmailValid(v.trim())) {
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

                // ── Phone ─────────────────────────────────────────────────────
                AnimateBuilder(
                  columnCount: 1,
                  position: 3,
                  child: _buildPhoneField(),
                ),
                verticalSpace(20),

                // ── Gender ────────────────────────────────────────────────────
                AnimateBuilder(
                  columnCount: 1,
                  position: 4,
                  child: _ScoutGenderWidget(cubit: _cubit),
                ),
                verticalSpace(20),

                // ── Profile Image ─────────────────────────────────────────────
                AnimateBuilder(
                  columnCount: 1,
                  position: 5,
                  child: Center(
                    child: Column(
                      children: [
                        _ScoutImageWidget(cubit: _cubit),
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

                // ── Password ──────────────────────────────────────────────────
                _buildPasswordField(),
                verticalSpace(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Phone field ──────────────────────────────────────────────────────────────
  Widget _buildPhoneField() {
    return TextFormField(
      controller: _cubit.phone,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLength: _cubit.maxLength,
      onChanged: (value) {
        _cubit.updatePhoneAvailability();
        if (value.length == _cubit.maxLength) {
          FocusScope.of(context).nextFocus();
        }
      },
      validator: (v) {
        if (v == null || v.trim().length != _cubit.maxLength) {
          return 'من فضلك ادخل رقم الجوال صحيح'.tr();
        }
        if (!AppRegex.isPhoneNumberValid(v.trim())) {
          return 'رقم الجوال غير صالح'.tr();
        }
        return null;
      },
      decoration: InputDecoration(
        counterText: '',
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
        hintText: 'رقم الجوال'.tr(),
        labelText: 'رقم الجوال'.tr(),
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
        prefixText: '${_cubit.codeCountry} ',
        prefixStyle: TextStyle(color: Colors.black87, fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }

  // ── Password field ───────────────────────────────────────────────────────────
  Widget _buildPasswordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _cubit.showPassword,
      builder: (context, showPassword, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimateBuilder(
              columnCount: 1,
              position: 6,
              child: TextFormField(
                controller: _cubit.password,
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: mainColor,
                    ),
                    onPressed: () {
                      _cubit.showPassword.value = !showPassword;
                    },
                  ),
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
              builder: (context, showVal, _) {
                if (!showVal) return const SizedBox();
                return ValueListenableBuilder<String>(
                  valueListenable: _passwordNotifier,
                  builder: (context, pwd, _) {
                    return _buildValidationRequirements(pwd);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  // ── Password strength indicator ──────────────────────────────────────────────
  Widget _buildValidationRequirements(String password) {
    final requirements = [
      _ValidationItem(
          '8 أحرف على الأقل', AppRegex.hasMinLength(password), Icons.text_fields),
      _ValidationItem(
          'حرف كبير (A-Z)', AppRegex.hasUpperCase(password), Icons.text_format),
      _ValidationItem(
          'حرف صغير (a-z)', AppRegex.hasLowerCase(password), Icons.text_fields_outlined),
      _ValidationItem('رقم (0-9)', AppRegex.hasNumber(password), Icons.numbers),
      _ValidationItem(
          'رمز خاص (!@#...)', AppRegex.hasSpecialCharacter(password), Icons.star),
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
            children: requirements.map((req) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: req.isValid
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(
                    color: req.isValid
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      req.icon,
                      size: 14.sp,
                      color: req.isValid ? Colors.green : Colors.red,
                    ),
                    horizontalSpace(6),
                    Text(
                      req.text.tr(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: req.isValid ? Colors.green : Colors.red,
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

  // ── Bottom nav (register button + terms) ─────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      padding: paddingNavBar(),
      height: 180.w,
      child: BlocConsumer<ScoutRegisterCubit, ScoutRegisterState>(
        listener: (context, state) {
          if (state is ScoutRegisterSuccess) {
            showSuccesSnackBar(
              context: context,
              title: 'تم إنشاء الحساب بنجاح! يمكنك تسجيل الدخول الآن'.tr(),
            );
            context.pushNamedAndRemoveUntil(
              AppRoute.loginScreen,
              predicate: (route) => false,
            );
          }
          if (state is ScoutRegisterError) {
            showErrorSnackBar(context: context, title: state.error);
          }
        },
        builder: (context, state) {
          return SlideEnimationWidget(
            index: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: state is ScoutRegisterLoading
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
                                          ..onTap = () {},
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
                          text: 'إنشاء حساب كشاف'.tr(),
                          onPressed: () {
                            if (!_agreedToTerms) {
                              showErrorSnackBar(
                                context: context,
                                title:
                                    'يجب الموافقة على الشروط والسياسات للمتابعة'
                                        .tr(),
                              );
                              return;
                            }
                            _cubit.registerScout();
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
                                  text: 'لديك حساب بالفعل؟'.tr(),
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
}

// ── Local gender widget ───────────────────────────────────────────────────────

class _ScoutGenderWidget extends StatefulWidget {
  final ScoutRegisterCubit cubit;
  const _ScoutGenderWidget({required this.cubit});

  @override
  State<_ScoutGenderWidget> createState() => _ScoutGenderWidgetState();
}

class _ScoutGenderWidgetState extends State<_ScoutGenderWidget> {
  String _genderLabel = '';

  void _showGenderSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              verticalSpace(16),
              TextUtils(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: 'اختر الجنس'.tr(),
              ),
              verticalSpace(20),
              Row(
                children: [
                  Expanded(
                    child: _GenderOption(
                      label: 'ذكر',
                      value: 0,
                      selectedValue: widget.cubit.gender,
                      onTap: () {
                        widget.cubit.gender = 0;
                        setState(() => _genderLabel = 'ذكر');
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: _GenderOption(
                      label: 'أنثى',
                      value: 1,
                      selectedValue: widget.cubit.gender,
                      onTap: () {
                        widget.cubit.gender = 1;
                        setState(() => _genderLabel = 'أنثى');
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
              verticalSpace(20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: _showGenderSheet,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _genderLabel.isEmpty ? 'الجنس'.tr() : _genderLabel,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: _genderLabel.isEmpty
                      ? mainColor.withOpacity(0.5)
                      : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final int value;
  final int selectedValue;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedValue == value;
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected ? mainColor : null,
          border: Border.all(color: isSelected ? mainColor : greyClr),
        ),
        child: Center(
          child: TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.black,
            text: label.tr(),
          ),
        ),
      ),
    );
  }
}

// ── Local image picker widget ─────────────────────────────────────────────────

class _ScoutImageWidget extends StatefulWidget {
  final ScoutRegisterCubit cubit;
  const _ScoutImageWidget({required this.cubit});

  @override
  State<_ScoutImageWidget> createState() => _ScoutImageWidgetState();
}

class _ScoutImageWidgetState extends State<_ScoutImageWidget> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() => _selectedImage = File(image.path));
        widget.cubit.imagePath = image.path;
      }
    } catch (_) {}
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              verticalSpace(16),
              ListTile(
                leading: Icon(Icons.camera_alt, color: mainColor),
                title: Text('الكاميرا'.tr()),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: mainColor),
                title: Text('معرض الصور'.tr()),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              verticalSpace(10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceSheet,
      child: Stack(
        children: [
          Container(
            width: 88.w,
            height: 129.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(color: secondMainColor, width: 5.w),
              color: offWhiteClr,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.cover)
                  : Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.grey[400],
                        size: 40.w,
                      ),
                    ),
            ),
          ),
          PositionedDirectional(
            end: 1,
            bottom: 2,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _selectedImage != null ? Icons.done : Icons.add,
                  color: Colors.white,
                  size: 16.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Validation item model ─────────────────────────────────────────────────────

class _ValidationItem {
  final String text;
  final bool isValid;
  final IconData icon;

  _ValidationItem(this.text, this.isValid, this.icon);
}
