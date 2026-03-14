import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/di/dependency_injection.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:falcon/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falcon/feature/club_team/ui/screen/club_my_team_screen.dart';
import 'package:falcon/feature/club_team/ui/screen/favorites_screen.dart';
import 'package:falcon/feature/main_screen/cubit/main_cubit.dart';
import 'package:falcon/feature/rank/cubit/rank_cubit.dart';
import 'package:falcon/feature/rank/ui/screen/rank_screen.dart';
import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:falcon/feature/reals/ui/screen/main_reals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';
import '../../cubit/scout_cubit.dart';
import 'scout_profile_screen.dart';

class ScoutMainScreen extends StatefulWidget {
  const ScoutMainScreen({super.key});

  @override
  State<ScoutMainScreen> createState() => _ScoutMainScreenState();
}

class _ScoutMainScreenState extends State<ScoutMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Main content ──────────────────────────────────────────────────
          ValueListenableBuilder<int>(
            valueListenable: context.read<ScoutCubit>().currentIndex,
            builder: (context, currentIndex, _) {
              return IndexedStack(
                index: currentIndex,
                children: [
                  // 0 — الرتب (Rank)
                  BlocProvider(
                    create: (_) => getIt<RankCubit>()..emitRank(),
                    child: const RankScreen(),
                  ),
                  // 1 — قائمة الاهتمامات (Favorites — read only for scout)
                  const FavoritesScreen(),
                  // 2 — اللاعيبين (Reels)
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (_) => getIt<MainCubit>()),
                      BlocProvider(
                        create: (_) =>
                            getIt<RealsCubit>()..emitreals(playerId: ''),
                      ),
                    ],
                    child: MainRealsScreen(
                      playerProfile: false,
                      playnowOrNot: currentIndex == 2,
                    ),
                  ),
                  // 3 — فريقي (Club players by position — read only)
                  const ClubMyTeamScreen(),
                  // 4 — ملفي (Scout profile)
                  const ScoutProfileScreen(),
                ],
              );
            },
          ),

          // ── Bottom navigation bar ─────────────────────────────────────────
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: context.read<ScoutCubit>().currentIndex,
              builder: (context, currentIndex, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: context.read<ScoutCubit>().show,
                  builder: (context, show, _) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: context.displayWidth,
                      height: show ? 80.h : 0,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SlideEnimationWidget(
                          index: 0,
                          child: Container(
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: SafeArea(
                              top: false,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(5, (index) {
                                  final isSelected = currentIndex == index;
                                  return Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        context
                                            .read<ScoutCubit>()
                                            .currentIndex
                                            .value = index;
                                      },
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: isSelected ? 26.h : 24.h,
                                            width: isSelected ? 26.h : 24.h,
                                            child: isSelected
                                                ? _activeIcons[index]
                                                : _inactiveIcons[index],
                                          ),
                                          CenterTextUtils(
                                            fontSize: 9,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? mainColor
                                                : mainColor.withOpacity(0.5),
                                            text: _titles[index],
                                          ),
                                          verticalSpace(4),
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            height: isSelected ? 6.h : 0,
                                            width: 6.w,
                                            decoration: BoxDecoration(
                                              color: mainColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> get _inactiveIcons => [
        Icon(Icons.leaderboard_outlined,
            color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.bookmark_border,
            color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.sports_soccer_outlined,
            color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.groups_outlined,
            color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.person_outline,
            color: mainColor.withOpacity(0.5), size: 24.h),
      ];

  List<Widget> get _activeIcons => [
        Icon(Icons.leaderboard, color: mainColor, size: 26.h),
        Icon(Icons.bookmark, color: mainColor, size: 26.h),
        Icon(Icons.sports_soccer, color: mainColor, size: 26.h),
        Icon(Icons.groups, color: mainColor, size: 26.h),
        Icon(Icons.person, color: mainColor, size: 26.h),
      ];

  List<String> get _titles => [
        'الرتب'.tr(),
        'الاهتمامات'.tr(),
        'اللاعيبين'.tr(),
        'فريقي'.tr(),
        'ملفي'.tr(),
      ];
}
