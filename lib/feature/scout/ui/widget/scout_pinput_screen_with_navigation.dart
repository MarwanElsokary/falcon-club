import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:falconclubapp/feature/pinput/ui/screens/pin_put_screen.dart';
import 'package:falconclubapp/feature/login/cubit/login_cubit.dart';
import 'package:falconclubapp/feature/login/cubit/login_state.dart';

import '../../../../core/routing/routes.dart';

/// نفس ClubPinputScreenWithNavigation بس يروح scoutMainScreen
class ScoutPinputScreenWithNavigation extends StatelessWidget {
  final String phoneNumber;

  const ScoutPinputScreenWithNavigation({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is VerificationCodeSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoute.scoutMainScreen,
                (route) => false,
          );
        }
      },
      child: PinputScreen(phoneNumber: phoneNumber),
    );
  }
}