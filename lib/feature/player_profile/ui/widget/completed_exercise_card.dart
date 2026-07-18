import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../profile/domain/entities/completed_exercise.dart';

/// One completed exercise in the grid: photo, title, attempt count. No rating —
/// deliberately (see [CompletedExercise]). Tapping opens the attempt history for
/// this exercise (wired by the parent, which holds the player's id/name/photo).
class CompletedExerciseCard extends StatelessWidget {
  const CompletedExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  final CompletedExercise exercise;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: whiteclr,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFF0EAF8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 100.h, child: _photo()),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextUtils(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    text: exercise.title,
                    maxlines: 2,
                  ),
                  verticalSpace(6),
                  _attemptCount(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _photo() {
    return CachedNetworkImage(
      imageUrl: exercise.photoUrl ?? '',
      fit: BoxFit.cover,
      placeholder: (_, __) => Skeletonizer(
        enabled: true,
        child: Container(color: greyClr.withOpacity(0.15)),
      ),
      errorWidget: (_, __, ___) => Container(
        color: greyClr.withOpacity(0.1),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
        ),
      ),
    );
  }

  Widget _attemptCount() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.repeat_rounded, size: 14.w, color: mainColor),
        horizontalSpace(4),
        TextUtils(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: mainColor,
          text: '${exercise.attemptsCount} ${'محاولة'.tr()}',
        ),
      ],
    );
  }
}
