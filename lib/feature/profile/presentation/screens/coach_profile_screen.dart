import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../shared/domain/entities/profile.dart';
import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../club_team/cubit/club_team_state.dart';
import '../../../club_team/ui/widget/club_edit_profile_sheet.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_error_view.dart';
import '../widgets/profile_loading_view.dart';
import '../widgets/profile_scaffold.dart';
import '../widgets/profile_section_card.dart';

/// The Coach/Club's own profile — view + entry to edit.
///
/// Replaces `ClubProfileScreen`. Display is driven by [ProfileCubit] over the
/// domain [Profile]. As of Phase 2.5 it wears the player-profile section-card
/// chrome ([ProfileSectionCard] / [ProfileActionTile]) so the self-profile and
/// the player profile read as one design, and new sections (a Favorites card in
/// Phase 6) slot into the same language.
///
/// The edit path is deliberately unchanged from Phase 2 — it still rides
/// `ClubTeamCubit` and opens `ClubEditProfileSheet`; a successful edit refreshes
/// the display via [ProfileCubit]. The edit internals migrate in Phase 3.
class CoachProfileScreen extends StatelessWidget {
  const CoachProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
      child: BlocListener<ClubTeamCubit, ClubTeamState>(
        listener: (context, state) {
          if (state is clubUpdateProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم تحديث الملف الشخصي بنجاح'.tr()),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ProfileCubit>().load();
          }
          if (state is clubUpdateProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: redClr),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) => switch (state) {
            ProfileLoaded(:final Profile profile) => _content(context, profile),
            ProfileFailure(:final String message) => ProfileErrorView(
              message: message,
              icon: Icons.error,
              onRetry: () => context.read<ProfileCubit>().load(),
            ),
            _ => const ProfileLoadingView(),
          },
        ),
      ),
    );
  }

  Widget _content(BuildContext context, Profile profile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          verticalSpace(20),

          // ── صورة البروفايل (نفس معالجة بروفايل اللاعب) ────────────────
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 98.w,
              height: 139.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(color: secondMainColor, width: 5.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: CachedNetworkImage(
                  width: 98.w,
                  height: 139.w,
                  imageUrl: profile.photoUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Skeletonizer(
                    enabled: true,
                    child: Container(
                      width: 98.w,
                      height: 139.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Icon(Icons.person, color: Colors.white, size: 40.w),
                  ),
                ),
              ),
            ),
          ),
          verticalSpace(10),

          // ── الاسم + اسم النادي (نفس نمط الخط، مثل بروفايل اللاعب) ──────
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: profile.fullName,
          ),
          if (profile.clubName != null && profile.clubName!.isNotEmpty) ...[
            verticalSpace(4),
            TextUtils(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              text: profile.clubName!,
            ),
          ],
          verticalSpace(20),

          // ── بطاقة المعلومات: هاتف / جنس ──────────────────────────────
          ProfileSectionCard(
            title: 'معلومات'.tr(),
            child: _contactGrid(profile),
          ),
          verticalSpace(16),

          // ── إجراء تعديل الملف الشخصي (نفس مسار Phase 2 دون تغيير) ─────
          ProfileActionTile(
            iconAsset: 'assets/svgs/svgexport-18 (1) 2.svg',
            title: 'تعديل الملف الشخصي'.tr(),
            onTap: () {
              final cubit = context.read<ClubTeamCubit>();
              cubit.initProfileForm();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: const ClubEditProfileSheet(),
                ),
              );
            },
          ),

          verticalSpace(100),
        ],
      ),
    );
  }

  /// Club now sits under the name (like the player profile), so the section is
  /// the two remaining contact facts — phone then gender — as full-width rows.
  /// Full-width rows (no side-by-side `Expanded` under the unbounded scroll
  /// view) also keep the layout bounded by construction.
  Widget _contactGrid(Profile profile) {
    return Column(
      children: [
        _contactRow(
          icon: Icons.phone_outlined,
          label: 'الهاتف'.tr(),
          value: profile.phone,
        ),
        verticalSpace(12),
        _contactRow(
          icon: Icons.wc_outlined,
          label: 'الجنس'.tr(),
          value: profile.gender?.arabicLabel,
        ),
      ],
    );
  }

  /// A single contact fact: a `mainColor`-tinted icon chip beside a stacked
  /// label/value in a soft rounded cell — the "more developed" cell treatment.
  Widget _contactRow({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.04),
        border: Border.all(color: mainColor.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: mainColor, size: 20.w),
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                  text: label,
                ),
                verticalSpace(2),
                TextUtils(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  text: (value == null || value.isEmpty) ? '—' : value,
                  maxlines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
