import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';

import 'package:lottie/lottie.dart';

import '../thems/thems.dart';

class LoadButtonUtils extends StatefulWidget {
  const LoadButtonUtils({super.key, this.backGroundColor});
  final Color? backGroundColor;

  @override
  State<LoadButtonUtils> createState() => _LoadButtonUtilsState();
}

class _LoadButtonUtilsState extends State<LoadButtonUtils> {
  bool _isCircle = false;

  @override
  void initState() {
    super.initState();
    // Start the animation after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isCircle = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.w,
      child: Align(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: _isCircle ? 50.w : context.displayWidth / 1,
          height: 50.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: widget.backGroundColor ?? offWhiteClr,
            borderRadius: _isCircle
                ? BorderRadius.circular(1000)
                : BorderRadius.circular(12),
          ),
          child: Lottie.asset('assets/lottie/load.json'),
        ),
      ),
    );
  }
}
