import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExperianceDividerWidget extends StatelessWidget {
  const ExperianceDividerWidget({super.key, required this.showBottom});
  final bool showBottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(height: 50.h, width: context.displayWidth / 1),
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              top: 0,
              child: Container(color: mainColor),
            ),
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 30.w,
              top: 0,
              child: Container(
                height: 20.h,
                decoration: BoxDecoration(
                  color: whiteclr,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showBottom,
              child: PositionedDirectional(
                start: 0,
                end: 0,
                bottom: 0,
                top: 30.w,
                child: Container(
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: whiteclr,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        showBottom
            ? SizedBox.shrink()
            : Container(height: 100.h, color: mainColor),
      ],
    );
  }
}
