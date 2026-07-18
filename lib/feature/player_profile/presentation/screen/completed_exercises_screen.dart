import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../profile/domain/entities/completed_exercise.dart';
import '../widget/completed_exercises_grid.dart';

/// The full "التمارين المنجزة" list, opened from the section's "عرض الكل (N)".
///
/// Data is handed in from the already-loaded section (no re-fetch); it reuses
/// the same [CompletedExercisesGrid] cards and the same tap-to-attempts, just
/// without the 4-card preview cap.
class CompletedExercisesScreen extends StatelessWidget {
  const CompletedExercisesScreen({
    super.key,
    required this.exercises,
    required this.playerId,
    required this.playerName,
    required this.playerPhoto,
  });

  final List<CompletedExercise> exercises;
  final String playerId;
  final String playerName;
  final String? playerPhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: TextUtils(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          text: 'التمارين المنجزة'.tr(),
        ),
      ),
      body: Container(
        width: context.displayWidth,
        height: context.displayHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Frame 1011 1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: CompletedExercisesGrid(
              exercises: exercises,
              playerId: playerId,
              playerName: playerName,
              playerPhoto: playerPhoto,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h),
            ),
          ),
        ),
      ),
    );
  }
}
