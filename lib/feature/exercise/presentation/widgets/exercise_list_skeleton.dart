import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';

/// The loading placeholder for the exercise list.
///
/// A port of `all_training_load.dart` (and its twin,
/// `scout_training_load_widget.dart`): five shimmering rows, the same 112w
/// square, the same two placeholder lines, the same trailing chevron, and the
/// same 110 bottom pad on the last row.
///
/// ## The stock photo is gone
///
/// Both originals put a **live `CachedNetworkImage`** in the placeholder,
/// pointing at a hard-coded Pinterest URL
/// (`https://i.pinimg.com/736x/80/a6/1c/...jpg`) — a real network fetch, on every
/// load, inside the widget whose entire job is to stand in for content that has
/// not loaded yet. It is wrapped in `Skeletonizer(enabled: true)`, which paints
/// its child as a shimmer block, so the downloaded image was never visible.
/// A plain [Container] renders identically and fetches nothing.
class ExerciseListSkeleton extends StatelessWidget {
  const ExerciseListSkeleton({super.key});

  static const int _placeholderRows = 5;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _placeholderRows,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) => Column(
        children: <Widget>[
          Skeletonizer(
            enabled: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    width: 112.w,
                    height: 112.w,
                    color: fillColor,
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      verticalSpace(3),
                      TextUtils(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        text: '10 دقائق جري سريع',
                      ),
                      verticalSpace(3),
                      TextUtils(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: mainColor,
                        text: 'تحمل - توازن',
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    verticalSpace(8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.w,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
          ),
          verticalSpace(index == _placeholderRows - 1 ? 110 : 15),
        ],
      ),
    );
  }
}
