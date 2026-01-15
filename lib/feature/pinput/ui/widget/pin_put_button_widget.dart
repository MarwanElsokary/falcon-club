import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/widget/showSuccesSnackBar.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/button_utils.dart';
import '../../../../core/widget/loading_button_utils.dart';
import '../../../../core/widget/show_error_snack_bar.dart';
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
          showSuccesSnackBar(
            context: context,
            title: "اهلا تم تسجيل دخولك بنجاح".tr(),
          );
          context.pushNamedAndRemoveUntil(
            AppRoute.completeProfileScreen,
            predicate: (route) => false,
          );
        }
        if (state is VerificationCodeError) {
          showErrorSnackBar(
            context: context,
            title: 'Please check the code'.tr(),
          );
        }
      },
      builder: (context, state) {
        if (state is VerificationCodeLoading || state is Loading) {
          return const LoadButtonUtils();
        }
        return Visibility(
          visible: context.read<LoginCubit>().isAvailable,
          child: SlideEnimationWidget(
            index: 0,
            child: ButtonUtils(
              text: 'تحقق'.tr(),
              onPressed: () {
                if (context.read<LoginCubit>().isAvailable) {
                  context.read<LoginCubit>().controller.phone.text =
                      phoneNumber;
                  context.read<LoginCubit>().emitverifyCodeStates();
                }
              },
              colorstext: Colors.white,
              background: context.read<LoginCubit>().isAvailable
                  ? mainColor
                  : greyClr,
            ),
          ),
        );
      },
    );
  }
}
