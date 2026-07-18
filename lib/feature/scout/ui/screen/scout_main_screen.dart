import '../../../exercise/presentation/cubit/exercise_list_cubit.dart';
import '../../../exercise/presentation/screens/exercise_list_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/helpers/extensions.dart';
import 'package:falconclubapp/core/helpers/spacing.dart';
import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/center_text_utils.dart';
import 'package:falconclubapp/core/widget/slide_enimation_widget.dart';
import 'package:falconclubapp/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_cubit.dart';
import 'package:falconclubapp/feature/rank/ui/screen/rank_screen.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:falconclubapp/feature/reals/ui/screen/main_reals_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/screens/favorites_screen.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../training/cubit/training_cubit.dart';
import 'ScoutHomeScreen.dart';
import 'custom_drawer_widget_scout.dart';

class ScoutMainScreen extends StatefulWidget {
  const ScoutMainScreen({super.key});

  @override
  State<ScoutMainScreen> createState() => _ScoutMainScreenState();
}

class _ScoutMainScreenState extends State<ScoutMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);
  final ValueNotifier<bool> _show = ValueNotifier(true);

  /// Tabs the user has actually opened. Index 0 (الرئيسية) is always built; the
  /// rest mount lazily on first visit so their cubits/fetches don't fire at
  /// shell startup. Once visited, a tab stays alive (set only grows) — same
  /// state-preservation as a plain IndexedStack for the tabs one actually uses.
  final Set<int> _visited = <int>{0};

  void _toggleDrawer() {
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      _scaffoldKey.currentState?.closeDrawer();
    } else {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  void dispose() {
    _currentIndex.dispose();
    _show.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ RankCubit واحد على مستوى الـ ScoutMainScreen كله
    // بيشارك بين ScoutHomeScreen (index 0) و RankScreen (index 4)
    return BlocProvider(
      create: (_) => getIt<RankCubit>()..emitRank(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: BlocProvider(
          create: (_) => getIt<ProfileCubit>()..load(),
          child: const CustomDrawerScout(),
        ),
        body: Stack(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _currentIndex,
              builder: (context, index, _) {
                // Mark the visited tab so its subtree is built (and stays built).
                _visited.add(index);
                return IndexedStack(
                  index: index,
                  children: [
                    // 0 — الرئيسية
                    _visited.contains(0)
                        ? MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) => getIt<ExperimentsCubit>()
                                  ..emitbestTrials(categoryId: ''),
                              ),
                              BlocProvider(
                                create: (_) => getIt<MainCubit>()
                                  ..emitMyProfile()
                                  ..emitCategories(),
                              ),
                              // ❌ مفيش RankCubit هنا — بيجيه من فوق
                              //
                              // The ScoutTrainingCubit that used to sit here as
                              // well was dead weight: it fetched the same
                              // endpoint a second time, and
                              // `talent_slider_scout_widget` renders from
                              // TrainingCubit, so nothing ever read the result.
                              BlocProvider(
                                create: (_) => getIt<TrainingCubit>()
                                  ..emitallExercises(
                                    categoryId: '',
                                    popular: true,
                                  ),
                              ),
                            ],
                            child: ScoutHomeScreen(onDrawerTap: _toggleDrawer),
                          )
                        : const SizedBox.shrink(),

                    // 1 — التمارين
                    // The shared exercise list. As a tab nothing can be popped,
                    // so it renders without a back row, exactly as before.
                    _visited.contains(1)
                        ? MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) =>
                                    getIt<ExerciseListCubit>()..loadAll(),
                              ),
                              BlocProvider(
                                create: (_) =>
                                    getIt<MainCubit>()..emitCategories(),
                              ),
                            ],
                            child: const ExerciseListScreen(),
                          )
                        : const SizedBox.shrink(),

                    // 2 — الريلز
                    _visited.contains(2)
                        ? MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (_) =>
                                    getIt<RealsCubit>()..emitreals(playerId: ''),
                              ),
                            ],
                            child: MainRealsScreen(
                              playerProfile: false,
                              playnowOrNot: index == 2,
                            ),
                          )
                        : const SizedBox.shrink(),

                    // 3 — المفضلة (نفس تبويب الكوتش، Scout token يدعمه)
                    _visited.contains(3)
                        ? BlocProvider(
                            create: (_) => getIt<FavoritesCubit>()..load(),
                            child: const FavoritesScreen(),
                          )
                        : const SizedBox.shrink(),

                    // 4 — الرتب
                    // ❌ مفيش BlocProvider هنا — بيجيه من فوق
                    _visited.contains(4)
                        ? const RankScreen()
                        : const SizedBox.shrink(),
                  ],
                );
              },
            ),

            // ── Bottom Nav ──────────────────────────────────────────────────
            PositionedDirectional(
              bottom: 0,
              start: 0,
              end: 0,
              child: ValueListenableBuilder<int>(
                valueListenable: _currentIndex,
                builder: (context, index, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _show,
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
                                  children: List.generate(5, (i) {
                                    final isSelected = index == i;
                                    return Expanded(
                                      child: InkWell(
                                        onTap: () => _currentIndex.value = i,
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
                                                  ? _activeIcons[i]
                                                  : _inactiveIcons[i],
                                            ),
                                            CenterTextUtils(
                                              fontSize: 9,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? mainColor
                                                  : mainColor.withOpacity(0.5),
                                              text: _titles[i],
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
    );
  }

  List<Widget> get _inactiveIcons => [
    SvgPicture.asset(
      'assets/svgs/home_unSelect.svg',
      color: mainColor.withOpacity(0.5),
    ),
    Icon(
      Icons.sports_soccer_outlined,
      color: mainColor.withOpacity(0.5),
      size: 24.h,
    ),
    SvgPicture.asset(
      'assets/svgs/reals_un_select.svg',
      color: mainColor.withOpacity(0.5),
    ),
    // المفضلة — نفس قلب الـ Lottie المستخدم في الكارت والبروفايل
    SvgPicture.asset(
      'assets/svgs/mingcute_heart-fill.svg',
      color: mainColor.withOpacity(0.5),
    ),
    SvgPicture.asset(
      'assets/svgs/rank_icon.svg',
      color: mainColor.withOpacity(0.5),
    ),
  ];

  List<Widget> get _activeIcons => [
    SvgPicture.asset('assets/svgs/home_select.svg'),
    Icon(Icons.sports_soccer, color: mainColor, size: 26.h),
    SvgPicture.asset('assets/svgs/reals_select.svg'),
    SvgPicture.asset('assets/svgs/mingcute_heart-fill.svg', color: mainColor),
    SvgPicture.asset('assets/svgs/rank_icon.svg', color: mainColor),
  ];

  List<String> get _titles => [
    'الرئيسية'.tr(),
    'التمارين'.tr(),
    'الريلز'.tr(),
    'المفضلة'.tr(),
    'الرتب'.tr(),
  ];
}
