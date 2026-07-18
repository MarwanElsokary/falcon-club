import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/show_photo_widget.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../shared/domain/entities/profile.dart';
import '../../../../shared/domain/entities/subscription.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

/// The shared drawer-header profile block (avatar + greeting + subtitle + close),
/// used by the Club, MainClub and Scout drawers.
///
/// The three drawers each carried a copy-paste identical version reading from
/// `CacheHelper.getmyProfile()` (a `MyProfileModel`); this is the one widget,
/// driven by the domain [ProfileCubit]/[Profile]. The only per-role differences
/// are parameters: [showSubscriptionBadge] (Scout), [onHeaderTap]
/// (Scout → packages), and [onClose] (each drawer's own close mechanism).
class ProfileDrawerHeader extends StatelessWidget {
  const ProfileDrawerHeader({
    super.key,
    required this.onClose,
    this.showSubscriptionBadge = false,
    this.onHeaderTap,
  });

  final VoidCallback onClose;
  final bool showSubscriptionBadge;
  final VoidCallback? onHeaderTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final Profile? profile = state is ProfileLoaded
                ? state.profile
                : null;
            return _header(context, profile);
          },
        ),
        verticalSpace(7),
        Divider(
          color: offWhiteClr.withOpacity(0.3),
          endIndent: 20.w,
          indent: 20.w,
        ),
        verticalSpace(20),
      ],
    );
  }

  Widget _header(BuildContext context, Profile? profile) {
    final Padding row = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          _avatar(context, profile),
          horizontalSpace(10),
          Expanded(child: _nameBlock(profile)),
          _closeButton(),
        ],
      ),
    );

    // Scout wraps the whole header in a tap → packages; Club/MainClub do not.
    return onHeaderTap == null
        ? row
        : InkWell(onTap: onHeaderTap, child: row);
  }

  Widget _avatar(BuildContext context, Profile? profile) {
    final String photo = profile?.photoUrl ?? '';
    final String name = profile?.firstName ?? '';
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: () => showPhotoDialog(context: context, image: photo, name: name),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.w),
        ),
        child: ClipOval(
          child: SizedBox(
            width: 48.w,
            height: 48.w,
            child: CachedNetworkImage(
              imageUrl: photo,
              fit: BoxFit.cover,
              placeholder: (context, url) => Skeletonizer(
                enabled: true,
                child: Container(
                  height: 48.w,
                  width: 48.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                padding: EdgeInsets.all(12.w),
                decoration: const BoxDecoration(color: offWhiteClr),
                child: Image.asset(
                  'assets/images/Mask group.png',
                  width: 48.w,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameBlock(Profile? profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextUtils(
          maxlines: 1,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: 'هلا ${profile?.firstName ?? ''}!',
        ),
        // (The position/subtitle line was intentionally dropped from the header;
        // `positionName` remains on the Profile entity for potential future use.)
        // Subscription badge — Scout only, and only once the profile is known
        // (avoids a wrong "غير مشترك" flash for a subscribed user while loading).
        if (showSubscriptionBadge && profile != null) ...[
          verticalSpace(3),
          _subscriptionBadge(profile.subscription),
          verticalSpace(5),
        ],
      ],
    );
  }

  Widget _subscriptionBadge(Subscription subscription) {
    final bool isSubscribed = subscription.isActive;
    final Color color = isSubscribed ? Colors.green : redClr;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSubscribed ? Icons.check_circle_outline : Icons.lock_outline,
            color: color,
            size: 12.w,
          ),
          horizontalSpace(4),
          Flexible(
            child: TextUtils(
              maxlines: 1,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
              text: _subscriptionText(subscription),
            ),
          ),
        ],
      ),
    );
  }

  /// Same rule as the old Scout drawer: `isActive` decides subscribed/not, then
  /// the remaining-days label when known. (An expired-but-purchased plan reads
  /// "غير مشترك", which is what it is.)
  String _subscriptionText(Subscription subscription) {
    if (!subscription.isActive) return 'غير مشترك'.tr();
    final int? days = subscription.remainingDays;
    if (days == null) return 'مشترك'.tr();
    return '${'الأيام المتبقية'.tr()}: $days ${'يوم'.tr()}';
  }

  Widget _closeButton() {
    return InkWell(
      onTap: onClose,
      child: Container(
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: offWhiteClr.withOpacity(0.06),
        ),
        child: Icon(Icons.close, color: Colors.white, size: 25.w),
      ),
    );
  }
}
