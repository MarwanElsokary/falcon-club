import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../shared/domain/entities/profile.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_error_view.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_loading_view.dart';
import '../widgets/profile_scaffold.dart';

/// The MainClub's own profile/info — read-only.
///
/// Replaces `ClubInfoScreen`. Display is driven by [ProfileCubit] over the
/// domain [Profile]; the subscription badge now reads `profile.subscription
/// .isActive` (the fresh fetch) rather than the raw `isSubscribed` flag — the
/// permanent form of the Phase 0 hotfix.
class MainClubProfileScreen extends StatelessWidget {
  const MainClubProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileLoaded(:final Profile profile) => _content(context, profile),
          ProfileFailure(:final String message) => ProfileErrorView(
            message: message,
            icon: Icons.error_outline,
            onRetry: () => context.read<ProfileCubit>().load(),
          ),
          _ => const ProfileLoadingView(),
        },
      ),
    );
  }

  Widget _content(BuildContext context, Profile profile) {
    final bool isSubscribed = profile.subscription.isActive;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpace(20),

          // ── صورة النادي ───────────────────────────────────────────────
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: secondMainColor, width: 4.w),
                color: secondMainColor.withOpacity(0.2),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profile.photoUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 110.w,
                      height: 110.w,
                      color: Colors.white24,
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.shield, color: Colors.white, size: 50.w),
                ),
              ),
            ),
          ),
          verticalSpace(12),

          // ── اسم النادي ────────────────────────────────────────────────
          TextUtils(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: profile.firstName,
          ),

          // ── حالة الاشتراك ─────────────────────────────────────────────
          verticalSpace(6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: (isSubscribed ? Colors.green : Colors.red).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSubscribed ? Colors.green : Colors.red,
              ),
            ),
            child: TextUtils(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSubscribed ? Colors.green : Colors.red,
              text: isSubscribed ? 'مشترك'.tr() : 'غير مشترك'.tr(),
            ),
          ),

          verticalSpace(20),

          // ── بطاقة المعلومات الأساسية: هاتف | بريد ─────────────────────
          ProfileInfoCard(
            dividerColor: Colors.white24,
            items: [
              _infoItem(
                icon: Icons.phone,
                title: 'الهاتف'.tr(),
                value: profile.phone ?? '—',
              ),
              _infoItem(
                icon: Icons.email_outlined,
                title: 'البريد'.tr(),
                value: profile.email ?? '—',
              ),
            ],
          ),

          verticalSpace(24),

          // ── بطاقة تفاصيل إضافية ───────────────────────────────────────
          Padding(
            padding: paddingUtils(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: secondMainColor.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  _detailRow(
                    icon: Icons.badge_outlined,
                    label: 'رقم الحساب'.tr(),
                    value: profile.accountNumber ?? '—',
                  ),
                  _divider(),
                  _detailRow(
                    icon: Icons.sports_soccer,
                    label: 'النادي'.tr(),
                    value: profile.clubName ?? '—',
                  ),
                  _divider(),
                ],
              ),
            ),
          ),

          verticalSpace(100),
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18.w),
        verticalSpace(4),
        TextUtils(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
          text: title,
        ),
        verticalSpace(2),
        TextUtils(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: value,
          maxlines: 1,
        ),
      ],
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20.w),
          horizontalSpace(12),
          Expanded(
            child: TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
              text: label,
            ),
          ),
          TextUtils(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: value,
            maxlines: 1,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.white.withOpacity(0.1), height: 1);
}
