import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/widget/text_utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widget/all_training_widget.dart';
import '../widget/traning_catogeries_widget.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

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
                    Visibility(
                      visible: Navigator.canPop(context),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              BackButton(color: Colors.black),
                              Expanded(
                                child: TextUtils(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  text: 'الرجوع',
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(5),
                        ],
                      ),
                    ),

                    //catogeries
                    TraningCatogeriesWidget(),
                    verticalSpace(15),
                    AllTrainingWidget(),
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
