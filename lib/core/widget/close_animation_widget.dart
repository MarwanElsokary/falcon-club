import 'package:flutter/material.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:lottie/lottie.dart';

class CloseAnimation extends StatefulWidget {
  const CloseAnimation({super.key, required this.lottiePath, this.width});
  final String lottiePath;
  final double? width;
  @override
  // ignore: library_private_types_in_public_api
  _CloseAnimationState createState() => _CloseAnimationState();
}

class _CloseAnimationState extends State<CloseAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        widget.lottiePath,
        width:
            widget.width ??
            (widget.lottiePath == 'assets/svgs/notification.json'
                ? context.displayWidth / 2
                : context.displayWidth / 1.5),
        controller: _controller,
        repeat: false,
        onLoaded: (composition) {
          _controller.duration = composition.duration;

          // حساب النسبة للفريم ٣١
          // إذا كان إجمالي الفريمات مثلاً ١٠٠، فالفريم ٣١ = 31/100 = 0.31
          double targetFrame = 31.0;
          double totalFrames = composition.durationFrames;
          double stopPoint = targetFrame / totalFrames;

          // تشغيل الأنيميشن حتى النقطة المحددة
          _controller.animateTo(stopPoint);
        },
      ),
    );
  }
}
