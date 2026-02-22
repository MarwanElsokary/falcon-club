import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:falcon/core/enums/user_type.dart';
import 'package:falcon/core/helpers/extensions.dart';
import 'package:falcon/core/helpers/spacing.dart';
import 'package:falcon/core/routing/routes.dart';
import 'package:falcon/core/widget/center_text_utils.dart';
import 'package:falcon/core/cubit/user_type_cubit.dart';
import 'package:falcon/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falcon/feature/reals/cubit/reals_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:falcon/core/widget/slide_enimation_widget.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/thems/thems.dart';
import '../../../experiments/ui/screen/experiment_screen.dart';
import '../../../home/ui/screen/home_screen.dart';
import '../../../players_list/ui/screen/players_list_screen.dart';
import '../../../club_team/ui/screen/club_team_screen.dart';
import '../../../reals/ui/screen/main_reals_screen.dart';
import '../../../signup/ui/widget/profile_completion_middleware.dart';
import '../../../signup/ui/widget/profile_completion_progress.dart';
import '../../../training/cubit/training_cubit.dart';
import '../../cubit/main_cubit.dart';
import '../widget/custom_drawer_widget.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MainCubit>().emitMyProfile();
  }

  /// Build the list of tab screens based on user type.
  List<Widget> _buildScreens(UserType userType) {
    if (userType == UserType.scout) {
      // Scout: Home, Highlights, Players List, Scout
      return [
        // Tab 0: Home
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  getIt<ExperimentsCubit>()..emitbestTrials(categoryId: ''),
            ),
            BlocProvider(
              create: (context) =>
                  getIt<TrainingCubit>()
                    ..emitallExercises(categoryId: '', popular: true),
            ),
          ],
          child: const HomeScreen(),
        ),

        // Tab 1: Highlights/Clips
        BlocProvider(
          create: (context) => getIt<RealsCubit>()..emitreals(playerId: ''),
          child: MainRealsScreen(
            playerProfile: false,
            playnowOrNot:
                context.read<MainCubit>().currentIndex.value == 1,
          ),
        ),

        // Tab 2: Players List
        const PlayersListScreen(),

        // Tab 3: Scout / Search
        BlocProvider(
          create: (context) =>
              getIt<ExperimentsCubit>()
                ..emitallTrials(categoryId: '')
                ..emitbestTrials(categoryId: ''),
          child: const ExperimentScreen(),
        ),
      ];
    }

    // Club: Home, My Team, Highlights, Players List, Scout (full 5 tabs)
    return [
      // Tab 0: Home
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                getIt<ExperimentsCubit>()..emitbestTrials(categoryId: ''),
          ),
          BlocProvider(
            create: (context) =>
                getIt<TrainingCubit>()
                  ..emitallExercises(categoryId: '', popular: true),
          ),
        ],
        child: const HomeScreen(),
      ),

      // Tab 1: My Team
      const ClubTeamScreen(),

      // Tab 2: Highlights/Clips
      BlocProvider(
        create: (context) => getIt<RealsCubit>()..emitreals(playerId: ''),
        child: MainRealsScreen(
          playerProfile: false,
          playnowOrNot:
              context.read<MainCubit>().currentIndex.value == 2,
        ),
      ),

      // Tab 3: Interest List / Players List
      const PlayersListScreen(),

      // Tab 4: Scout
      BlocProvider(
        create: (context) =>
            getIt<ExperimentsCubit>()
              ..emitallTrials(categoryId: '')
              ..emitbestTrials(categoryId: ''),
        child: const ExperimentScreen(),
      ),
    ];
  }

  /// Build the navigation icon lists based on user type.
  List<Widget> _getInactiveIcons(UserType userType) {
    if (userType == UserType.scout) {
      return [
        Icon(Icons.home_outlined, color: mainColor.withOpacity(0.5), size: 24),
        Icon(Icons.videocam_outlined,
            color: mainColor.withOpacity(0.5), size: 24),
        Icon(Icons.bookmark_border,
            color: mainColor.withOpacity(0.5), size: 24),
        Icon(Icons.search, color: mainColor.withOpacity(0.5), size: 24),
      ];
    }
    return [
      Icon(Icons.home_outlined, color: mainColor.withOpacity(0.5), size: 24),
      Icon(Icons.groups_outlined, color: mainColor.withOpacity(0.5), size: 24),
      Icon(Icons.videocam_outlined,
          color: mainColor.withOpacity(0.5), size: 24),
      Icon(Icons.bookmark_border, color: mainColor.withOpacity(0.5), size: 24),
      Icon(Icons.search, color: mainColor.withOpacity(0.5), size: 24),
    ];
  }

  List<Widget> _getActiveIcons(UserType userType) {
    if (userType == UserType.scout) {
      return [
        Icon(Icons.home_filled, color: mainColor, size: 26),
        Icon(Icons.videocam, color: mainColor, size: 26),
        Icon(Icons.bookmark, color: mainColor, size: 26),
        Icon(Icons.search, color: mainColor, size: 26),
      ];
    }
    return [
      Icon(Icons.home_filled, color: mainColor, size: 26),
      Icon(Icons.groups, color: mainColor, size: 26),
      Icon(Icons.videocam, color: mainColor, size: 26),
      Icon(Icons.bookmark, color: mainColor, size: 26),
      Icon(Icons.search, color: mainColor, size: 26),
    ];
  }

  List<String> _getTitles(UserType userType) {
    if (userType == UserType.scout) {
      return [
        'الرئيسية'.tr(),
        'اللقطات'.tr(),
        'قائمة الاهتمامات'.tr(),
        'الباحث'.tr(),
      ];
    }
    return [
      'الرئيسية'.tr(),
      'فريقي'.tr(),
      'اللقطات'.tr(),
      'قائمة الاهتمامات'.tr(),
      'الباحث'.tr(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserTypeCubit, UserType>(
      builder: (context, userType) {
        final screens = _buildScreens(userType);
        final inactiveIcons = _getInactiveIcons(userType);
        final activeIcons = _getActiveIcons(userType);
        final titles = _getTitles(userType);
        final tabCount = titles.length;

        return Scaffold(
          key: context.read<MainCubit>().sliderDrawerKey,
          drawer: CustomDrawer(),
          body: Stack(
            children: [
              IndexedStack(
                index: context.read<MainCubit>().currentIndex.value,
                children: screens,
              ),
              PositionedDirectional(
                bottom: 0,
                start: 0,
                end: 0,
                child: ValueListenableBuilder(
                  valueListenable: context.read<MainCubit>().currentIndex,
                  builder: (context, currentIndex, _) {
                    log(currentIndex.toString());
                    return ValueListenableBuilder(
                      valueListenable: context.read<MainCubit>().show,
                      builder: (context, show, _) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: context.displayWidth / 1,
                          height: show ? 130.h : 0,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SlideEnimationWidget(
                                  index: 0,
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          verticalSpace(50),
                                          Container(
                                            height: 80.h,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: AssetImage(
                                                  'assets/images/Subtract.png',
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: List.generate(
                                                tabCount,
                                                (index) {
                                                  bool isSelected =
                                                      currentIndex == index;

                                                  return Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          context
                                                              .read<MainCubit>()
                                                              .currentIndex
                                                              .value = index;
                                                        });
                                                      },
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: isSelected
                                                                ? 26.h
                                                                : 24.h,
                                                            width: isSelected
                                                                ? 26.h
                                                                : 24.h,
                                                            child: isSelected
                                                                ? activeIcons[
                                                                    index]
                                                                : inactiveIcons[
                                                                    index],
                                                          ),
                                                          CenterTextUtils(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                isSelected
                                                                    ? FontWeight
                                                                        .w700
                                                                    : FontWeight
                                                                        .w500,
                                                            color: isSelected
                                                                ? mainColor
                                                                : mainColor
                                                                    .withOpacity(
                                                                    0.5,
                                                                  ),
                                                            text: titles[index],
                                                          ),
                                                          verticalSpace(5),
                                                          AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                              milliseconds: 300,
                                                            ),
                                                            height: isSelected
                                                                ? 7.h
                                                                : 0.h,
                                                            width: 7.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: mainColor,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ProfileCheckWrapper(
                                        showInHome: true,
                                        child: const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
      },
    );
  }
}
