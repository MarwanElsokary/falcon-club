import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../widget/find_your_direction_widget.dart';
import '../widget/home_app_bar_widget.dart';
import '../widget/join_talent_widget/join_talent_widget.dart';
import '../widget/top_rate_widget/top_player_widget.dart';
import '../widget/upload_training_wdget/upload_training_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: whiteclr,
          appBar: PreferredSize(
            preferredSize: Size(context.displayWidth / 1, 66.h),
            child: Container(color: whiteclr),
          ),
          body: Container(
            color: mainColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //JoinTalentWidget
                  JoinTalentWidget(),
                  verticalSpace(10),
                  //FindYourDirectionWidget
                  FindYourDirectionWidget(),
                  verticalSpace(10),
                  //TopPlayersWidget
                  TopPlayerWidget(),
                  //UploadTrainingWidget
                  UploadTrainingWidget(),
                  verticalSpace(100),
                ],
              ),
            ),
          ),
        ),
        PositionedDirectional(
          end: 0,
          child: SvgPicture.asset('assets/svgs/app_bar_icon.svg'),
        ),
        //appbar
        PositionedDirectional(child: SafeArea(child: HomeAppBarWidget())),
      ],
    );
  }
}
