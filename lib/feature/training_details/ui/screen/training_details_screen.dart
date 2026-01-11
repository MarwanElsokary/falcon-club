import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/feature/training_details/cubit/training_details_cubit.dart';
import 'package:falcon/feature/training_details/ui/widget/vidoe_upload_load.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../cubit/training_details_state.dart';
import '../widget/story_widget.dart';
import '../widget/training_details_info.dart';

class TrainingDetailsScreen extends StatelessWidget {
  const TrainingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TrainingDetailsCubit, TrainingDetailsState>(
        builder: (context, state) {
          return Stack(
            children: [
              BlocBuilder<TrainingDetailsCubit, TrainingDetailsState>(
                buildWhen: (previous, current) =>
                    current is exerciseDetailsLoading ||
                    current is exerciseDetailsSuccess ||
                    current is exerciseDetailsError,
                builder: (context, state) {
                  return state.maybeWhen(
                    exerciseDetailssuccess: (exerciseDetails) {
                      return Stack(
                        children: [
                          SizedBox(
                            width: context.displayWidth / 1,
                            height: context.displayHeight / 1,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  //
                                  // TrainingDetailsImageWidget(),
                                  StoryWidget(
                                    image: exerciseDetails.data.photoPath,
                                    videos: exerciseDetails.data.videos,
                                  ),
                                  Container(
                                    height: 10.h,
                                    width: context.displayWidth / 1,
                                    color: mainColor,
                                  ),
                                  TrainingDetailsInfo(
                                    exerciseDetails: exerciseDetails,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PositionedDirectional(
                            child: SafeArea(
                              child: BackButton(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                    orElse: () {
                      return Stack(
                        children: [
                          Center(
                            child: Lottie.asset('assets/lottie/load.json'),
                          ),
                          PositionedDirectional(
                            child: SafeArea(
                              child: BackButton(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              PositionedDirectional(child: VidoeUploadLoad()),
            ],
          );
        },
      ),
    );
  }
}
