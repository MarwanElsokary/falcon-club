import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/padding_utils.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../shared/domain/entities/profile.dart';
import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../club_team/cubit/club_team_state.dart';
import '../../../club_team/ui/widget/club_edit_profile_sheet.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_error_view.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_loading_view.dart';
import '../widgets/profile_scaffold.dart';

/// The Coach/Club's own profile — view + entry to edit.
///
/// Replaces `ClubProfileScreen`. Display is driven by [ProfileCubit] over the
/// domain [Profile]; the edit sheet still rides `ClubTeamCubit` (migrated in
/// Phase 3), so a successful edit refreshes the display via [ProfileCubit].
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

          // ── صورة البروفايل ────────────────────────────────────────────
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

          // ── الاسم ─────────────────────────────────────────────────────
          TextUtils(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            text: profile.fullName,
          ),
          verticalSpace(20),

          // ── بطاقة المعلومات: هاتف | جنس | نادي ──────────────────────
          ProfileInfoCard(
            dividerColor: greyClr.withOpacity(0.3),
            items: [
              _infoItem(title: 'الهاتف'.tr(), value: profile.phone ?? ''),
              _infoItem(
                title: 'الجنس'.tr(),
                value: profile.gender?.arabicLabel ?? '',
              ),
              _infoItem(title: 'النادي'.tr(), value: profile.clubName ?? ''),
            ],
          ),
          verticalSpace(30),

          // ── قائمة الإجراءات ───────────────────────────────────────────
          Padding(
            padding: paddingUtils(),
            child: Column(
              children: [
                _buildActionItem(
                  icon: 'assets/svgs/svgexport-18 (1) 2.svg',
                  iconWidth: 20.w,
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
                _buildDivider(),
              ],
            ),
          ),

          verticalSpace(100),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String icon,
    required double iconWidth,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: TextUtils(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                text: title,
              ),
            ),
            SizedBox(width: 12.w),
            SvgPicture.asset(icon, width: iconWidth, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() =>
      Divider(color: Colors.white.withOpacity(0.15), height: 1);

  Widget _infoItem({required String title, required String value}) {
    return Column(
      children: [
        TextUtils(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: title,
        ),
        verticalSpace(2),
        TextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: value,
          maxlines: 1,
        ),
      ],
    );
  }
}
