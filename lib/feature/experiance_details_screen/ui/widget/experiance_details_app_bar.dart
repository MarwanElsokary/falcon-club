import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExperianceDetailsAppBar extends StatefulWidget {
  const ExperianceDetailsAppBar({super.key, required this.title});
  final String title;

  @override
  State<ExperianceDetailsAppBar> createState() =>
      _ExperianceDetailsAppBarState();
}

class _ExperianceDetailsAppBarState extends State<ExperianceDetailsAppBar>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _rippleController;

  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backButtonAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    // Main Animation Controller
    _mainController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    // Ripple Controller - تأثير الموجة
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Slide Animation - ينزل مع bounce
    _slideAnimation = Tween<double>(begin: -1.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Scale Animation - تأثير الـ pop
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Fade Animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    // BackButton Animation - يظهر بعد الـ AppBar
    _backButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.5, 0.9, curve: Curves.elasticOut),
      ),
    );

    // Text Animation - النص يظهر آخر حاجة
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Ripple Animation
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // بدء الأنيميشن
    Future.delayed(Duration(milliseconds: 50), () {
      _mainController.forward();
      _rippleController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _rippleController]),
      builder: (context, child) {
        return Stack(
          children: [
            // Ripple Effect في الخلفية
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: (1 - _rippleAnimation.value).clamp(0.0, 1.0),
                child: Container(
                  height: 115.h * _rippleAnimation.value,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 2.0,
                      colors: [mainColor.withOpacity(0.1), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),

            // الـ AppBar الرئيسي
            Transform.translate(
              offset: Offset(0, _slideAnimation.value * 115.h),
              child: Transform.scale(
                scale: _scaleAnimation.value.clamp(0.0, 1.5),
                child: Opacity(
                  opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0.98)],
                      ),
                      borderRadius: BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(10.r),
                        bottomStart: Radius.circular(10.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: mainColor.withOpacity(0.08),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                          spreadRadius: -5,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    width: context.displayWidth,
                    height: 115.h,
                    child: Column(
                      children: [
                        verticalSpace(40),

                        // BackButton مع Animation
                        Row(
                          children: [
                            Transform.scale(
                              scale: _backButtonAnimation.value.clamp(0.0, 1.5),
                              child: Transform.rotate(
                                angle: (1 - _backButtonAnimation.value) * 0.5,
                                child: Opacity(
                                  opacity: _backButtonAnimation.value.clamp(
                                    0.0,
                                    1.0,
                                  ),
                                  child: BackButton(),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // النص مع Animation
                        Transform.translate(
                          offset: Offset(0, (1 - _textAnimation.value) * 20),
                          child: Opacity(
                            opacity: _textAnimation.value.clamp(0.0, 1.0),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: [
                                      mainColor,
                                      mainColor.withOpacity(0.8),
                                      mainColor,
                                    ],
                                    stops: [0.0, 0.5, 1.0],
                                  ).createShader(bounds);
                                },
                                child: CenterTextUtils(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  text: widget.title,
                                ),
                              ),
                            ),
                          ),
                        ),
                        verticalSpace(5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
