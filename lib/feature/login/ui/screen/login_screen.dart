import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/helpers/shared_pref_helper.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/login/cubit/login_cubit.dart';
import 'package:falcon/feature/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/cubit/user_type_cubit.dart';
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
            final isCompleted =
                await SharedPrefHelper.getBool(SharedPrefKeys.isCompleted) ??
                    false;

            if (isCompleted) {
              // Reload user type before navigating to main screen
              if (context.mounted) {
                await context.read<UserTypeCubit>().loadUserType();
              }
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.mainScreen,
                    (_) => false,
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
                            context.pushNamed(
                              AppRoute.forgetPasswordScreen,
                            );
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
