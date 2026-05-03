// file name: pin_put_button_widget.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/widget/button_utils.dart';
import 'package:falconclubapp/core/widget/loading_button_utils.dart';
import 'package:falconclubapp/core/widget/show_error_snack_bar.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/thems/thems.dart';
import '../../../login/cubit/login_cubit.dart';
import '../../../login/cubit/login_state.dart';

class PinPutButtonWidget extends StatelessWidget {
  const PinPutButtonWidget({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is VerificationCodeSuccess) {
          // عند نجاح التحقق، انتقل لشاشة إكمال البروفايل
          // أغلاق شاشة التحقق أولاً
          Navigator.of(context).pop();

          // ثم افتح شاشة إكمال البروفايل
          Navigator.of(context).pushNamed(AppRoute.completeProfileScreen);
        }
        if (state is VerificationCodeError) {
          showErrorSnackBar(context: context, title: state.error);
        }
      },
      builder: (context, state) {
        return SlideEnimationWidget(
          index: 0,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: state is VerificationCodeLoading
                ? LoadButtonUtils()
                : ButtonUtils(
                    text: 'تحقق'.tr(),
                    onPressed: () {
                      if (context
                              .read<LoginCubit>()
                              .controller
                              .verifyCode
                              .text
                              .length ==
                          6) {
                        context.read<LoginCubit>().emitverifyCodeStates();
                      } else {
                        showErrorSnackBar(
                          context: context,
                          title: 'من فضلك ادخل الكود المكون من 6 أرقام'.tr(),
                        );
                      }
                    },
                    colorstext: Colors.white,
                    background: mainColor,
                  ),
          ),
        );
      },
    );
  }
}
