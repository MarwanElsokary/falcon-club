import 'package:cached_network_image/cached_network_image.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/text_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../experiance_details_screen/cubit/experiance_details_cubit.dart';
import '../../../../training_details/data/model/exercise_details_model.dart';
import '../../cubit/scout_training_details_cubit.dart';
import '../../cubit/scout_training_details_state.dart';
import '../widget/scout_exercise_info_section.dart';
import '../widget/scout_players_section.dart';

class ScoutTrainingDetailsScreen extends StatefulWidget {
  const ScoutTrainingDetailsScreen({super.key});

  @override
  State<ScoutTrainingDetailsScreen> createState() =>
      _ScoutTrainingDetailsScreenState();
}

class _ScoutTrainingDetailsScreenState
    extends State<ScoutTrainingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final exerciseId = context
        .read<ScoutTrainingDetailsCubit>()
        .currentExerciseId;
    if (exerciseId != null) {
      context.read<ExperianceDetailsCubit>().fetchExercisePlayers(
        exerciseId: exerciseId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: BlocBuilder<ScoutTrainingDetailsCubit, ScoutTrainingDetailsState>(
        builder: (context, state) {
          return state.maybeWhen(
            success: (exerciseDetails) =>
                _buildContent(context, exerciseDetails),
            orElse: () => _buildLoading(),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Stack(
      children: [
        const Center(child: CupertinoActivityIndicator(color: Colors.white)),
        PositionedDirectional(
          child: SafeArea(child: BackButton(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ExerciseDetailsModel exerciseDetails,
  ) {
    return Stack(
      children: [
        SizedBox(
          width: context.displayWidth,
          height: context.displayHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeroImage(exerciseDetails),
                Container(
                  height: 10.h,
                  width: context.displayWidth,
                  color: mainColor,
                ),
                ScoutExerciseInfoSection(exerciseDetails: exerciseDetails),
                // ✅ مباشرة بدون TrainingDetailsCubit wrapper
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const ScoutPlayersSection(),
                ),
              ],
            ),
          ),
        ),
        PositionedDirectional(
          child: SafeArea(child: BackButton(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildHeroImage(ExerciseDetailsModel exerciseDetails) {
    return SizedBox(
      width: context.displayWidth,
      height: 320.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: exerciseDetails.data.photoPath ?? '',
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Skeletonizer(enabled: true, child: Container(color: mainColor)),
            errorWidget: (_, __, ___) => Container(
              color: mainColor,
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/unavailabeImage.svg',
                  width: 60.w,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, mainColor.withOpacity(0.7)],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            bottom: 16.h,
            start: 16.w,
            end: 16.w,
            child: TextUtils(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              text: exerciseDetails.data.title ?? '',
            ),
          ),
        ],
      ),
    );
  }
}
