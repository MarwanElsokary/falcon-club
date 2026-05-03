import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget rankAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: mainColor,
    centerTitle: false,
    title: SecondTextAppBarUtils(
      text: 'الترتيب'.tr(),
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );
}

class SecondTextAppBarUtils extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;

  const SecondTextAppBarUtils({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
  });

  @override
  _SecondTextAppBarUtilsState createState() => _SecondTextAppBarUtilsState();
}

class _SecondTextAppBarUtilsState extends State<SecondTextAppBarUtils>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Animation duration
    );

    // Define the animation
    _animation =
        Tween<Offset>(
          begin: const Offset(-0.5, 0.0), // Start slightly to the left
          end: const Offset(0.0, 0.0),
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut, // Animation curve
          ),
        );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: TextUtils(
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        color: widget.color,
        text: widget.text,
      ),
    );
  }
}
