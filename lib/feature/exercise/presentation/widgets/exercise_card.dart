import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/color_code.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../../shared/domain/entities/exercise.dart';

/// One row in the exercise list.
///
/// ## The card is tinted with the exercise's `colorCode`
///
/// This was originally a faithful white-card port of `all_training_widget.dart`.
/// It was deliberately restyled (approved on-device) to match the Home card: the
/// whole card takes the exercise's own `colorCode`, and everything on it —
/// title, skill chips, bookings, chevron — is recoloured for a dark background.
///
/// The skill chips use the same trick as the Home and trial cards: a
/// **translucent** white overlay (`offWhiteClr` at 15%), which Flutter
/// composites over whatever the card is painted, so a chip is always a lighter
/// shade of the card's own colour for any `colorCode` — no colour arithmetic.
///
/// Taking an [Exercise] instead of a raw DTO also removes two latent crashes:
/// the old club copy passed `dynamic` `photoPath`/`title` straight into
/// non-nullable destinations, so a null threw a `TypeError`. [Exercise] types
/// them.
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.onTap,
    required this.isLast,
    required this.index,
    this.isLocked = false,
  });

  final Exercise exercise;
  final VoidCallback onTap;

  /// The original pads the final row by 110 to clear the bottom navigation bar.
  final bool isLast;

  /// Position in the list — only used to pick a fallback colour when an exercise
  /// arrives without a usable `colorCode` (live data always has one).
  final int index;

  /// A paid exercise the current user is not entitled to.
  ///
  /// Decided by `Exercise.isLockedFor(subscription)`, resolved once by the
  /// screen — not re-derived per card.
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final Color cardColor = ColorCode.cardColor(
      exercise.colorCode,
      fallbackIndex: index,
    );

    return Column(
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: cardColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _photo(),
                    horizontalSpace(10),
                    Expanded(child: _details(context)),
                  ],
                ),
                PositionedDirectional(
                  end: 12.w,
                  bottom: 12.w,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16.w,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        verticalSpace(isLast ? 110 : 15),
      ],
    );
  }

  Widget _photo() => SizedBox(
    width: 112.w,
    height: 112.w,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            width: 112.w,
            height: 112.w,
            imageUrl: exercise.photoUrl ?? '',
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String url) => Skeletonizer(
              enabled: true,
              child: Container(
                width: 112.w,
                height: 112.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
            errorWidget: (BuildContext context, String url, Object error) =>
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SvgPicture.asset('assets/svgs/unavailabeImage.svg'),
                ),
          ),
          if (isLocked) _lockOverlay(),
        ],
      ),
    ),
  );

  /// A dark scrim plus the app's shared paywall lock: a `mainColor` **gradient**
  /// circle with a white lock, matching `ExercisePlayersPaywall` and the
  /// exercise-lock sheet so every "locked" surface reads as one design.
  Widget _lockOverlay() => ColoredBox(
    color: Colors.black.withValues(alpha: 0.45),
    child: Center(
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: <Color>[mainColor.withValues(alpha: 0.1), mainColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(
          Icons.lock_outline_rounded,
          color: Colors.white,
          size: 24.w,
        ),
      ),
    ),
  );

  Widget _details(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        TextUtils(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: exercise.title,
          maxlines: 2,
        ),
        verticalSpace(8),
        _skillChips(context),
        verticalSpace(8),
        _bookings(),
      ],
    ),
  );

  Widget _skillChips(BuildContext context) => SizedBox(
    height: 20.h,
    width: context.displayWidth,
    child: ListView.builder(
      itemCount: exercise.skillNames.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) => Container(
        margin: EdgeInsetsDirectional.only(end: 6.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        // A lighter shade of the card's own colour: a translucent white overlay
        // that composites over the colorCode, so it adapts to any colour.
        decoration: BoxDecoration(
          color: offWhiteClr.withValues(alpha: 0.15),
          border: Border.all(color: offWhiteClr.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: TextUtils(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          text: exercise.skillNames[index],
        ),
      ),
    ),
  );

  Widget _bookings() => Row(
    children: <Widget>[
      Icon(Icons.schedule_outlined, size: 14.w, color: Colors.white70),
      horizontalSpace(4),
      TextUtils(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
        text: '${exercise.bookingsCount} اشتراك',
      ),
    ],
  );
}
