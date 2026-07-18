import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/button_utils.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../profile/domain/entities/completed_exercise.dart';
import '../../../profile/presentation/cubit/completed_exercises_cubit.dart';
import '../../../profile/presentation/cubit/completed_exercises_state.dart';
import '../../../profile/presentation/widgets/profile_section_card.dart';
import '../screen/completed_exercises_screen.dart';
import 'completed_exercises_grid.dart';

/// The "التمارين المنجزة" section on the player profile: a preview grid (up to 4)
/// with an "عرض الكل (N)" that opens the full list. Follows the Videos section's
/// pattern, hosted in the shared [ProfileSectionCard]. No rating anywhere.
///
/// Hidden while loading or on failure (an optional section); when loaded it
/// shows the card — an empty message, or the preview + view-all.
class CompletedExercisesWidget extends StatelessWidget {
  const CompletedExercisesWidget({
    super.key,
    required this.playerId,
    required this.playerName,
    required this.playerPhoto,
  });

  final String playerId;
  final String playerName;
  final String? playerPhoto;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompletedExercisesCubit, CompletedExercisesState>(
      builder: (context, state) {
        if (state is! CompletedExercisesLoaded) {
          return const SizedBox.shrink();
        }
        final List<CompletedExercise> exercises = state.exercises;

        return ProfileSectionCard(
          title: 'التمارين المنجزة'.tr(),
          child: exercises.isEmpty
              ? _empty()
              : _content(context, exercises),
        );
      },
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        children: [
          verticalSpace(10),
          CenterTextUtils(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: blackclr,
            text: 'لا يوجد تمارين منجزة'.tr(),
          ),
          verticalSpace(10),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, List<CompletedExercise> exercises) {
    return Column(
      children: [
        CompletedExercisesGrid(
          exercises: exercises,
          playerId: playerId,
          playerName: playerName,
          playerPhoto: playerPhoto,
          limit: 4,
        ),
        if (exercises.length > 4) ...[
          verticalSpace(12),
          ButtonUtils(
            contantWidget: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SvgPicture.asset(
                width: 30.w,
                'assets/svgs/solar_arrow-up-broken.svg',
              ),
            ),
            text: '${'عرض الكل'.tr()} (${exercises.length})',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => CompletedExercisesScreen(
                  exercises: exercises,
                  playerId: playerId,
                  playerName: playerName,
                  playerPhoto: playerPhoto,
                ),
              ),
            ),
            colorstext: Colors.white,
            background: mainColor,
          ),
        ],
      ],
    );
  }
}
