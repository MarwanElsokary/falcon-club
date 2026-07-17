import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/helpers/spacing.dart';
import '../../../core/thems/thems.dart';
import '../../../core/widget/center_text_utils.dart';

/// A "nothing here yet" state: an icon in a `mainColor` gradient circle above a
/// headline and a line of subtext.
///
/// One implementation for every empty list, so they read as one design. The
/// colours are parameterised only because some surfaces sit on a light
/// background (a headline in black) and some on a dark one (the ranking screen,
/// where text must be white) — not so each screen can invent its own look.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.titleColor = Colors.black,
    this.messageColor = Colors.black54,
  });

  final IconData icon;
  final String title;
  final String message;

  /// Defaults suit a light background; pass white / white70 on a dark one.
  final Color titleColor;
  final Color messageColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _iconBadge(),
            verticalSpace(20),
            CenterTextUtils(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: titleColor,
              maxlines: 2,
              text: title.tr(),
            ),
            verticalSpace(8),
            CenterTextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: messageColor,
              maxlines: 3,
              text: message.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBadge() => Container(
    width: 96.w,
    height: 96.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: <Color>[mainColor.withValues(alpha: 0.1), mainColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(child: Icon(icon, color: Colors.white, size: 46.w)),
  );
}
