import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:falcon/feature/pinput/ui/screens/pin_put_screen.dart';
import 'package:falcon/feature/login/cubit/login_cubit.dart';
import 'package:falcon/feature/login/cubit/login_state.dart';

import '../../../../core/routing/routes.dart';

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
