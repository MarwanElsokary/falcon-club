import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:falcon/core/helpers/spacing.dart';

class OnBoardingTextWidget extends StatefulWidget {
  const OnBoardingTextWidget({super.key});

  @override
  State<OnBoardingTextWidget> createState() => _OnBoardingTextWidgetState();
}

class _OnBoardingTextWidgetState extends State<OnBoardingTextWidget> {
  int index = 0;
  bool startAnimation = false;

  @override
  void initState() {
    _startAnimation();
    super.initState();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      startAnimation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),

      child: startAnimation
          ? DefaultTextStyle(
              style: GoogleFonts.manrope(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(10),
                  AnimatedTextKit(
                    isRepeatingAnimation: false,
                    displayFullTextOnTap: true,
                    pause: const Duration(
                      milliseconds: 100,
                    ), // توقف بسيط بين الجمل
                    onFinished: () {
                      setState(() {
                        index = index + 1;
                      }); // ✅ هنا تقدر تعمل أي حاجة بعد الانتهاء
                    },
                    animatedTexts: [
                      TyperAnimatedText(
                        'Start your journey'.tr(),
                        textStyle: GoogleFonts.manrope(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.30,
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(3),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 100),
                    child: index > 0
                        ? AnimatedTextKit(
                            isRepeatingAnimation: false,
                            displayFullTextOnTap: true,
                            pause: const Duration(
                              milliseconds: 100,
                            ), // توقف بسيط بين الجمل
                            onFinished: () {
                              setState(() {
                                index = index + 1;
                              }); // ✅ هنا تقدر تعمل أي حاجة بعد الانتهاء
                            },
                            animatedTexts: [
                              TyperAnimatedText(
                                'Find jobs or create'.tr(),
                                textStyle: GoogleFonts.manrope(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.30,
                                ),
                              ),
                            ],
                          )
                        : Text(''),
                  ),
                  verticalSpace(3),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 100),
                    child: index > 1
                        ? AnimatedTextKit(
                            isRepeatingAnimation: false,
                            displayFullTextOnTap: true,
                            pause: const Duration(
                              milliseconds: 100,
                            ), // توقف بسيط بين الجمل
                            onFinished: () {
                              setState(() {
                                index = index + 1;
                              }); // ✅ هنا تقدر تعمل أي حاجة بعد الانتهاء
                            },
                            animatedTexts: [
                              TyperAnimatedText(
                                'opportunities.'.tr(),
                                textStyle: GoogleFonts.manrope(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: -0.30,
                                ),
                              ),
                            ],
                          )
                        : Text(''),
                  ),
                ],
              ),
            )
          : Text(''),
    );
  }
}
