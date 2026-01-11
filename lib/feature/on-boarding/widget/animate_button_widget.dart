import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/center_text_utils.dart';

class AnimateButtonWidget extends StatefulWidget {
  const AnimateButtonWidget({super.key, required this.isAuth});
  final bool isAuth;

  @override
  State<AnimateButtonWidget> createState() => _AnimateButtonWidgetState();
}

class _AnimateButtonWidgetState extends State<AnimateButtonWidget> {
  bool startAnimation = false;
  bool showCircle = false;
  double buttonWidth = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  // يبدأ توسيع الزر بعد تأخير
  void _startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      startAnimation = true;
      buttonWidth = context.displayWidth / 1.5; // استخدام context من extensions
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        onEnd: () {
          setState(() {
            showCircle = true; // فقط نفعّل الدائرة عند الضغط
          });
        },
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        width: buttonWidth,
        height: 55.h,
        decoration: BoxDecoration(
          color: startAnimation ? mainColor : Colors.transparent,
          borderRadius: BorderRadius.circular(27.r),
        ),
        child: Stack(
          children: [
            // الدائرة البيضاء المتحركة
            AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              alignment: showCircle
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              curve: Curves.easeInOut,

              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showCircle ? 1.0 : 0.0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  padding: EdgeInsets.all(10.w),
                  decoration: const BoxDecoration(
                    color: whiteclr,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_outlined,
                    color: Colors.black,
                    size: 20.w,
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              start: 0.w,
              top: 0,
              bottom: 0,
              end: 30.w,
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: showCircle ? 1.0 : 0.0,
                  child: CenterTextUtils(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    text: 'Get Started'.tr(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
