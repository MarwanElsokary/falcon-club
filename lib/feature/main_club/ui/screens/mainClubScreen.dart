import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import 'package:falconclubapp/feature/main_club/ui/screens/requests_screen.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_cubit.dart';
import 'package:falconclubapp/feature/rank/ui/screen/rank_screen.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:falconclubapp/feature/reals/ui/screen/main_reals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/thems/thems.dart';
import '../../../../core/widget/exit_confirmation_scope.dart';
import '../../../club_team/cubit/club_team_cubit.dart';
import '../../../experiments/cubit/experiments_cubit.dart';
import '../../../home/ui/screen/main_club_home_screen.dart';
import '../../../main_screen/ui/widget/custom_drawer_widget.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../training/cubit/training_cubit.dart';
import '../../cubit/requests_cubit.dart';
import 'ClubMyTeamScreen.dart';

class MainClubScreen extends StatefulWidget {
  const MainClubScreen({super.key});

  @override
  State<MainClubScreen> createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends State<MainClubScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final ClubTeamCubit _clubTeamCubit;

  /// Tabs the user has actually opened. Index 0 (الرئيسية) is always built; the
  /// rest mount lazily on first visit so their cubits/fetches don't fire at
  /// shell startup. Once visited, a tab stays alive (set only grows) — same
  /// state-preservation as a plain IndexedStack for the tabs one actually uses.
  final Set<int> _visited = <int>{0};

  @override
  void initState() {
    super.initState();
    _clubTeamCubit = context.read<ClubTeamCubit>();
    // F9: the route provider (app_router) already calls emitMyProfile on this
    // same instance — no second call here. Nothing consumes ClubTeamCubit's
    // profile state; the route's call covers the cache side-effect.
    _clubTeamCubit.currentIndex.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_clubTeamCubit.currentIndex.value == 1) {
      _clubTeamCubit.fetchClubPlayers();
    }
  }

  @override
  void dispose() {
    _clubTeamCubit.currentIndex.removeListener(_onTabChanged);
    super.dispose();
  }

  void _toggleDrawer() {
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      _scaffoldKey.currentState?.closeDrawer();
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExitConfirmationScope(
      scaffoldKey: _scaffoldKey,
      child: BlocProvider(
        // ✅ مفيش isUserSubscribed — الـ cubit بيجيب isSubscribed من الـ cache بعد الـ API
        create: (_) => getIt<RankCubit>()..emitRank(),
        child: Scaffold(
          key: _scaffoldKey,

          drawer: BlocProvider(
            create: (_) => getIt<ProfileCubit>()..load(),
            child: const CustomDrawer(),
          ),

          body: Stack(
            children: [
              ValueListenableBuilder<int>(
                valueListenable: context.read<ClubTeamCubit>().currentIndex,
                builder: (context, currentIndex, _) {
                  // Mark the visited tab so its subtree is built (and stays built).
                  _visited.add(currentIndex);
                  return IndexedStack(
                    index: currentIndex,
                    children: [
                      // 0 — الرئيسية
                      _visited.contains(0)
                          ? MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (_) =>
                                      getIt<ExperimentsCubit>()
                                        ..emitbestTrials(categoryId: ''),
                                ),
                                BlocProvider(
                                  create: (_) => getIt<TrainingCubit>()
                                    ..emitallExercises(
                                      categoryId: '',
                                      popular: true,
                                    ),
                                ),
                                BlocProvider(
                                  create: (_) =>
                                      getIt<MainCubit>()..emitMyProfile(),
                                ),
                              ],
                              child: MainClubHomeScreen(
                                onDrawerTap: _toggleDrawer,
                              ),
                            )
                          : const SizedBox.shrink(),

                      // 1 — فريقي
                      _visited.contains(1)
                          ? const ClubMainMyTeamScreen()
                          : const SizedBox.shrink(),

                      // 2 — اللاعيبين (Reels)
                      _visited.contains(2)
                          ? MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (_) =>
                                      getIt<RealsCubit>()
                                        ..emitreals(playerId: ''),
                                ),
                              ],
                              child: MainRealsScreen(
                                playerProfile: false,
                                playnowOrNot: currentIndex == 2,
                                // The shell owns its own chrome: reels asks, this
                                // drives the same notifier the bottom bar below
                                // already listens to.
                                onChromeVisibilityChanged: (bool visible) =>
                                    context.read<ClubTeamCubit>().show.value =
                                        visible,
                              ),
                            )
                          : const SizedBox.shrink(),

                      // 3 — قائمة الاهتمامات
                      _visited.contains(3)
                          ? BlocProvider(
                              create: (_) =>
                                  getIt<RequestsCubit>()..fetchRequests(),
                              child: const RequestsScreen(),
                            )
                          : const SizedBox.shrink(),

                      // 4 — الرتب
                      _visited.contains(4)
                          ? const RankScreen()
                          : const SizedBox.shrink(),
                    ],
                  );
                },
              ),

              // ── Bottom navigation bar ──────────────────────────────────────
              PositionedDirectional(
                bottom: 0,
                start: 0,
                end: 0,
                child: ValueListenableBuilder<int>(
                  valueListenable: context.read<ClubTeamCubit>().currentIndex,
                  builder: (context, currentIndex, _) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: context.read<ClubTeamCubit>().show,
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
                                                    .read<ClubTeamCubit>()
                                                    .currentIndex
                                                    .value =
                                                index;
                                          },
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: isSelected
                                                    ? 26.h
                                                    : 24.h,
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
                                                    : mainColor.withOpacity(
                                                        0.5,
                                                      ),
                                                text: _titles[index],
                                              ),
                                              verticalSpace(4),
                                              AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
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
        ),
      ),
    );
  }

  List<Widget> get _inactiveIcons => [
    SvgPicture.asset(
      'assets/svgs/home_unSelect.svg',
      color: mainColor.withOpacity(0.5),
    ),
    Icon(Icons.groups_outlined, color: mainColor.withOpacity(0.5), size: 24.h),
    SvgPicture.asset(
      'assets/svgs/reals_un_select.svg',
      color: mainColor.withOpacity(0.5),
    ),
    Icon(Icons.inbox_outlined, color: mainColor.withOpacity(0.5), size: 24.h),

    SvgPicture.asset(
      'assets/svgs/rank_icon.svg',
      color: mainColor.withOpacity(0.5),
    ),
  ];

  List<Widget> get _activeIcons => [
    SvgPicture.asset('assets/svgs/home_select.svg'),
    Icon(Icons.groups, color: mainColor, size: 26.h),
    SvgPicture.asset('assets/svgs/reals_select.svg'),
    Icon(Icons.inbox_rounded, color: mainColor, size: 26.h),
    SvgPicture.asset('assets/svgs/rank_icon.svg', color: mainColor),
  ];

  List<String> get _titles => [
    'الرئيسية'.tr(),
    'فريقي'.tr(),
    'اللاعيبين'.tr(),
    'الطلبات'.tr(),
    'الرتب'.tr(),
  ];
}
