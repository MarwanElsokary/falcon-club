import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/text_utils.dart';
import 'package:falcon/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falcon/feature/experiments/cubit/experiments_state.dart';
import 'package:falcon/feature/training/cubit/training_cubit.dart';
import 'package:falcon/feature/training/cubit/training_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoutHomeScreen extends StatelessWidget {
  const ScoutHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────────
              _buildHeader(context),
              verticalSpace(20),

              // ── Trials section ────────────────────────────────────────────
              _buildSectionHeader('التجارب'.tr(), context),
              verticalSpace(12),
              _buildTrialsSection(context),
              verticalSpace(24),

              // ── Exercises section ─────────────────────────────────────────
              _buildSectionHeader('التمارين'.tr(), context),
              verticalSpace(12),
              _buildExercisesSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: context.displayWidth,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(24.r),
          bottomEnd: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                  text: 'مرحباً بك'.tr(),
                ),
                verticalSpace(4),
                TextUtils(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  text: 'كشاف'.tr(),
                ),
              ],
            ),
          ),
          // Scout badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, color: Colors.white, size: 14.w),
                horizontalSpace(4),
                TextUtils(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  text: 'كشاف'.tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header ───────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          horizontalSpace(8),
          TextUtils(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            text: title,
          ),
          const Spacer(),
          // Read-only badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextUtils(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]!,
              text: 'عرض فقط'.tr(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Trials section ───────────────────────────────────────────────────────────
  Widget _buildTrialsSection(BuildContext context) {
    return BlocBuilder<ExperimentsCubit, ExperimentsState>(
      builder: (context, state) {
        if (state is allTrialsLoading) {
          return SizedBox(
            height: 180.h,
            child: Center(
              child: CircularProgressIndicator(color: mainColor, strokeWidth: 2),
            ),
          );
        }

        if (state is allTrialsError) {
          return _buildErrorWidget(
            state.error,
            onRetry: () => context
                .read<ExperimentsCubit>()
                .emitallTrials(categoryId: ''),
          );
        }

        if (state is allTrialsSuccess) {
          final trials = state.allTrialsModel.data;
          if (trials.isEmpty) {
            return _buildEmptyWidget('لا توجد تجارب متاحة'.tr());
          }

          return SizedBox(
            height: 180.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: trials.length,
              separatorBuilder: (_, __) => horizontalSpace(12),
              itemBuilder: (context, index) {
                final trial = trials[index];
                return _TrialCard(
                  title: '${trial.title ?? ''}',
                  imageUrl: '${trial.photoPath ?? ''}',
                  onTap: () {
                    context.pushNamed(
                      AppRoute.experianceDetailsScreen,
                      arguments: {
                        'heroTag': 'trial_${trial.id}_scout',
                        'experianceImage': '${trial.photoPath ?? ''}',
                        'trialId': '${trial.id ?? ''}',
                        'title': '${trial.title ?? ''}',
                      },
                    );
                  },
                );
              },
            ),
          );
        }

        return SizedBox(
          height: 180.h,
          child: Center(
            child: CircularProgressIndicator(color: mainColor, strokeWidth: 2),
          ),
        );
      },
    );
  }

  // ── Exercises section ────────────────────────────────────────────────────────
  Widget _buildExercisesSection(BuildContext context) {
    return BlocBuilder<TrainingCubit, TrainingState>(
      builder: (context, state) {
        if (state is allExercisesLoading) {
          return SizedBox(
            height: 120.h,
            child: Center(
              child: CircularProgressIndicator(color: mainColor, strokeWidth: 2),
            ),
          );
        }

        if (state is allExercisesError) {
          return _buildErrorWidget(
            state.error,
            onRetry: () => context
                .read<TrainingCubit>()
                .emitallExercises(categoryId: '', popular: false),
          );
        }

        if (state is allExercisesSuccess) {
          final exercises = state.allExercisesModel.data;
          if (exercises.isEmpty) {
            return _buildEmptyWidget('لا توجد تمارين متاحة'.tr());
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: exercises.length > 6 ? 6 : exercises.length,
            separatorBuilder: (_, __) => verticalSpace(10),
            itemBuilder: (context, index) {
              final exercise = exercises[index];
              return _ExerciseCard(
                title: '${exercise.title ?? ''}',
                imageUrl: '${exercise.photoPath ?? ''}',
                categoryName: '${exercise.categoryName ?? ''}',
                onTap: () {
                  context.pushNamed(
                    AppRoute.trainingDetailsScreen,
                    arguments: {'exerciseId': '${exercise.id ?? ''}'},
                  );
                },
              );
            },
          );
        }

        return SizedBox(
          height: 120.h,
          child: Center(
            child: CircularProgressIndicator(color: mainColor, strokeWidth: 2),
          ),
        );
      },
    );
  }

  // ── Error widget ─────────────────────────────────────────────────────────────
  Widget _buildErrorWidget(String error, {required VoidCallback onRetry}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 40.w),
          verticalSpace(8),
          TextUtils(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600]!,
            text: error,
          ),
          verticalSpace(8),
          TextButton(
            onPressed: onRetry,
            child: TextUtils(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: mainColor,
              text: 'إعادة المحاولة'.tr(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty widget ─────────────────────────────────────────────────────────────
  Widget _buildEmptyWidget(String message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Center(
        child: TextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[500]!,
          text: message,
        ),
      ),
    );
  }
}

// ── Trial card ────────────────────────────────────────────────────────────────

class _TrialCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const _TrialCard({
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 110.h,
                      width: 140.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        height: 110.h,
                        color: mainColor.withOpacity(0.1),
                        child: Icon(Icons.sports, color: mainColor, size: 30.w),
                      ),
                    )
                  : Container(
                      height: 110.h,
                      color: mainColor.withOpacity(0.1),
                      child: Icon(Icons.sports, color: mainColor, size: 30.w),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: TextUtils(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                text: title,
                maxlines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Exercise card ─────────────────────────────────────────────────────────────

class _ExerciseCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String categoryName;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.title,
    required this.imageUrl,
    required this.categoryName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 60.w,
                      width: 60.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        height: 60.w,
                        width: 60.w,
                        color: mainColor.withOpacity(0.1),
                        child: Icon(Icons.fitness_center,
                            color: mainColor, size: 24.w),
                      ),
                    )
                  : Container(
                      height: 60.w,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.fitness_center,
                          color: mainColor, size: 24.w),
                    ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextUtils(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    text: title,
                    maxlines: 2,
                  ),
                  if (categoryName.isNotEmpty) ...[
                    verticalSpace(4),
                    TextUtils(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500]!,
                      text: categoryName,
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14.w),
          ],
        ),
      ),
    );
  }
}
