import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:falconclubapp/core/helpers/constants.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/shared_pref_helper.dart';
import 'package:falconclubapp/core/widget/button_utils.dart';
import 'package:falconclubapp/core/widget/loading_button_utils.dart';
import 'package:falconclubapp/core/widget/showSuccesSnackBar.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/padding_nav_bar.dart';
import '../../../../core/widget/slide_enimation_widget.dart';
import '../../../login/cubit/login_cubit.dart';
import '../../../login/cubit/login_state.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.w,
      padding: paddingNavBar(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is Success) {
            // ── اقرأ الـ role المحفوظ وروّح للشاشة الصح ──────────
            final role = await SharedPrefHelper.getSecuredString(
              SharedPrefKeys.userType,
            );

            String route;
            switch (role) {
              case 'Club':
              case 'MainClub':
                route = AppRoute.mainClubScreen;
                break;
              case 'Scout':
                route = AppRoute.scoutMainScreen;
                break;
              default:
                // fallback — مفروض ما يوصلش هنا
                route = AppRoute.clubMainScreen;
            }

            showSuccesSnackBar(
              context: context,
              title: 'أهلاً، تم تسجيل دخولك بنجاح'.tr(),
            );

            context.pushNamedAndRemoveUntil(route, predicate: (route) => false);
          }

          if (state is Error) {
            // لو الخطأ بسبب Player نعرض dialog مختلف
            final isPlayerError =
                state.error.contains('لاعباً') ||
                state.error.contains('اللاعبين');

            if (isPlayerError) {
              _showPlayerBlockedDialog(context, state.error);
            } else {
              showErrorSnackBar(context: context, title: state.error);
            }
          }
        },
        builder: (context, state) {
          return SlideEnimationWidget(
            index: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              child: state is Loading
                  ? LoadButtonUtils()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonUtils(
                          text: 'تسجيل الدخول'.tr(),
                          onPressed: () {
                            if (context
                                .read<LoginCubit>()
                                .loginformKey
                                .currentState!
                                .validate()) {
                              context.read<LoginCubit>().emitloginStates();
                            } else {
                              showErrorSnackBar(
                                context: context,
                                title: 'من فضلك ادخل بياناتك'.tr(),
                              );
                            }
                          },
                          colorstext: Colors.white,
                          background: mainColor,
                        ),
                        InkWell(
                          onTap: () {
                            context.pushNamed(AppRoute.registrationTypeScreen);
                          },
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'ليس لديك حساب؟'.tr(),
                                  style: GoogleFonts.cairo(
                                    color: blackclr,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.30,
                                  ),
                                ),
                                const TextSpan(text: ' '),
                                TextSpan(
                                  text: 'اشتراك'.tr(),
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

  void _showPlayerBlockedDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sports_soccer_rounded,
                  color: Colors.orange,
                  size: 32.w,
                ),
              ),
              SizedBox(height: 16.h),

              // العنوان
              Text(
                'تطبيق الأندية والكشافين',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),

              // الرسالة
              Text(
                'هذا التطبيق مخصص للأندية والكشافين فقط.\nإذا كنت لاعباً، يرجى استخدام تطبيق اللاعبين.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
              SizedBox(height: 20.h),

              // زرار الإغلاق
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'حسناً',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
