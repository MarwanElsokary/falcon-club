import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:falconclubapp/core/widget/app_bar_utils.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarUtils(context: context, title: ''),
      body: Center(child: Lottie.asset('assets/images/load.json')),
    );
  }
}
