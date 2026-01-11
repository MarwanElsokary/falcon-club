import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/cache/cach_Helper.dart';
import 'package:falcon/feature/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/widget/app_bar_utils.dart';

import 'package:falcon/core/widget/padding_utils.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widget/signUp_button_widget.dart';
import '../widget/signup_iput_data_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.update});
  final bool update;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    if (CacheHelper.getmyProfile() != null) {
      log('my profile is not null');
      context.read<LoginCubit>().controller.name.text =
          CacheHelper.getmyProfile()!.data.firstName ?? '';
      context.read<LoginCubit>().controller.lastName.text =
          CacheHelper.getmyProfile()!.data.lastName ?? '';
      context.read<LoginCubit>().controller.email.text =
          CacheHelper.getmyProfile()!.data.email ?? '';
      context
          .read<LoginCubit>()
          .controller
          .phone
          .text = CacheHelper.getmyProfile()!.data.phoneNumber != null
          ? CacheHelper.getmyProfile()!.data.phoneNumber.toString().substring(4)
          : CacheHelper.getmyProfile()!.data.phoneNumber ?? '';
      context.read<LoginCubit>().controller.height.text =
          '${CacheHelper.getmyProfile()!.data.height ?? ''}';
      context.read<LoginCubit>().controller.weight.text =
          '${CacheHelper.getmyProfile()!.data.weight ?? ''}';
      context.read<LoginCubit>().gender =
          CacheHelper.getmyProfile()!.data.gender == 'ذكر' ? 0 : 1;
      context.read<LoginCubit>().direction =
          CacheHelper.getmyProfile()!.data.direction == 'يمين' ? 0 : 1;
      context.read<LoginCubit>().birthDate =
          CacheHelper.getmyProfile()!.data.birthDate ?? '';
      context.read<LoginCubit>().positionID.value =
          CacheHelper.getmyProfile()!.data.positionId ?? -1;
      context.read<LoginCubit>().positionName.value =
          CacheHelper.getmyProfile()!.data.positionName ?? '';

      context.read<LoginCubit>().selectedDirection =
          '${CacheHelper.getmyProfile()!.data.direction == 'يمين' ? 0 : 1}';

      log(context.read<LoginCubit>().selectedDirection.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: ''),
      bottomNavigationBar: SignupButtonWidget(update: widget.update),
      body: Container(
        padding: paddingUtils(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUtils(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: widget.update ? 'تعديل بيناتك'.tr() : 'انشاء حساب'.tr(),
              ),
              verticalSpace(30),
              SignupIputDataWidget(update: widget.update),
            ],
          ),
        ),
      ),
    );
  }
}
