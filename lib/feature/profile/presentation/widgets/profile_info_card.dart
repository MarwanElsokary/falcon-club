import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The rounded `secondMainColor` info-card shell both self-profile screens use.
///
/// Shares the container shape and the vertical-divider interleaving; the [items]
/// and the [dividerColor] are per-screen (Coach shows 3 iconless items split by
/// grey dividers, MainClub shows 2 icon items split by white dividers), so those
/// are passed in rather than assumed.
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.items,
    required this.dividerColor,
  });

  final List<Widget> items;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      children.add(Expanded(child: items[i]));
      if (i < items.length - 1) {
        children.add(Container(height: 40.h, width: 1, color: dividerColor));
      }
    }

    return Container(
      width: context.displayWidth,
      padding: paddingUtils(),
      decoration: BoxDecoration(
        color: secondMainColor,
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(30.r),
          bottomStart: Radius.circular(30.r),
        ),
      ),
      child: Row(children: children),
    );
  }
}
