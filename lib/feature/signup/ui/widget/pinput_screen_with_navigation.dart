// file name: pinput_screen_with_navigation.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:falconclubapp/feature/pinput/ui/screens/pin_put_screen.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:falconclubapp/feature/login/cubit/login_state.dart';

class PinputScreenWithNavigation extends StatelessWidget {
  final String phoneNumber;

  const PinputScreenWithNavigation({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is VerificationCodeSuccess) {
          // عند نجاح التحقق، الانتقال لشاشة إكمال البروفايل
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/completeProfileScreen',
                (route) => false,
          );
        }
      },
      child: PinputScreen(phoneNumber: phoneNumber),
    );
  }
}