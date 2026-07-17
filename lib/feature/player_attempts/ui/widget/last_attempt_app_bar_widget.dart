import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/app_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/thems/thems.dart';

PreferredSizeWidget lastAttemptAppBar({
  required BuildContext context,
  required String title,
}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: mainColor,
    elevation: 0,
    leading: BackButton(color: Colors.white),
    surfaceTintColor: Colors.white,
    actions: [
      _LottieHalfSpeed(width: 27.w),
      horizontalSpace(15),
    ],
    title: TextAppBarUtils(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      text: title,
    ),
  );
}

// ---------------------------
// Widget خاص باللوتي نصف السرعة
// ---------------------------

class _LottieHalfSpeed extends StatefulWidget {
  final double width;
  const _LottieHalfSpeed({required this.width});

  @override
  State<_LottieHalfSpeed> createState() => _LottieHalfSpeedState();
}

class _LottieHalfSpeedState extends State<_LottieHalfSpeed>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    // لما الأنيميشن يخلص نوقف ٥ ثواني ونبدأ تاني
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: 5));
        _controller.forward(from: 0); // إعادة التشغيل
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/star-magic.json',
      width: widget.width,
      controller: _controller,
      onLoaded: (composition) {
        _controller
          ..duration = composition
              .duration // السرعة الطبيعية
          ..forward(); // تشغيل أول مرة
      },
    );
  }
}
