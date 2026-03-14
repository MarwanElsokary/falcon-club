import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/di/dependency_injection.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';
import 'package:falcon/feature/club_team/ui/screen/favorites_screen.dart';
import 'package:falcon/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falcon/feature/main_screen/cubit/main_cubit.dart';
import 'package:falcon/feature/rank/cubit/rank_cubit.dart';
import 'package:falcon/feature/rank/ui/screen/rank_screen.dart';
import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:falcon/feature/reals/ui/screen/main_reals_screen.dart';
import 'package:falcon/feature/training/cubit/training_cubit.dart';
import 'package:falcon/feature/training/ui/screen/training_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/thems/thems.dart';
import '../../cubit/scout_cubit.dart';
import 'scout_home_screen.dart';

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
          // ── Main content ────────────────────────────────────────────────
          ValueListenableBuilder<int>(
            valueListenable: context.read<ScoutCubit>().currentIndex,
            builder: (context, currentIndex, _) {
              return IndexedStack(
                index: currentIndex,
                children: [
                  // 0 — الرئيسية (Scout Home — read-only)
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => getIt<ExperimentsCubit>()
                          ..emitallTrials(categoryId: ''),
                      ),
                      BlocProvider(
                        create: (_) => getIt<TrainingCubit>()
                          ..emitallExercises(categoryId: '', popular: false),
                      ),
                    ],
                    child: const ScoutHomeScreen(),
                  ),

                  // 1 — التمارين (Training — read-only)
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => getIt<TrainingCubit>()
                          ..emitallExercises(categoryId: '', popular: false),
                      ),
                      BlocProvider(
                        create: (_) => getIt<MainCubit>()..emitCategories(),
                      ),
                    ],
                    child: const TrainingScreen(),
                  ),

                  // 2 — الريلز (Reels — center tab)
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

                  // 3 — اللاعبين (Favorites — read-only for scout)
                  const FavoritesScreen(),

                  // 4 — الرتب (Rank)
                  BlocProvider(
                    create: (_) => getIt<RankCubit>()..emitRank(),
                    child: const RankScreen(),
                  ),
                ],
              );
            },
          ),

          // ── Bottom navigation bar ────────────────────────────────────────
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
                                  final isCenter = index == 2;
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
                                            height: isCenter
                                                ? (isSelected ? 30.h : 28.h)
                                                : (isSelected ? 26.h : 24.h),
                                            width: isCenter
                                                ? (isSelected ? 30.h : 28.h)
                                                : (isSelected ? 26.h : 24.h),
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
        Icon(Icons.home_outlined,
            color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.fitness_center_outlined,
            color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.sports_soccer_outlined,
            color: mainColor.withOpacity(0.5), size: 28.h),
        Icon(Icons.people_outline,
            color: mainColor.withOpacity(0.5), size: 24.h),
        Icon(Icons.leaderboard_outlined,
            color: mainColor.withOpacity(0.5), size: 24.h),
      ];

  List<Widget> get _activeIcons => [
        Icon(Icons.home, color: mainColor, size: 26.h),
        Icon(Icons.fitness_center, color: mainColor, size: 26.h),
        Icon(Icons.sports_soccer, color: mainColor, size: 30.h),
        Icon(Icons.people, color: mainColor, size: 26.h),
        Icon(Icons.leaderboard, color: mainColor, size: 26.h),
      ];

  List<String> get _titles => [
        'الرئيسية'.tr(),
        'التمارين'.tr(),
        'الريلز'.tr(),
        'اللاعبين'.tr(),
        'الرتب'.tr(),
      ];
}
