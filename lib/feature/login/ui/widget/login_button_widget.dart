import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/widget/button_utils.dart';
import 'package:falcon/core/widget/loading_button_utils.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:falcon/core/widget/show_error_snack_bar.dart';

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
        listener: (context, state) {
          if (state is Success) {
            showSuccesSnackBar(
              context: context,
              title: "اهلا تم تسجيل دخولك بنجاح".tr(),
            );
            context.pushNamedAndRemoveUntil(
              AppRoute.mainScreen,
              predicate: (route) => false,
            );
          }
          if (state is Error) {
            showErrorSnackBar(context: context, title: state.error);
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
                                title: 'من فضلك ادخل بيناتك'.tr(),
                              );
                            }
                          },
                          colorstext: Colors.white,
                          background: mainColor,
                        ),
                        InkWell(
                          onTap: () {
                            // to login screen
                            context.pushNamed(
                              AppRoute.signUpScreen,
                              arguments: {'update': false},
                            );
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
                                TextSpan(text: ' '),
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
}
