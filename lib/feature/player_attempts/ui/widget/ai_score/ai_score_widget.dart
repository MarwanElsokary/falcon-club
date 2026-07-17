import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/anmiate_builder.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/shared/domain/entities/skill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ai_percent_widget.dart';

class AiScoreWidget extends StatefulWidget {
  const AiScoreWidget({super.key, required this.skill});
  final List<Skill> skill;

  @override
  State<AiScoreWidget> createState() => _AiScoreWidgetState();
}

class _AiScoreWidgetState extends State<AiScoreWidget> {
  PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpace(20),
        SizedBox(
          height: 30.w,
          width: context.displayWidth / 1,
          child: Center(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: widget.skill.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(40.r),
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                        controller.animateToPage(
                          currentIndex,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.r),
                          border: Border.all(
                            color: currentIndex != index
                                ? offWhiteClr.withOpacity(0.5)
                                : Colors.transparent,
                            width: currentIndex != index ? 1.2.w : 0,
                          ),
                          color: currentIndex == index
                              ? Colors.white
                              : offWhiteClr.withOpacity(0.5),
                        ),
                        child: Center(
                          child: CenterTextUtils(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: mainColor,
                            text: widget.skill[index].name,
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace(10),
                  ],
                );
              },
            ),
          ),
        ),
        verticalSpace(20),
        SizedBox(
          height: context.displayWidth / 1.4,
          width: context.displayWidth / 1,
          child: PageView.builder(
            controller: controller,
            itemCount: widget.skill.length,
            physics: PageScrollPhysics(),
            scrollDirection: Axis.horizontal,
            onPageChanged: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            itemBuilder: (context, i) {
              return AnimateBuilder(
                columnCount: 3,
                position: i,
                child: AiPercentWidget(
                  skill: widget.skill[i].name,
                  percent: widget.skill[i].score,
                ),
              );
            },
          ),
        ),
        verticalSpace(20),
      ],
    );
  }
}