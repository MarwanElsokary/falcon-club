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
import '../cubit/profile_cubit.dart';
import '../cubit/profile_edit_cubit.dart';
import '../cubit/profile_edit_state.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_action_tile.dart';
import '../widgets/profile_edit_sheet.dart';
import '../widgets/profile_error_view.dart';
import '../widgets/profile_loading_view.dart';
import '../widgets/profile_scaffold.dart';
import '../widgets/profile_section_card.dart';

/// The Scout's own profile — view + entry to edit.
///
/// The Scout role had no self-profile before. Same backend and shape as the
/// Coach (`Club/GetProfile` / `Club/UpdateProfile`, confirmed to work with a
/// Scout token), so this is [CoachProfileScreen] verbatim minus the club — a
/// Scout has none. Driven by [ProfileCubit] over the domain [Profile]; edit runs
/// on [ProfileEditCubit] + [ProfileEditSheet], exactly as the Coach does.
class ScoutProfileScreen extends StatelessWidget {
  const ScoutProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScaffold(
      child: BlocListener<ProfileEditCubit, ProfileEditState>(
        listener: (context, state) {
          if (state is ProfileEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم تحديث الملف الشخصي بنجاح'.tr()),
                backgroundColor: Colors.green,
              ),
            );
            context.read<ProfileCubit>().load();
          }
          if (state is ProfileEditFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: redClr),
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

          // ── الاسم (بدون نادي — الكشاف ليس له نادي) ────────────────────
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: profile.fullName,
          ),
          verticalSpace(20),

          // ── بطاقة المعلومات: هاتف / جنس ──────────────────────────────
          ProfileSectionCard(
            title: 'معلومات'.tr(),
            child: _contactGrid(profile),
          ),
          verticalSpace(16),

          // ── إجراء تعديل الملف الشخصي (نفس مسار الكوتش على الدومين) ────
          ProfileActionTile(
            iconAsset: 'assets/svgs/svgexport-18 (1) 2.svg',
            title: 'تعديل الملف الشخصي'.tr(),
            onTap: () {
              final ProfileEditCubit editCubit = context
                  .read<ProfileEditCubit>()
                ..seed(profile);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => BlocProvider<ProfileEditCubit>.value(
                  value: editCubit,
                  child: const ProfileEditSheet(),
                ),
              );
            },
          ),

          verticalSpace(100),
        ],
      ),
    );
  }

  /// Phone then gender as full-width rows — same treatment as the Coach screen.
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
