import 'dart:math';
import 'dart:ui';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/feature/home/ui/widget/top_rate_widget/top_three_rate_widget.dart';
import 'package:flutter/material.dart';

class ReverseWidgt extends StatelessWidget {
  const ReverseWidgt({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PositionedDirectional(
          bottom: 0,
          start: 0,
          end: 0,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.93, // ارتفاع الانعكاس
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(pi), // قلب رأسًا على عقب
                child: Opacity(
                  opacity: 0.5,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white, // الجزء العلوي واضح
                          Colors.transparent, // الجزء السفلي يذوب
                        ],
                      ).createShader(
                        Rect.fromLTWH(0, 0, rect.width, rect.height),
                      );
                    },
                    blendMode: BlendMode.dstIn,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: 10, // زيادة Blur تدريجي
                        sigmaY: 10,
                      ),
                      child: TopThreeRateWidget(isReverse: true),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          children: [TopThreeRateWidget(isReverse: false), verticalSpace(135)],
        ), // الويدجت الأصلية
      ],
    );
  }
}
