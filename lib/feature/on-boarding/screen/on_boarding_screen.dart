import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/routing/routes.dart';
import '../../../core/thems/thems.dart';
import '../../../core/widget/padding_utils.dart';
import '../../../core/widget/text_utils.dart';
import 'screens/on_boarding_first_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  late PageController _pageController;
  late PageController _pageContactController;
  bool showData = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    _pageContactController = PageController(initialPage: currentIndex);

    // إظهار الـ gradient بعد بناء الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showData = true;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List contact = [
      {
        'title': 'راقب تصنيفك بين اللاعبين'.tr(),
        'desc':
            'تابع ترتيبك وشوف وين وصلت بين اللاعبين. كل تمرين تنفّذه وكل فيديو ترفعه يرفع درجتك ويقرّبك للمراكز الأولى.'
                .tr(),
      },
      {
        'title': 'أبرز أفضل لقطاتك'.tr(),
        'desc':
            'اختر تمرين، صوّر نفسك وأنت تؤدّيه، وارفع الفيديو، كل فيديو يقرّبك إنك تنشاف من الأندية.'
                .tr(),
      },
      {
        'title': 'اظهر مهاراتك للأندية'.tr(),
        'desc':
            'اختر تمرين، صوّر نفسك وأنت تؤدّيه، وارفع الفيديو، كل فيديو يقرّبك إنك تنشاف من الأندية.'
                .tr(),
      },
    ];
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              OnBoardingFirstScreen(
                onBoardingImage: 'assets/images/Group 441 1.png',
              ),
              OnBoardingFirstScreen(
                onBoardingImage: 'assets/images/Group 440 1.png',
              ),
              OnBoardingFirstScreen(
                onBoardingImage: 'assets/images/Group 439 1.png',
              ),
            ],
          ),

          PositionedDirectional(
            end: 0.w,
            bottom: 0.h,
            start: 0.w,
            child: Container(
              width: context.displayWidth / 1,
              padding: paddingUtils(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  verticalSpace(250),
                  SizedBox(
                    height: 190.h,
                    width: context.displayWidth / 1,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: showData
                          ? PageView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: contact.length,
                              itemBuilder: (context, index) {
                                return SlideEnimationWidget(
                                  index: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      verticalSpace(40),
                                      TextUtils(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: mainColor,
                                        text: contact[index]['title'],
                                      ),
                                      verticalSpace(10),
                                      TextUtils(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        text: contact[index]['desc'],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              controller: _pageContactController,
                            )
                          : Text(''),
                    ),
                  ),
                  verticalSpace(20),

                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: showData
                                ? SizedBox(
                                    height: 10.w,
                                    child: AnimatedSmoothIndicator(
                                      activeIndex: currentIndex,
                                      count: 3,
                                      onDotClicked: (index) {},
                                      duration: Duration(milliseconds: 500),
                                      axisDirection: Axis.horizontal,
                                      effect: ExpandingDotsEffect(
                                        activeDotColor: mainColor,
                                        dotHeight: 10.w,
                                        dotWidth: 10.w,
                                        dotColor: blackclr.withOpacity(0.2),
                                      ),
                                    ),
                                  )
                                : SizedBox(height: 10.w),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap: () {
                          if (currentIndex == 2) {
                            context.pushNamedAndRemoveUntil(
                              AppRoute.loginScreen,
                              predicate: (route) => false,
                            );
                          } else {
                            setState(() {
                              currentIndex = currentIndex + 1;
                            });
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                            _pageContactController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 10.w,
                          ),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextUtils(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                text: currentIndex == 2
                                    ? 'ابدأ الان'
                                    : 'التالي',
                              ),
                              horizontalSpace(10),
                              SvgPicture.asset(
                                'assets/svgs/arabic_forward.svg',
                                width: 18.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  verticalSpace(20),

                  verticalSpace(10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
