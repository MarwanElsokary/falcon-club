import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExperianceCatogeriesWidget extends StatefulWidget {
  const ExperianceCatogeriesWidget({super.key});

  @override
  State<ExperianceCatogeriesWidget> createState() =>
      _ExperianceCatogeriesWidgetState();
}

class _ExperianceCatogeriesWidgetState
    extends State<ExperianceCatogeriesWidget> {
  List<String> dataFilter = ['اللياقة البدنية', 'تقني'];
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.displayWidth / 1,
      height: 40.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // ✅ AnimatedSwitcher عشان نظهر أو نخفي الفلتر المختار بانيميشن
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // أنيميشن جميل من البداية للنهاية
              return SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                axisAlignment: -1,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: selectedFilter == null
                ? const SizedBox.shrink() // مفيش حاجة تظهر لو مفيش فلتر مختار
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = null;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      key: ValueKey(selectedFilter),
                      margin: EdgeInsetsDirectional.only(start: 20.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: mainColor,
                      ),
                      child: Row(
                        children: [
                          CenterTextUtils(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            text: selectedFilter!,
                          ),
                          horizontalSpace(2),
                          GestureDetector(
                            onTap: () {
                              // لما يضغط على علامة X الفلتر يختفي
                              setState(() {
                                selectedFilter = null;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          selectedFilter == null
              ? const SizedBox.shrink() // مفيش حاجة تظهر لو مفيش فلتر مختار
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  height: 25.h,
                  width: 2.w,
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),

          // ✅ القائمة اللي فيها الفلاتر
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: selectedFilter == null ? 20.w : 0,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: dataFilter.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final isSelected = selectedFilter == dataFilter[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            // لو ضغط عليه تاني -> يشيله
                            selectedFilter = null;
                          } else {
                            selectedFilter = dataFilter[index];
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: isSelected ? mainColor : fillColor,
                        ),
                        child: CenterTextUtils(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : mainColor,
                          text: dataFilter[index],
                        ),
                      ),
                    ),
                    horizontalSpace(5),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
