import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../../shared/domain/entities/subscription.dart';
import '../../../../shared/domain/subscription_reader.dart';
import '../widgets/exercise_lock_prompt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/extensions.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/thems/thems.dart';
import '../../../../core/widget/center_text_utils.dart';
import '../../../../core/widget/text_utils.dart';
import '../../../../shared/domain/entities/exercise.dart';
import '../cubit/exercise_list_cubit.dart';
import '../cubit/exercise_list_state.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_category_filter.dart';
import '../widgets/exercise_list_skeleton.dart';

/// The exercise list. One screen, every role.
///
/// It replaces `TrainingScreen` and `ScoutTrainingScreen` — two files whose
/// difference was a cubit type and a destination route. Together with the three
/// widgets beneath it, that fork was ~800 lines of near-duplicate code with the
/// bugs fixed on one side and not the other.
///
/// Nothing here branches on role, because listing exercises does not vary by
/// role: both stacks called the *same endpoint* with the *same arguments*.
class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(height: context.displayHeight, width: context.displayWidth),
          PositionedDirectional(
            start: 0,
            child: SvgPicture.asset('assets/svgs/Group 386.svg', width: 120.w),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            top: 10.w,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    _header(context),
                    const ExerciseCategoryFilter(),
                    verticalSpace(15),
                    _list(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The back row, shown only when this screen was pushed.
  ///
  /// `TrainingScreen` gated it on `Navigator.canPop`; `ScoutTrainingScreen`
  /// dropped it and left a bare `verticalSpace(15)` plus a comment saying a back
  /// button belonged there. Both cases are preserved: as a tab inside
  /// `ScoutMainScreen` nothing can be popped, so the spacer shows exactly as
  /// before; pushed as a route, the back row appears. That does mean the Scout's
  /// *pushed* training screen gains the back button it was always missing.
  Widget _header(BuildContext context) {
    if (!Navigator.canPop(context)) return verticalSpace(15);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const BackButton(color: Colors.black),
            Expanded(
              child: TextUtils(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                text: 'الرجوع'.tr(),
              ),
            ),
          ],
        ),
        verticalSpace(5),
      ],
    );
  }

  Widget _list(BuildContext context) {
    return SizedBox(
      height: context.displayHeight / 1.2,
      width: context.displayWidth,
      child: BlocBuilder<ExerciseListCubit, ExerciseListState>(
        builder: (BuildContext context, ExerciseListState state) =>
            switch (state.status) {
              ExerciseListLoaded(:final List<Exercise> exercises) =>
                exercises.isEmpty ? _empty() : _loaded(context, exercises),
              ExerciseListFailed(:final String message) => _failed(
                context,
                message,
              ),
              // Initial and Loading both show the skeleton, as before.
              _ => const ExerciseListSkeleton(),
            },
      ),
    );
  }

  Widget _loaded(BuildContext context, List<Exercise> exercises) {
    // Resolved once for the whole list, not re-derived per card.
    final Subscription subscription = getIt<SubscriptionReader>().current();

    return ListView.builder(
      itemCount: exercises.length,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final Exercise exercise = exercises[index];
        final bool isLocked = exercise.isLockedFor(subscription);

        return ExerciseCard(
          exercise: exercise,
          index: index,
          isLast: index == exercises.length - 1,
          isLocked: isLocked,
          // A locked exercise prompts you to subscribe instead of opening. The
          // details screen is not merely hidden behind a disabled tap — there is
          // no route taken at all.
          onTap: () => isLocked
              ? showExerciseLockedSheet(context, title: exercise.title)
              : context.pushNamed(
                  AppRoute.exerciseDetailsScreen,
                  arguments: <String, dynamic>{'exerciseId': exercise.id},
                ),
        );
      },
    );
  }

  /// Neither original had an empty state: an empty list simply rendered a blank
  /// area, indistinguishable from a screen that failed to load.
  Widget _empty() => Center(
    child: CenterTextUtils(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black54,
      maxlines: 2,
      text: 'لا توجد تمارين في هذا التصنيف'.tr(),
    ),
  );

  /// Nor a failure state: both swallowed the error into `orElse` and showed the
  /// loading skeleton forever, so a dead network looked like a slow one.
  Widget _failed(BuildContext context, String message) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CenterTextUtils(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          maxlines: 3,
          text: message,
        ),
        verticalSpace(12),
        ElevatedButton(
          onPressed: () => context.read<ExerciseListCubit>().loadAll(),
          style: ElevatedButton.styleFrom(backgroundColor: mainColor),
          child: Text(
            'إعادة المحاولة'.tr(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}
