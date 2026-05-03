import 'package:flutter/material.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';

class OnBoardingImageWidget extends StatefulWidget {
  const OnBoardingImageWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnBoardingImageWidgetState createState() => _OnBoardingImageWidgetState();
}

class _OnBoardingImageWidgetState extends State<OnBoardingImageWidget>
    with TickerProviderStateMixin {
  bool startAnimation = false;

  @override
  void initState() {
    _startAnimation();
    super.initState();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      startAnimation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: startAnimation
          ? SlideEnimationWidget(
              index: 0,
              child: Container(
                // width: context.displayWidth / 1,
                height: context.displayHeight / 1.66,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/onboard_Image.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
