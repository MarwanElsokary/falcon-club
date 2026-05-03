import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import 'package:falconclubapp/feature/experiance_details_screen/ui/widget/experiance_details_app_bar.dart';
import 'package:falconclubapp/feature/experiance_details_screen/ui/widget/experiance_details_image_widget.dart';
import 'package:flutter/material.dart';

import '../widget/experience_training_info_widget.dart';

class ExperianceDetailsScreen extends StatelessWidget {
  const ExperianceDetailsScreen({
    super.key,
    required this.experianceImage,
    required this.heroTag,
    required this.title,
  });
  final String experianceImage;
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
                ExperianceDetailsImageWidget(
                  experianceImage: experianceImage,
                  heroTag: heroTag,
                ),
                verticalSpace(10),
                //ExperienceTrainingInfoWidget
                SlideEnimationWidget(
                  index: 0,
                  child: ExperienceTrainingInfoWidget(),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            start: 0,
            end: 0,
            top: 0,
            child: ExperianceDetailsAppBar(title: title),
          ),
        ],
      ),
    );
  }
}
