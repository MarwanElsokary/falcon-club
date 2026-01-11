import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/thems/thems.dart';
import '../../../../core/widget/slide_enimation_widget.dart';
import '../../../../core/widget/text_utils.dart';

class TrainingDetailsImageWidget extends StatefulWidget {
  const TrainingDetailsImageWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TrainingDetailsImageWidgetState createState() =>
      _TrainingDetailsImageWidgetState();
}

class _TrainingDetailsImageWidgetState
    extends State<TrainingDetailsImageWidget> {
  final List<String> images = [
    'https://i.pinimg.com/736x/80/a6/1c/80a61caf4529b3b208d2184e09ce8093.jpg',
    'https://i.pinimg.com/1200x/45/fa/32/45fa32f0da771a5a6948623a3adfd33b.jpg',
    "https://i.pinimg.com/1200x/bc/bd/81/bcbd81e37aaa741424bac73e73ffb770.jpg",
    'https://i.pinimg.com/1200x/c2/7c/d3/c27cd3560c8a9738e7204544ebf837b4.jpg',
  ];
  List title = [
    {"title": 'تمارين الضغط لمدة 30 ثانية'},
    {"title": 'تمارين السرعه لمدة 50 دقيقه'},
    {"title": 'تمارين التحكم ب الكره لمدة 1 دقيقه'},
    {"title": 'تطوير مهارات التحكم بالكرة والتسديد بدقة عالية'},
  ];
  int currentIndex = 0;
  int _currentIndex = 0;
  int _nextIndex = 0;
  bool startNext = false;
  double _currentOpacity = 1.0;
  double _nextOpacity = 0.0;
  //

  void _nextImage() {
    setState(() {
      _nextIndex = (_currentIndex + 1) % images.length;
      currentIndex = _nextIndex;
      _currentOpacity = 0.0;
      _nextOpacity = 1.0;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _currentIndex = _nextIndex;
        _currentOpacity = 1.0;
        _nextOpacity = 0.0;
      });
    });
  }

  void _previousImage() {
    setState(() {
      _nextIndex = (_currentIndex - 1) % images.length;
      if (_nextIndex < 0) _nextIndex = images.length - 1;
      _currentOpacity = 0.0;
      _nextOpacity = 1.0;
      currentIndex = _nextIndex;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() {
        _currentIndex = _nextIndex;
        _currentOpacity = 1.0;
        _nextOpacity = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    log(_currentIndex.toString());
    return Stack(
      children: [
        // Current image that's fading out
        Container(
          color: mainColor,
          child: AnimatedOpacity(
            opacity: _currentOpacity,
            duration: const Duration(milliseconds: 300),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                34.r,
              ), // Using .r for responsive border radius
              child: SizedBox(
                width: context.displayWidth / 1,
                height: 500.h,

                child: CachedNetworkImage(
                  width: context.displayWidth / 1,
                  height: 500.h,
                  imageUrl: images[_currentIndex],

                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: context.displayWidth / 1,
                      height: 500.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          34.r,
                        ), // Match the border radius
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Padding(
                    padding: EdgeInsets.all(20.w),
                    child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Next image that's fading in
        AnimatedOpacity(
          opacity: _nextOpacity,
          duration: const Duration(milliseconds: 300),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              34.r,
            ), // Using .r for responsive border radius
            child: SizedBox(
              width: context.displayWidth / 1,
              height: 500.h,

              child: CachedNetworkImage(
                width: context.displayWidth / 1,
                height: 500.h,
                imageUrl: images[_nextIndex],

                fit: BoxFit.cover,
                placeholder: (context, url) => Skeletonizer(
                  enabled: true,
                  child: Container(
                    width: context.displayWidth / 1,
                    height: 500.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        34.r,
                      ), // Match the border radius
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
                ),
              ),
            ),
          ),
        ),

        // Rest title and progress
        PositionedDirectional(
          bottom: 0.w,
          start: 0.w,
          end: 0.w,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.r),
                bottomLeft: Radius.circular(30.r),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(1.0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SlideEnimationWidget(
                    index: 0,
                    child: TextUtils(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      text: title[currentIndex]['title'],
                    ),
                  ),
                ),
                Container(
                  width: context.displayWidth / 1,
                  height: 50.w,
                  // color: greenClr,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: List.generate(
                      title.length, // عدد الـ indicators
                      (index) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w, // horizontalSpace بس مش للأخير
                            ),
                            child: _currentIndex > index
                                ? fullAnimation()
                                : LinearPercentIndicator(
                                    isRTL:
                                        EasyLocalization.of(
                                          context,
                                        )!.locale.toString() ==
                                        'ar',
                                    padding: const EdgeInsets.all(0),
                                    lineHeight: 4.h,
                                    percent: _currentIndex >= index + 1
                                        ? 1
                                        : _currentIndex == index
                                        ? 1
                                        : 0,
                                    barRadius: const Radius.circular(16),
                                    progressColor: Colors.white,
                                    backgroundColor: greyClr.withOpacity(0.5),
                                    animation: true,
                                    animationDuration: _currentIndex == index
                                        ? 7000
                                        : 400,
                                    onAnimationEnd: () {
                                      log(
                                        'Animation ended for index $_currentIndex',
                                      );
                                      if (_currentIndex == index) {
                                        if (currentIndex < images.length - 1) {
                                          _nextImage();
                                        } else {
                                          log('close on boarding screen');
                                        }
                                      }
                                    },
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          top: 0,
          bottom: 0,
          start: 0,
          child: GestureDetector(
            onTap: _previousImage,
            child: Container(
              height: 500.h,
              width: context.displayWidth / 2.4,
              color: Colors.transparent,
            ),
          ),
        ),
        PositionedDirectional(
          top: 0,
          end: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              if (currentIndex == images.length - 1) {
                log('close on boarding screen');
              } else {
                _nextImage();
              }
            },
            child: Container(
              height: 500.h,
              width: context.displayWidth / 2.4,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget fullAnimation() {
    return Container(
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
