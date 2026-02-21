import 'package:falcon/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingFirstScreen extends StatefulWidget {
  const OnBoardingFirstScreen({super.key, required this.onBoardingImage});
  final String onBoardingImage;

  @override
  State<OnBoardingFirstScreen> createState() => _OnBoardingFirstScreenState();
}

class _OnBoardingFirstScreenState extends State<OnBoardingFirstScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.onBoardingImage == 'assets/images/iPhone 16 Pro Max - 47 2.png'
        ? Column(
            children: [
              Container(
                width: context.displayWidth / 1,
                height: 60.h,
                color: Color(0xFF391b96),
              ),
              Container(
                color: offWhiteClr,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: context.displayWidth / 1,
                        height: 500.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(widget.onBoardingImage),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container(
            color: offWhiteClr,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: context.displayWidth / 1,
                    height: 600.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(widget.onBoardingImage),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
