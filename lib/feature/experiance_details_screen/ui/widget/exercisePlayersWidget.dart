import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import 'package:falcon/feature/experiance_details_screen/cubit/experiance_details_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../data/model/exerciseWithPlayersModel.dart';

class ExercisePlayersWidget extends StatefulWidget {
  const ExercisePlayersWidget({super.key, required this.exerciseId});

  final String exerciseId;

  @override
  State<ExercisePlayersWidget> createState() => _ExercisePlayersWidgetState();
}

class _ExercisePlayersWidgetState extends State<ExercisePlayersWidget> {
  @override
  void initState() {
    super.initState();
    // نطلب البيانات أول ما الـ widget يتبني
    context
        .read<ExperianceDetailsCubit>()
        .fetchExercisePlayers(exerciseId: widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExperianceDetailsCubit, ExperianceDetailsState>(
      buildWhen: (prev, curr) =>
      curr is exercisePlayersLoading &&
          (curr as exercisePlayersLoading).exerciseId ==
              widget.exerciseId ||
          curr is exercisePlayersSuccess &&
              (curr as exercisePlayersSuccess).exerciseId ==
                  widget.exerciseId ||
          curr is exercisePlayersError &&
              (curr as exercisePlayersError).exerciseId == widget.exerciseId,
      builder: (context, state) {
        // نشوف لو الـ state بتاعنا هو state الـ exerciseId ده
        final cached = context
            .read<ExperianceDetailsCubit>()
            .getCachedExercisePlayers(widget.exerciseId);

        // لو عندنا كاش — اعرضه فوراً
        if (cached != null) {
          return _buildPlayersList(cached.data.players);
        }

        // loading
        if (state is exercisePlayersLoading &&
            state.exerciseId == widget.exerciseId) {
          return _buildSkeleton();
        }

        // success
        if (state is exercisePlayersSuccess &&
            state.exerciseId == widget.exerciseId) {
          return _buildPlayersList(state.data.data.players);
        }

        // error
        if (state is exercisePlayersError &&
            state.exerciseId == widget.exerciseId) {
          return _buildError();
        }

        return _buildSkeleton();
      },
    );
  }

  // ── قائمة اللاعبين ──────────────────────────────────────────────
  Widget _buildPlayersList(List<ExercisePlayer> players) {
    if (players.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Center(
          child: TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: offWhiteClr.withOpacity(0.6),
            text: 'لا يوجد لاعبون بعد'.tr(),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(12),
        // ── عنوان القسم ──────────────────────────────────────────
        Row(
          children: [
            Icon(Icons.people_alt_rounded,
                color: offWhiteClr.withOpacity(0.8), size: 16.w),
            horizontalSpace(6),
            TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: offWhiteClr.withOpacity(0.8),
              text: 'اللاعبين (${players.length})'.tr(),
            ),
          ],
        ),
        verticalSpace(8),
        // ── قائمة أفقية للاعبين ──────────────────────────────────
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: players.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 8.w),
                child: _PlayerChip(
                  player: players[index],
                  exerciseId: widget.exerciseId,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        height: 100.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: Container(
              width: 70.w,
              decoration: BoxDecoration(
                color: offWhiteClr.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: TextUtils(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: redClr,
        text: 'تعذّر تحميل اللاعبين'.tr(),
      ),
    );
  }
}

// ── كارت اللاعب الصغير ─────────────────────────────────────────────
class _PlayerChip extends StatelessWidget {
  const _PlayerChip({
    required this.player,
    required this.exerciseId,
  });

  final ExercisePlayer player;
  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        player.photo != null && player.photo.toString().isNotEmpty;

    return GestureDetector(
      onTap: () => _showAddAttemptSheet(context),
      child: Container(
        width: 70.w,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: offWhiteClr.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: offWhiteClr.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── صورة اللاعب ────────────────────────────────────
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: secondMainColor, width: 2),
                  ),
                  child: ClipOval(
                    child: hasPhoto
                        ? CachedNetworkImage(
                      imageUrl: player.photo.toString(),
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: secondMainColor,
                      ),
                      errorWidget: (_, __, ___) =>
                          _fallback(player.name.toString()),
                    )
                        : _fallback(player.name.toString()),
                  ),
                ),
                // عدد المحاولات
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: greenClr,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${player.attemptCount}',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            verticalSpace(4),
            // ── الاسم ──────────────────────────────────────────
            TextUtils(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              text: player.name.toString(),
              maxlines: 2,
            ),
            verticalSpace(4),
            // ── زرار إضافة محاولة ───────────────────────────────
            Container(
              padding:
              EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: secondMainColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '+ محاولة'.tr(),
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback(String name) {
    return Container(
      color: secondMainColor,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0] : '؟',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }

  // ── Bottom Sheet — إضافة محاولة ────────────────────────────────
  void _showAddAttemptSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAttemptSheet(
        player: player,
        exerciseId: exerciseId,
      ),
    );
  }
}

// ── Bottom Sheet إضافة محاولة ──────────────────────────────────────
class _AddAttemptSheet extends StatelessWidget {
  const _AddAttemptSheet({
    required this.player,
    required this.exerciseId,
  });

  final ExercisePlayer player;
  final String exerciseId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle ───────────────────────────────────────────
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: greyClr.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          verticalSpace(16),

          // ── العنوان + بيانات اللاعب ──────────────────────────
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mainColor, width: 2),
                ),
                child: ClipOval(
                  child: player.photo != null &&
                      player.photo.toString().isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: player.photo.toString(),
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        _fallback(player.name.toString()),
                  )
                      : _fallback(player.name.toString()),
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUtils(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      text: player.name.toString(),
                    ),
                    TextUtils(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: greyClr,
                      text:
                      'العمر: ${player.age} | المحاولات: ${player.attemptCount}',
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(20),

          // ── زرار "إضافة محاولة" ── يفتح صفحة التمرين ──────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.pushNamed(
                  AppRoute.trainingDetailsScreen,
                  arguments: {
                    'exerciseId': exerciseId,
                    'playerId': player.id.toString(),
                  },
                );
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                text: 'إضافة محاولة'.tr(),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallback(String name) {
    return Container(
      color: mainColor,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0] : '؟',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}