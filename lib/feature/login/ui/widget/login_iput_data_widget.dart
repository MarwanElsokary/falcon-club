import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/feature/login/ui/widget/show_password_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/widget/text_from_field_utils_widget.dart';
import '../../../login/cubit/login_cubit.dart';

class LoginIputDataWidget extends StatelessWidget {
  const LoginIputDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<LoginCubit>().loginformKey,
      child: Column(
        children: [
          //email or
          TextFromFieldUtilsWidget(
            controller: context.read<LoginCubit>().controller.email,
            obscureText: false,
            validator: (v) {
              if (v!.isEmpty) {
                return 'من فضلك تأكد من ادخال رقم الجوال '.tr();
              }
              return null;
            },
            fillColor: fillColor,
            textInputType: TextInputType.text,
            hintText: '5x xxx xxxx',
            lableText: 'رقم الجوال '.tr(),
            textInputAction: TextInputAction.next,
          ),
          verticalSpace(20),

          //password
          ValueListenableBuilder(
            valueListenable: context.read<LoginCubit>().showPassword,
            builder: (context, showPassword, _) {
              return TextFromFieldUtilsWidget(
                fillColor: fillColor,
                controller: context.read<LoginCubit>().controller.password,
                obscureText: showPassword,
                validator: (v) {
                  if (v!.length < 6) {
                    return 'من فضلك تأكد من ادخال كلمة المرور'.tr();
                  }
                  return null;
                },

                suffix: ShowPasswordIconWidget(),
                textInputType: TextInputType.text,
                hintText: '******',
                lableText: 'انشاء كلمة المرور'.tr(),
                textInputAction: TextInputAction.next,
              );
            },
          ),
        ],
      ),
    );
  }
}
