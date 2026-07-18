import 'package:falconclubapp/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/domain/entities/completed_exercise.dart';
import 'completed_exercise_card.dart';

/// The 2-col grid of completed-exercise cards, shared by the inline profile
/// section (with [limit] = 4 for a preview) and the full-list screen ([limit]
/// null = all). Always shrink-wraps + is non-scrollable, so the host provides
/// the scroll (the profile's scroll view, or the full-list screen's).
///
/// Tapping a card opens the same per-exercise attempt history the app's
/// "مشاهدة" opens — it needs the player's id/name/photo, threaded in here.
class CompletedExercisesGrid extends StatelessWidget {
  const CompletedExercisesGrid({
    super.key,
    required this.exercises,
    required this.playerId,
    required this.playerName,
    required this.playerPhoto,
    this.limit,
    this.padding = EdgeInsets.zero,
  });

  final List<CompletedExercise> exercises;
  final String playerId;
  final String playerName;
  final String? playerPhoto;
  final int? limit;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final int? cap = limit;
    final List<CompletedExercise> shown =
        (cap != null && exercises.length > cap)
        ? exercises.sublist(0, cap)
        : exercises;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: 188.h,
      ),
      itemCount: shown.length,
      itemBuilder: (context, index) {
        final CompletedExercise exercise = shown[index];
        return CompletedExerciseCard(
          exercise: exercise,
          onTap: () => _openAttempts(context, exercise),
        );
      },
    );
  }

  void _openAttempts(BuildContext context, CompletedExercise exercise) {
    Navigator.of(context).pushNamed(
      AppRoute.playerAttemptsScreen,
      arguments: <String, dynamic>{
        'exerciseId': exercise.id,
        'playerId': playerId,
        'playerName': playerName,
        'playerPhoto': playerPhoto,
        'totalAttempts': exercise.attemptsCount,
      },
    );
  }
}
