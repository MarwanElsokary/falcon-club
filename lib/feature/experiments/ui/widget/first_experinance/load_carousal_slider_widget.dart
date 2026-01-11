import 'dart:developer';

import 'package:falcon/core/helpers/spacing.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/thems/thems.dart';
import 'experiance_data_widget.dart';
import 'first_experiance_image_widget.dart';

class LoadCarousalSliderWidget extends StatefulWidget {
  const LoadCarousalSliderWidget({
    super.key,
    required this.height,
    required this.padding,
  });
  final double height;
  final double padding;

  @override
  State<LoadCarousalSliderWidget> createState() =>
      _LoadCarousalSliderWidgetState();
}

class _LoadCarousalSliderWidgetState extends State<LoadCarousalSliderWidget> {
  int activeIndex = 0;
  double dragStartX = 0;

  final List data = [
    {
      'image':
          "https://i.pinimg.com/736x/80/a6/1c/80a61caf4529b3b208d2184e09ce8093.jpg",
      'title': 'استراتيجيات الهجوم والدفاع المتوازن في كرة القدم',
      'cat': 'اللياقة البدنية',
    },
    {
      'image':
          "https://i.pinimg.com/1200x/45/fa/32/45fa32f0da771a5a6948623a3adfd33b.jpg",
      'title': 'تمارين القوة والتحمل لتحسين أداء اللاعبين',
      'cat': 'اللياقة البدنية',
    },
    {
      'image':
          "https://i.pinimg.com/1200x/bc/bd/81/bcbd81e37aaa741424bac73e73ffb770.jpg",
      'title': 'تحليل تكتيكي للمباريات الكبرى في كرة القدم',
      'cat': 'اللياقة البدنية',
    },
    {
      'image':
          "https://i.pinimg.com/1200x/c2/7c/d3/c27cd3560c8a9738e7204544ebf837b4.jpg",
      'title': 'تطوير مهارات التحكم بالكرة والتسديد بدقة عالية',
      'cat': 'اللياقة البدنية',
    },
  ];

  double _getWidth(int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (index == activeIndex) {
      return screenWidth - 128.w - widget.padding.w;
    } else if (index < activeIndex - 1 || index > activeIndex + 2) {
      return 0;
    } else {
      return 50.w;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Skeletonizer(
            enabled: true,
            child: Container(
              height: widget.height.h,
              padding: EdgeInsetsDirectional.only(start: widget.padding.w),
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(data.length, (index) {
                    return InkWell(
                      onTap: () {
                        log('open');
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        width: _getWidth(index),
                        height: widget.height.h,
                        margin: EdgeInsets.symmetric(
                          horizontal: _getWidth(index) == 0 ? 0 : 4.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34.r),
                        ),
                        child: Stack(
                          children: [
                            FirstExperianceImageWidget(
                              height: widget.height.h,
                              image: data[index]['image'].toString(),
                            ),

                            PositionedDirectional(
                              bottom: 0,
                              start: 0,
                              end: 0,
                              top: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(34.r),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.8),
                                    ],
                                    stops: const [0.0, 0.6, 1.0],
                                  ),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              bottom: 20.w,
                              start: 10.w,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 1000),
                                child: index == activeIndex
                                    ? SizedBox(
                                        width: _getWidth(index),
                                        child: ExperianceDataWidget(
                                          title: data[index]['title'],
                                          cat: data[index]['cat'],
                                        ),
                                      )
                                    : const Text(''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        verticalSpace(20),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: 4,
            onDotClicked: (index) {},

            duration: Duration(milliseconds: 500),
            axisDirection: Axis.horizontal,
            effect: ExpandingDotsEffect(
              activeDotColor: mainColor,
              dotHeight: 10.w,
              dotWidth: 10.w,
              // ignore: deprecated_member_use
              dotColor: blackclr.withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }
}
