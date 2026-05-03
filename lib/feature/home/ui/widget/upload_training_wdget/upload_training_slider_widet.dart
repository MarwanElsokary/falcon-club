import 'package:carousel_slider/carousel_slider.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/helpers/spacing.dart';

class UploadTrainingSliderWidet extends StatefulWidget {
  const UploadTrainingSliderWidet({super.key});

  @override
  State<UploadTrainingSliderWidet> createState() =>
      _UploadTrainingSliderWidetState();
}

class _UploadTrainingSliderWidetState extends State<UploadTrainingSliderWidet> {
  int currentIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: 4,
          options: CarouselOptions(
            height: 300.w,
            autoPlay: true,
            enlargeCenterPage: true, // لو مش عايز تكبير العنصر في النص
            enableInfiniteScroll: false,
            autoPlayInterval: const Duration(seconds: 7),
            autoPlayAnimationDuration: const Duration(milliseconds: 2500),
            viewportFraction: 0.5, // 👈 يظهر جزء من العنصر اللي بعده
            padEnds: true, // 👈 يبدأ من أول الشاشة مش من المنتصف
            onPageChanged: (index, reason) {
              currentIndex = index;
              setState(() {});
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                // أي أكشن عند الضغط
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/30be8ee275cc7e42c682eaf0008536f6abcf08bb.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //fav icon
                          Column(
                            children: [
                              //icon
                              SvgPicture.asset(
                                'assets/svgs/fav.svg',
                                width: 20.w,
                              ),
                              verticalSpace(3),
                              //title
                              CenterTextUtils(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                text: '120',
                              ),
                            ],
                          ),
                          //comment icon
                          Column(
                            children: [
                              //icon
                              SvgPicture.asset(
                                'assets/svgs/comment.svg',
                                width: 20.w,
                              ),
                              verticalSpace(3),
                              //title
                              CenterTextUtils(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                text: '30',
                              ),
                            ],
                          ),
                          //share icon
                          Column(
                            children: [
                              //icon
                              SvgPicture.asset(
                                'assets/svgs/share.svg',
                                width: 20.w,
                              ),
                              verticalSpace(3),
                              //title
                              CenterTextUtils(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                text: '50',
                              ),
                            ],
                          ),
                        ],
                      ),
                      verticalSpace(10),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
