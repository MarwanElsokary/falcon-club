import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:falcon/feature/forget_password/ui/forget_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../widget/login_button_widget.dart';
import '../widget/login_iput_data_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: LoginButtonWidget(),
      body: SizedBox(
        width: context.displayWidth / 1,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Align(
                alignment: Alignment.center,
                child: SlideEnimationWidget(
                  index: 0,
                  child: Image.asset(
                    'assets/images/login_image.png',
                    fit: BoxFit.cover,
                    width: context.displayWidth / 1,
                    height: 400.w,
                  ),
                ),
              ),
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
                    LoginIputDataWidget(),
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
    );
  }
}
