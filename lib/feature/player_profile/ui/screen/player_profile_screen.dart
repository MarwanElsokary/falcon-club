import 'dart:developer';

import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/thems/thems.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:falcon/feature/main_screen/cubit/main_cubit.dart';
import 'package:falcon/feature/main_screen/cubit/main_state.dart';
import 'package:falcon/feature/player_profile/ui/widget/player_more_info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../player_profile/ui/widget/player_about_me_widget.dart';
import '../../../player_profile/ui/widget/player_chart_widget.dart';
import '../../../player_profile/ui/widget/player_experiance_widget.dart';
import '../../../player_profile/ui/widget/player_image_widget.dart';
import '../../../player_profile/ui/widget/player_information_widget.dart';
import '../../../player_profile/ui/widget/player_profile_app_bar_widget.dart';
import '../../../player_profile/ui/widget/player_videos_widget.dart';

class PlayerProfileScreen extends StatelessWidget {
  const PlayerProfileScreen({super.key, required this.ismyProfile});

  final bool ismyProfile;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(context.displayWidth / 1, 30.h),
          child: Container(
            color: mainColor,
            child: SafeArea(child: PlayerProfileAppBarWidget()),
          ),
        ),
        body: Container(
          width: context.displayWidth / 1,
          height: context.displayHeight / 1,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Frame 1011 1.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocBuilder<MainCubit, MainState>(
            buildWhen: (previous, current) =>
                current is playerProfileLoading ||
                current is playerProfileSuccess ||
                current is playerProfileError,
            builder: (context, state) {
              log(state.toString());
              return state.maybeWhen(
                playerProfilesuccess: (playerProfile) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        verticalSpace(20),
                        //user Information
                        // PlayerInformationWidget(playerProfile: playerProfile),
                        // verticalSpace(20),
                        //userImage
                        PlayerImageWidget(playerProfile: playerProfile),
                        verticalSpace(5),
                        //player chart
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: SizedBox(
                            width: 300.w,
                            height: 350.w,
                            child: PlayerRadarChart(
                              speed: 24.56,
                              strength: 10.3,
                              ballControl: 0.0,
                              tackling: 12.0,
                              dribbling: 50.0,
                            ),
                          ),
                        ),
                        //  player moer info
                        SlideEnimationWidget(
                          index: 0,
                          child: PlayerMoreInfoWidget(
                            playerProfile: playerProfile,
                          ),
                        ),

                        //about me
                        verticalSpace(10),
                        PlayerAboutMeWidget(playerProfile: playerProfile),
                        verticalSpace(10),
                        //player Videos
                        PlayerVideosWidget(),
                        verticalSpace(10),
                        PlayerExperianceWidget(playerProfile: playerProfile),

                        verticalSpace(20),
                      ],
                    ),
                  );
                },
                orElse: () {
                  return SizedBox(
                    width: context.displayWidth / 1,
                    height: 190.h,
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: 20.w,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
