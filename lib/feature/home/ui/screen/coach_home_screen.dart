import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../experiments/cubit/experiments_cubit.dart';
import '../../../main_screen/cubit/main_cubit.dart';
import '../../../training/cubit/training_cubit.dart';
import '../widget/coach_roster_section.dart';
import '../widget/find_your_direction_widget.dart';
import '../widget/home_app_bar_widget.dart';
import '../widget/join_talent_widget/join_talent_widget.dart';
import '../widget/top_rate_widget/top_player_widget.dart';

/// The coach's home.
///
/// Identical to the shared home screen in chrome, order and styling — the only
/// difference is his squad, sitting between the exercises and the trials.
class CoachHomeScreen extends StatefulWidget {
  final VoidCallback? onDrawerTap;

  const CoachHomeScreen({super.key, this.onDrawerTap});

  @override
  State<CoachHomeScreen> createState() => _CoachHomeScreenState();
}

class _CoachHomeScreenState extends State<CoachHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Only when empty: entering فريقي refetches anyway, so an unconditional
    // call here would duplicate every roster fetch.
    final ClubTeamCubit cubit = context.read<ClubTeamCubit>();
    if (cubit.groupedPlayers.isEmpty) {
      cubit.fetchClubPlayers();
    }
  }

  Future<void> _onRefresh() async {
    context.read<ClubTeamCubit>().fetchClubPlayers();
    context.read<ExperimentsCubit>().emitbestTrials(categoryId: '');
    context.read<TrainingCubit>().emitallExercises(
      categoryId: '',
      popular: true,
    );
    context.read<MainCubit>().emitCategories();

    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: whiteclr,
          appBar: PreferredSize(
            preferredSize: Size(context.displayWidth, 66.h),
            child: Container(color: whiteclr),
          ),
          body: Container(
            color: mainColor,
            child: ClipRect(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  CupertinoSliverRefreshControl(
                    onRefresh: _onRefresh,
                    builder:
                        (
                          context,
                          refreshState,
                          pulledExtent,
                          refreshTriggerPullDistance,
                          refreshIndicatorExtent,
                        ) {
                          return Container(
                            alignment: Alignment.center,
                            child: const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: whiteclr,
                              ),
                            ),
                          );
                        },
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        JoinTalentWidget(),
                        verticalSpace(10),
                        const CoachRosterSection(),
                        verticalSpace(10),
                        FindYourDirectionWidget(),
                        verticalSpace(10),
                        TopPlayerWidget(),
                        verticalSpace(80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        PositionedDirectional(
          end: 0,
          child: IgnorePointer(
            child: SvgPicture.asset('assets/svgs/app_bar_icon.svg'),
          ),
        ),

        PositionedDirectional(
          top: 0,
          start: 0,
          end: 0,
          child: SafeArea(
            child: HomeAppBarWidget(onDrawerTap: widget.onDrawerTap),
          ),
        ),
      ],
    );
  }
}
