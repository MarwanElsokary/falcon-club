import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A tappable white card row in the same section-card language: a
/// `secondMainColor` icon chip, a title, and a leading (RTL) chevron. Edit is
/// the first user; the upcoming Favorites entry (Phase 6) is the same tile with
/// a different icon/title/route.
class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.onTap,
    this.iconWidth,
  });

  final String iconAsset;
  final String title;
  final VoidCallback onTap;
  final double? iconWidth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        width: context.displayWidth,
        padding: paddingUtils(),
        decoration: BoxDecoration(
          color: whiteclr,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: secondMainColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconAsset,
                  width: iconWidth ?? 20.w,
                  color: secondMainColor,
                ),
              ),
            ),
            horizontalSpace(14),
            Expanded(
              child: TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                text: title,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: secondMainColor,
            ),
          ],
        ),
      ),
    );
  }
}
