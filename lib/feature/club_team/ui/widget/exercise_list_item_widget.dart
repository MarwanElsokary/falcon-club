import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/model/club_exercises_model.dart';

class ExerciseListItemWidget extends StatelessWidget {
  final ClubExercise exercise;
  final VoidCallback onTap;

  const ExerciseListItemWidget({
    super.key,
    required this.exercise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── صورة التمرين ─────────────────────────────────────
              _buildImage(),
              // ── التفاصيل ─────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtils(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        text: exercise.title,
                        maxlines: 2,
                      ),
                      verticalSpace(6),
                      TextUtils(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: greyClr,
                        text: exercise.description,
                        maxlines: 2,
                      ),
                      if (exercise.skills.isNotEmpty) ...[
                        verticalSpace(8),
                        _buildSkillsRow(),
                      ],
                    ],
                  ),
                ),
              ),
              // ── سهم ─────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 12.w),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: mainColor,
                  size: 14.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 90.w,
      height: 90.w,
      color: mainColor.withOpacity(0.06),
      child: exercise.photoPath != null && exercise.photoPath!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: exercise.photoPath!,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(color: mainColor.withOpacity(0.1)),
              errorWidget: (_, __, ___) => _imgFallback(),
            )
          : _imgFallback(),
    );
  }

  Widget _imgFallback() {
    return Center(
      child: SvgPicture.asset('assets/svgs/unavailabeImage.svg', width: 36.w),
    );
  }

  Widget _buildSkillsRow() {
    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: exercise.skills.take(3).map((skill) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: TextUtils(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: mainColor,
            text: skill,
          ),
        );
      }).toList(),
    );
  }
}
