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
import '../widget/club_org_summary_section.dart';
import '../widget/find_your_direction_widget.dart';
import '../widget/home_app_bar_widget.dart';
import '../widget/join_talent_widget/join_talent_widget.dart';
import '../widget/top_rate_widget/top_player_widget.dart';

/// The main club's home.
///
/// Identical to the shared home screen in chrome, order and styling — the only
/// difference is the club-at-a-glance summary, sitting between the exercises
/// and the trials.
class MainClubHomeScreen extends StatefulWidget {
  final VoidCallback? onDrawerTap;

  const MainClubHomeScreen({super.key, this.onDrawerTap});

  @override
  State<MainClubHomeScreen> createState() => _MainClubHomeScreenState();
}

class _MainClubHomeScreenState extends State<MainClubHomeScreen> {
  /// Tab indices on the shell that hosts this screen.
  static const int _teamTab = 1;
  static const int _requestsTab = 3;

  /// Tabs inside فريقي.
  static const int _playersTab = 0;
  static const int _coachesTab = 1;

  @override
  void initState() {
    super.initState();
    // Only when empty — entering فريقي refetches, so an unconditional call here
    // would duplicate every roster fetch.
    final ClubTeamCubit cubit = context.read<ClubTeamCubit>();
    if (cubit.groupedPlayers.isEmpty) cubit.fetchClubPlayers();
    if (cubit.cachedTrainees.isEmpty) cubit.fetchClubTrainees();
  }

  Future<void> _onRefresh() async {
    final ClubTeamCubit cubit = context.read<ClubTeamCubit>();
    cubit.fetchClubPlayers();
    cubit.fetchClubTrainees();
    context.read<ExperimentsCubit>().emitbestTrials(categoryId: '');
    context.read<TrainingCubit>().emitallExercises(
      categoryId: '',
      popular: true,
    );
    context.read<MainCubit>().emitCategories();

    await Future.delayed(const Duration(milliseconds: 800));
  }

  /// Opens فريقي on [tab], whichever tab it was last left on.
  void _openTeamOn(int tab) {
    final ClubTeamCubit cubit = context.read<ClubTeamCubit>();
    // Ask for the tab before switching, so a first mount reads it in initState.
    cubit.requestedTeamTab.value = tab;
    cubit.currentIndex.value = _teamTab;
  }

  void _openRequests() =>
      context.read<ClubTeamCubit>().currentIndex.value = _requestsTab;

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
                        ClubOrgSummarySection(
                          onOpenPlayers: () => _openTeamOn(_playersTab),
                          onOpenCoaches: () => _openTeamOn(_coachesTab),
                          onOpenRequests: _openRequests,
                          // PENDING: wired to RequestsCubit once the startup
                          // fetch tradeoff is confirmed. Until then the tile is
                          // an entry point rather than a wrong number.
                          pendingRequests: null,
                        ),
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
