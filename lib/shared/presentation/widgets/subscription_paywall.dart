import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/helpers/extensions.dart';
import '../../../core/helpers/spacing.dart';
import '../../../core/routing/routes.dart';
import '../../../core/thems/thems.dart';
import '../../../core/widget/text_utils.dart';

/// The app's one subscribe/paywall card.
///
/// ## Why this exists
///
/// This exact design — a white 30r card with a 0.1 shadow, an 80w `mainColor`
/// gradient lock circle, a 22/w800 headline, a `mainColor@0.05` feature
/// checklist, an "اشترك الآن" button with a trailing chevron, and the two
/// `Group 385` / `Group 386-2` decorative SVG corners — was **copy-pasted three
/// times**, once per surface that gates content:
///
/// * `scout_players_section` (the locked players roster)
/// * `player_rank_widget` (the locked ranking)
/// * the locked-exercise prompt
///
/// Only the words differed (headline, subtitle, the four feature bullets). This
/// is the single source of truth for the design; each surface supplies its own
/// [title], [message] and [features] and nothing re-implements the markup.
///
/// OCP: a new gated surface is a new *call* with different copy, not a new
/// hand-built widget that drifts from the others.
class SubscriptionPaywall extends StatelessWidget {
  const SubscriptionPaywall({
    super.key,
    required this.title,
    required this.message,
    required this.features,
  });

  /// The bold headline, e.g. "القائمة الكاملة مغلقة".
  final String title;

  /// The sentence under it explaining what a subscription unlocks.
  final String message;

  /// The check-listed benefits. Each is `.tr()`-ed.
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: whiteclr,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _lockBadge(),
              verticalSpace(20),
              TextUtils(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                text: title.tr(),
              ),
              verticalSpace(12),
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                text: message.tr(),
                maxlines: 3,
              ),
              verticalSpace(20),
              _featureList(),
              verticalSpace(25),
              _subscribeButton(context),
              verticalSpace(10),
            ],
          ),
        ),
        PositionedDirectional(
          top: 0,
          start: 0,
          child: SvgPicture.asset('assets/svgs/Group 385.svg', width: 60.w),
        ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: SvgPicture.asset('assets/svgs/Group 386-2.svg', width: 80.w),
        ),
      ],
    );
  }

  Widget _lockBadge() => Container(
    width: 80.w,
    height: 80.w,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: <Color>[mainColor.withValues(alpha: 0.1), mainColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Center(
      child: Icon(
        Icons.lock_outline_rounded,
        color: Colors.white,
        size: 40.w,
      ),
    ),
  );

  Widget _featureList() => Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: mainColor.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(15.r),
      border: Border.all(color: mainColor.withValues(alpha: 0.2)),
    ),
    child: Column(
      children: features.map(_featureItem).toList(growable: false),
    ),
  );

  static Widget _featureItem(String text) => Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h),
    child: Row(
      children: <Widget>[
        Icon(Icons.check_circle, color: mainColor, size: 18.w),
        horizontalSpace(10),
        Expanded(
          child: TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            text: text.tr(),
          ),
        ),
      ],
    ),
  );

  Widget _subscribeButton(BuildContext context) => ElevatedButton(
    onPressed: () => context.pushNamed(AppRoute.packageScreen),
    style: ElevatedButton.styleFrom(
      backgroundColor: mainColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      elevation: 4,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextUtils(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: 'اشترك الآن'.tr(),
        ),
        horizontalSpace(8),
        Icon(Icons.arrow_back_ios_new, size: 16.w, color: Colors.white),
      ],
    ),
  );
}
