import 'package:flutter/material.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:lottie/lottie.dart';

class BlockAnimation extends StatefulWidget {
  const BlockAnimation({super.key, required this.lottiePath, this.width});
  final String lottiePath;
  final double? width;
  @override
  // ignore: library_private_types_in_public_api
  _BlockAnimationState createState() => _BlockAnimationState();
}

class _BlockAnimationState extends State<BlockAnimation>
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
        onLoaded: (composition) {
          _controller
            ..duration = composition.duration
            ..forward(); // Start playing
        },
      ),
    );
  }
}
