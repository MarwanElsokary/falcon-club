import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:falconclubapp/feature/pinput/ui/screens/pin_put_screen.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:falconclubapp/feature/login/cubit/login_state.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/widget/showSuccesSnackBar.dart';

class ClubPinputScreenWithNavigation extends StatelessWidget {
  final String phoneNumber;

  const ClubPinputScreenWithNavigation({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is VerificationCodeSuccess) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoute.loginScreen, (route) => false);
        }
        showSuccesSnackBar(
          context: context,
          title: 'تم تسجيل طلب النادي بنجاح، برجاء انتظار مراجعة الإدارة',
        );
      },
      child: PinputScreen(phoneNumber: phoneNumber),
    );
  }
}
