import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widget/experiance_catogeries_widget.dart';
import '../widget/experiance_divider_widget.dart';
import '../widget/first_experinance/first_experiance_widget.dart';
import '../widget/second_experiance_widget/second_experiance_widget.dart';

class ExperimentScreen extends StatelessWidget {
  const ExperimentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: context.displayHeight / 1,
            width: context.displayWidth / 1,
          ),
          PositionedDirectional(
            start: 0,
            child: SvgPicture.asset('assets/svgs/Group 386.svg', width: 120.w),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            top: 10.w,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    //catogeries
                    ExperianceCatogeriesWidget(),
                    verticalSpace(15),
                    SizedBox(
                      width: context.displayWidth / 1,
                      height: context.displayHeight / 1.1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //firstExperiance
                            FirstExperianceWidget(),
                            //divider
                            ExperianceDividerWidget(showBottom: true),
                            verticalSpace(10),
                            SecondExperianceWidget(),
                            Container(color: mainColor, height: 130.h),

                            // ExperianceDividerWidget(showBottom: false),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
