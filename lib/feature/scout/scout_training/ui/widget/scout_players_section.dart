import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/routing/routes.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/helpers/subscription_helper.dart';
import '../../../../experiance_details_screen/cubit/experiance_details_cubit.dart';
import '../../../../experiance_details_screen/cubit/experiance_details_state.dart';
import '../../../../experiance_details_screen/data/model/exerciseWithPlayersModel.dart';
import '../../cubit/scout_training_details_cubit.dart';

class ScoutPlayersSection extends StatelessWidget {
  const ScoutPlayersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final exerciseId =
        context.read<ScoutTrainingDetailsCubit>().currentExerciseId ?? '';
    final subscribed = isActiveSubscription();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people_alt_rounded, color: mainColor, size: 20.w),
            horizontalSpace(8),
            TextUtils(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              text: 'اللاعبين',
            ),
          ],
        ),
        verticalSpace(12),
        BlocBuilder<ExperianceDetailsCubit, ExperianceDetailsState>(
          buildWhen: (prev, curr) =>
              (curr is exercisePlayersLoading &&
                  curr.exerciseId == exerciseId) ||
              (curr is exercisePlayersSuccess &&
                  curr.exerciseId == exerciseId) ||
              (curr is exercisePlayersError && curr.exerciseId == exerciseId),
          builder: (context, state) {
            final cached = context
                .read<ExperianceDetailsCubit>()
                .getCachedExercisePlayers(exerciseId);

            if (cached != null) {
              return _buildContent(
                context,
                cached.data.players,
                exerciseId,
                subscribed,
              );
            }
            if (state is exercisePlayersLoading &&
                state.exerciseId == exerciseId) {
              return _buildSkeleton();
            }
            if (state is exercisePlayersSuccess &&
                state.exerciseId == exerciseId) {
              return _buildContent(
                context,
                state.data.data.players,
                exerciseId,
                subscribed,
              );
            }
            if (state is exercisePlayersError &&
                state.exerciseId == exerciseId) {
              return _buildError(context, exerciseId);
            }
            return _buildSkeleton();
          },
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<ExercisePlayer> players,
    String exerciseId,
    bool subscribed,
  ) {
    if (players.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: mainColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Icon(Icons.people_outline, color: greyClr, size: 40.w),
            verticalSpace(8),
            TextUtils(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: greyClr,
              text: 'لا يوجد لاعبون بعد',
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // اللاعبين — الباك بيرجع 3 بس لو مش مشترك
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: players.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _ScoutPlayerRow(
              player: players[index],
              exerciseId: exerciseId,
            ),
          ),
        ),
        // رسالة الاشتراك لو مش مشترك
        if (!subscribed) ...[
          verticalSpace(10),
          _buildSubscribeMessage(context),
        ],
        verticalSpace(20),
      ],
    );
  }

  Widget _buildSubscribeMessage(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: whiteclr,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [mainColor.withOpacity(0.1), mainColor],
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
              ),
              verticalSpace(20),
              TextUtils(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                text: 'القائمة الكاملة مغلقة'.tr(),
              ),
              verticalSpace(12),
              TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
                text:
                    'اشترك الآن للوصول إلى قائمة اللاعبين الكاملة ومشاهدة جميع المحاولات'
                        .tr(),
                maxlines: 3,
              ),
              verticalSpace(20),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: mainColor.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    _buildFeatureItem('عرض جميع اللاعبين'),
                    _buildFeatureItem('مشاهدة كل المحاولات'),
                    _buildFeatureItem('تتبع أداء اللاعبين'),
                    _buildFeatureItem('إحصائيات مفصلة'),
                  ],
                ),
              ),
              verticalSpace(25),
              ElevatedButton(
                onPressed: () => context.pushNamed(AppRoute.packageScreen),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 16.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextUtils(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      text: 'اشترك الآن'.tr(),
                    ),
                    horizontalSpace(8),
                    Icon(
                      Icons.arrow_back_ios_new,
                      size: 16.w,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
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

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
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
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 3,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Container(
            height: 64.h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String exerciseId) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: redClr.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: redClr,
            text: 'تعذّر تحميل اللاعبين',
          ),
          verticalSpace(8),
          ElevatedButton(
            onPressed: () => context
                .read<ExperianceDetailsCubit>()
                .fetchExercisePlayers(exerciseId: exerciseId),
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ── صف اللاعب للكشاف ─────────────────────────────────────────────────────────
class _ScoutPlayerRow extends StatelessWidget {
  const _ScoutPlayerRow({required this.player, required this.exerciseId});

  final ExercisePlayer player;
  final String exerciseId;

  void _goToAttempts(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoute.playerAttemptsScreen,
      arguments: {
        'exerciseId': int.tryParse(exerciseId) ?? 0,
        'playerId': player.id.toString(),
        'playerName': player.name.toString(),
        'playerPhoto': player.photo?.toString(),
        'totalAttempts': player.attemptCount ?? 0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = player.photo != null && player.photo.toString().isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: mainColor.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mainColor, width: 2),
                ),
                child: ClipOval(
                  child: hasPhoto
                      ? CachedNetworkImage(
                          imageUrl: player.photo.toString(),
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: mainColor.withOpacity(0.2)),
                          errorWidget: (_, __, ___) => _fallback(),
                        )
                      : _fallback(),
                ),
              ),
              PositionedDirectional(
                bottom: 0,
                end: 0,
                child: GestureDetector(
                  onTap: () => _goToAttempts(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: greenClr,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${player.attemptCount ?? 0}',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  text: player.name.toString(),
                  maxlines: 1,
                ),
                verticalSpace(3),
                GestureDetector(
                  onTap: () => _goToAttempts(context),
                  child: Row(
                    children: [
                      TextUtils(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: mainColor,
                        text: 'المحاولات: ${player.attemptCount ?? 0}',
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10.w,
                        color: mainColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          GestureDetector(
            onTap: () => _goToAttempts(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.visibility_outlined,
                    color: Colors.white,
                    size: 14.w,
                  ),
                  horizontalSpace(4),
                  Text(
                    'مشاهدة',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback() {
    final name = player.name.toString();
    return Container(
      color: mainColor.withOpacity(0.2),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0] : '؟',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
