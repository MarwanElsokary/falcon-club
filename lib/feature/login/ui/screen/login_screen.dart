import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/helpers/shared_pref_helper.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:falconclubapp/feature/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../widget/login_button_widget.dart';
import '../widget/login_iput_data_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        state.whenOrNull(
          success: (_) async {
            await Future.delayed(const Duration(milliseconds: 1100));
            String? userToken = await SharedPrefHelper.getSecuredString(
              SharedPrefKeys.userToken,
            );
            log(userToken.toString());

            final userType = await SharedPrefHelper.getSecuredString(
              SharedPrefKeys.userType,
            );

            await SharedPrefHelper.setSecuredString(
              SharedPrefKeys.lang,
              EasyLocalization.of(context)!.locale.toString(),
            );
            if (userToken.toString().isNotEmpty) {
              final String route;
              if (userType == 'Scout') {
                route = AppRoute.scoutMainScreen;
              } else {
                // Club | MainClub | أي role تاني → clubMainScreen
                route = AppRoute.clubMainScreen;
              }
              // ignore: use_build_context_synchronously
              context.pushNamedAndRemoveUntil(
                route,
                predicate: (route) => false,
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.completeProfileScreen,
                    (_) => false,
              );
            }
          },
        );
      },
      child: Scaffold(
        bottomNavigationBar: const LoginButtonWidget(),
        body: SizedBox(
          width: context.displayWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Image
                Align(
                  alignment: Alignment.center,
                  child: SlideEnimationWidget(
                    index: 0,
                    child: Image.asset(
                      'assets/images/login_image.png',
                      fit: BoxFit.cover,
                      width: context.displayWidth,
                      height: 400.w,
                    ),
                  ),
                ),

                /// Content
                Padding(
                  padding: paddingUtils(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtils(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        text: 'تسجيل دخول'.tr(),
                      ),
                      verticalSpace(30),

                      /// Inputs
                      const LoginIputDataWidget(),

                      /// Forget password
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(AppRoute.forgetPasswordScreen);
                          },
                          child: Text(
                            'نسيت كلمة المرور؟'.tr(),
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: mainColor.withOpacity(0.8),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}