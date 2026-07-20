import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// A home section's title row: a 26w icon, then the heading.
///
/// `JoinTalentWidget`, `FindYourDirectionWidget` and `TopPlayerWidget` each
/// spell this same shape out inline. Rather than add a fourth copy for the new
/// role sections, it lives here once so they match the others by construction
/// instead of by eye. The existing three are left untouched on purpose — this
/// is a home for new callers, not a refactor of shipped pixels.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.iconAsset,
    required this.title,
    this.color = Colors.black,
  });

  final String iconAsset;
  final String title;

  /// Sections drawn on the purple background pass white; cards keep black.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingUtils(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(iconAsset, width: 26.w),
          horizontalSpace(10),
          Expanded(
            child: TextUtils(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
              text: title,
            ),
          ),
        ],
      ),
    );
  }
}
