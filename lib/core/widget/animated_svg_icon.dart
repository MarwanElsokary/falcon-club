import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers/spacing.dart';

// ignore: must_be_immutable
class AnimatedSvgIcon extends StatefulWidget {
  final String iconPath;
  final VoidCallback? onTap; // Callback for tap event
  final Widget? titleWidget;
  bool isDarkMode = false;
  final Color? color;

  AnimatedSvgIcon({
    super.key,
    required this.iconPath,
    this.onTap,
    this.titleWidget,
    this.color,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedSvgIconState createState() => _AnimatedSvgIconState();
}

class _AnimatedSvgIconState extends State<AnimatedSvgIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Animation duration
    );

    // Define the scale animation
    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Animation curve
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  animateIcon() async {
    _controller.forward(); // Scale down
    await Future.delayed(const Duration(milliseconds: 300)); // Wait for 300ms
    _controller.reverse(); // Scale back up
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // borderRadius: BorderRadius.circular(24),
      onTap: () async {
        animateIcon(); // Trigger animation
        widget.onTap?.call(); // Call the provided onTap callback
      },
      child: widget.titleWidget == null
          ? ScaleTransition(
              scale: _animation,
              child: SvgPicture.asset(
                widget.iconPath,
                color: widget.color,
              ),
            )
          : Row(
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: SvgPicture.asset(widget.iconPath),
                ),
                horizontalSpace(15),
                //title
                widget.titleWidget!,
                //forrword
                widget.iconPath == 'assets/svgs/dlete_accountIcon.svg'
                    ? Container()
                    : const Icon(Icons.arrow_forward_ios)
              ],
            ),
    );
  }
}
