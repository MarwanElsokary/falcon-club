import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The white, corner-decorated section card used across the player profile
/// (About / Measurements / Experience). Extracted so the Coach self-profile can
/// speak the same visual language and future sections (e.g. a Favorites card)
/// drop into the same chrome.
///
/// Chrome is byte-for-byte the player card: full-bleed white `borderRadius(30)`
/// container over `paddingUtils()`, a 20/w700 black title, then [child], with
/// `Group 385` pinned top-start and `Group 386-2` (120w) bottom-end.
class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.displayWidth,
          padding: paddingUtils(),
          decoration: BoxDecoration(
            color: whiteclr,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextUtils(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                text: title,
              ),
              verticalSpace(15),
              child,
            ],
          ),
        ),
        PositionedDirectional(
          top: 0,
          start: 0,
          child: SvgPicture.asset('assets/svgs/Group 385.svg'),
        ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: SvgPicture.asset('assets/svgs/Group 386-2.svg', width: 120.w),
        ),
      ],
    );
  }
}
