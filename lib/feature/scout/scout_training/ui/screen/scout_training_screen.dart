import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widget/scout_training_categories_widget.dart';
import '../widget/scout_training_list_widget.dart';

/// شاشة التمارين للكشاف — مستقلة تماماً
/// نفس الشكل بالظبط لكن بـ cubit ومنطق خاص بالكشاف
class ScoutTrainingScreen extends StatelessWidget {
  const ScoutTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(height: context.displayHeight, width: context.displayWidth),
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
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // زرار الرجوع لو الشاشة متفتحتش كـ bottom nav tab
                    verticalSpace(15),
                    const ScoutTrainingCategoriesWidget(),
                    verticalSpace(15),
                    const ScoutTrainingListWidget(),
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
