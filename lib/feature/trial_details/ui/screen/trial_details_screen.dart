import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import 'package:flutter/material.dart';

import '../widget/trial_details_app_bar.dart';
import '../widget/trial_image_widget.dart';
import '../widget/trial_info_widget.dart';

/// Trial details (تفاصيل التجربة) — one screen for every role.
///
/// This is the renamed, de-misspelled `ExperianceDetailsScreen`. The trial's
/// title, age band and exercises are driven by `TrialDetailsCubit`; [title],
/// [heroTag] and [trialImage] come from the list tile that opened it, so the
/// hero image and header paint instantly while the details load.
class TrialDetailsScreen extends StatelessWidget {
  const TrialDetailsScreen({
    super.key,
    required this.trialImage,
    required this.heroTag,
    required this.title,
  });

  final String trialImage;
  final String heroTag;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                verticalSpace(80),
                TrialImageWidget(trialImage: trialImage, heroTag: heroTag),
                verticalSpace(10),
                SlideEnimationWidget(index: 0, child: const TrialInfoWidget()),
              ],
            ),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            top: 0,
            child: TrialDetailsAppBar(title: title),
          ),
        ],
      ),
    );
  }
}
