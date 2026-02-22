import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/di/dependency_injection.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:falcon/feature/signup/ui/widget/pinput_screen_with_navigation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/loading_button_utils.dart';
import 'package:falcon/core/widget/show_error_snack_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../core/enums/user_type.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/padding_nav_bar.dart';
import '../../../../core/widget/slide_enimation_widget.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../login/cubit/login_cubit.dart';
import '../../../login/cubit/login_state.dart';
import '../screen/user_type_selection_screen.dart';

class SignupButtonWidget extends StatefulWidget {
  const SignupButtonWidget({super.key, required this.update});

  final bool update;

  @override
  State<SignupButtonWidget> createState() => _SignupButtonWidgetState();
}

class _SignupButtonWidgetState extends State<SignupButtonWidget> {
  bool _agreedToTerms = false;
  List<String> _termsAndPolicies = [];

  @override
  void initState() {
    super.initState();
    _loadTermsAndPolicies();
  }

  void _loadTermsAndPolicies() {
    final cubit = context.read<LoginCubit>();
    _termsAndPolicies = cubit.termsAndPolicies;

    if (_termsAndPolicies.isEmpty) {
      cubit.getTermsAndPolicies().then((_) {
        if (mounted) {
          setState(() {
            _termsAndPolicies = cubit.termsAndPolicies;
          });
        }
      });
    }
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
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddingNavBar(),
      height: widget.update ? 130.w : 180.w, // زيادة الارتفاع إذا كان إنشاء حساب
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is registerSuccess) {
            showCupertinoModalBottomSheet(
              expand: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (c) => BlocProvider(
                create: (context) => getIt<LoginCubit>(),
                child: PinputScreenWithNavigation(
                  phoneNumber: context.read<LoginCubit>().controller.email.text,
                ),
              ),
            );
            showSuccesSnackBar(
              context: context,
              title: 'تم ارسال الرمز الي بريدك الاكتروني'.tr(),
            );
          }
          if (state is updateProfileSuccess) {
            showSuccesSnackBar(
              context: context,
              title: 'تم تعديل الملف الشخصي بنجاح'.tr(),
            );
            context.pushNamedAndRemoveUntil(
              AppRoute.mainScreen,
              predicate: (route) => false,
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
              child: state is registerLoading || state is updateProfileLoading
                  ? LoadButtonUtils()
                  : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔥 Checkbox الموافقة على الشروط - فقط عند إنشاء حساب جديد
                  if (!widget.update)
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
                  if (!widget.update) verticalSpace(10),
                  ButtonUtils(
                    text: widget.update ? 'تعديل'.tr() : 'انشاء حساب'.tr(),
                    onPressed: () async {
                      // 🔥 التحقق من الموافقة على الشروط (فقط عند إنشاء حساب)
                      if (!widget.update && !_agreedToTerms) {
                        showErrorSnackBar(
                          context: context,
                          title: 'يجب الموافقة على الشروط والسياسات للمتابعة'.tr(),
                        );
                        return;
                      }

                      if (context
                          .read<LoginCubit>()
                          .formKey
                          .currentState!
                          .validate()) {
                        if (widget.update) {
                          context.read<LoginCubit>().emitupdateProfileStates();
                        } else {
                          // Navigate to UserTypeSelectionScreen first
                          final selectedType = await Navigator.push<UserType>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserTypeSelectionScreen(),
                            ),
                          );

                          // If user selected a type, proceed with registration
                          if (selectedType != null && context.mounted) {
                            context.read<LoginCubit>().selectedUserType = selectedType;
                            context.read<LoginCubit>().emitregisterStates();
                          }
                        }
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
                  Visibility(
                    visible: !widget.update,
                    child: InkWell(
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
                            TextSpan(text: ' '),
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