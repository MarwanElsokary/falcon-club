import 'dart:async';

import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_exercises.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/exercise_list_cubit.dart';
import 'package:falconclubapp/feature/experiments/cubit/experiments_cubit.dart';
import 'package:falconclubapp/feature/experiments/data/repo/experiments_repo.dart';
import 'package:falconclubapp/feature/favorites/domain/favorites_sync.dart';
import 'package:falconclubapp/feature/favorites/domain/usecases/get_favorites.dart';
import 'package:falconclubapp/feature/favorites/domain/usecases/toggle_favorite.dart';
import 'package:falconclubapp/feature/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:falconclubapp/feature/main_screen/cubit/main_cubit.dart';
import 'package:falconclubapp/feature/main_screen/data/repo/main_repo.dart';
import 'package:falconclubapp/feature/rank/cubit/rank_cubit.dart';
import 'package:falconclubapp/feature/rank/data/repo/rank_repo.dart';
import 'package:falconclubapp/feature/reals/cubit/reals_cubit.dart';
import 'package:falconclubapp/feature/reals/data/repo/reals_repo.dart';
import 'package:falconclubapp/feature/scout/ui/screen/scout_main_screen.dart';
import 'package:falconclubapp/feature/training/cubit/training_cubit.dart';
import 'package:falconclubapp/feature/training/data/repo/training_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ── Mock constructor deps — the spies never touch them (fetches are no-ops) ──
class _MockExperimentsRepo extends Mock implements ExperimentsRepo {}

class _MockTrainingRepo extends Mock implements TrainingRepo {}

class _MockRealsRepo extends Mock implements RealsRepo {}

class _MockMainRepo extends Mock implements MainRepo {}

class _MockRankRepo extends Mock implements RankRepo {}

class _MockGetFavorites extends Mock implements GetFavorites {}

class _MockToggleFavorite extends Mock implements ToggleFavorite {}

class _MockGetExercises extends Mock implements GetExercises {}

class _MockFavoritesSync extends Mock implements FavoritesSync {}

// ── Spy cubits: count construction (via getIt factory) and no-op every fetch,
//    so pumping the shell never hits the network. ──
class _SpyExperimentsCubit extends ExperimentsCubit {
  _SpyExperimentsCubit() : super(_MockExperimentsRepo());
  @override
  void emitallTrials({required String categoryId}) {}
  @override
  void emitbestTrials({required String categoryId}) {}
}

class _SpyTrainingCubit extends TrainingCubit {
  _SpyTrainingCubit() : super(_MockTrainingRepo());
  @override
  void emitallExercises({required String categoryId, required bool popular}) {}
}

class _SpyMainCubit extends MainCubit {
  _SpyMainCubit() : super(_MockMainRepo());
  @override
  void emitMyProfile() {}
  @override
  void emitCategories() {}
}

class _SpyRankCubit extends RankCubit {
  _SpyRankCubit() : super(_MockRankRepo());
  @override
  void emitRank() {}
}

class _SpyRealsCubit extends RealsCubit {
  _SpyRealsCubit() : super(_MockRealsRepo());
  @override
  Future<void> emitreals({required String playerId, bool refresh = false}) async {}
}

class _SpyExerciseListCubit extends ExerciseListCubit {
  _SpyExerciseListCubit() : super(_MockGetExercises());
  @override
  Future<void> loadAll() async {}
}

class _SpyFavoritesCubit extends FavoritesCubit {
  _SpyFavoritesCubit(FavoritesSync sync)
    : super(_MockGetFavorites(), _MockToggleFavorite(), sync);
  @override
  Future<void> load() async {}
}

void main() {
  final Map<String, int> constructed = <String, int>{};

  void countReset() => constructed.clear();
  int count(String key) => constructed[key] ?? 0;
  void bump(String key) => constructed[key] = (constructed[key] ?? 0) + 1;

  setUp(() {
    countReset();
    getIt.reset();

    getIt.registerFactory<ExperimentsCubit>(() {
      bump('experiments');
      return _SpyExperimentsCubit();
    });
    getIt.registerFactory<MainCubit>(() {
      bump('main');
      return _SpyMainCubit();
    });
    getIt.registerFactory<TrainingCubit>(() {
      bump('training');
      return _SpyTrainingCubit();
    });
    getIt.registerFactory<RankCubit>(() {
      bump('rank');
      return _SpyRankCubit();
    });
    getIt.registerFactory<RealsCubit>(() {
      bump('reals');
      return _SpyRealsCubit();
    });
    getIt.registerFactory<ExerciseListCubit>(() {
      bump('exerciseList');
      return _SpyExerciseListCubit();
    });
    getIt.registerFactory<FavoritesCubit>(() {
      bump('favorites');
      final FavoritesSync sync = _MockFavoritesSync();
      when(() => sync.changes).thenAnswer((_) => const Stream<String>.empty());
      return _SpyFavoritesCubit(sync);
    });
  });

  tearDown(() => getIt.reset());

  void ignoreRenderNoise() {
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final String text = details.exceptionAsString();
      if (text.contains('overflowed') || text.contains('MissingPluginException')) {
        return;
      }
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);
  }

  Future<void> pumpShell(WidgetTester tester) async {
    ignoreRenderNoise();
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => const MaterialApp(home: ScoutMainScreen()),
      ),
    );
    await tester.pump();
    // Let the bottom-nav SlideAnimation (2500ms) fully settle so its tap-rect
    // sits in its final on-screen position.
    await tester.pump(const Duration(seconds: 3));
  }

  testWidgets('deferred tabs (reals/favorites/exercise) do not construct their '
      'cubits at shell startup', (WidgetTester tester) async {
    await pumpShell(tester);

    // Home tab (index 0) built eagerly — its cubits are up.
    expect(count('main'), greaterThanOrEqualTo(1), reason: 'home MainCubit');
    // The shell-level RankCubit is built (it also feeds the home top-3 widget).
    expect(count('rank'), greaterThanOrEqualTo(1), reason: 'shell RankCubit');

    // The lazy tabs must NOT have been constructed yet.
    expect(count('reals'), 0, reason: 'reels tab is deferred');
    expect(count('favorites'), 0, reason: 'favorites tab is deferred');
    expect(count('exerciseList'), 0, reason: 'exercise tab is deferred');
  });

  testWidgets('the reels cubit is constructed only after its tab is opened', (
    WidgetTester tester,
  ) async {
    await pumpShell(tester);
    expect(count('reals'), 0);

    // Open the reels tab (title الريلز → index 2). Invoke the nav item's
    // onTap directly — robust against the animated nav's hit-test geometry.
    final InkWell realsItem = tester.widget<InkWell>(
      find.widgetWithText(InkWell, 'الريلز'),
    );
    realsItem.onTap!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      count('reals'),
      1,
      reason: 'visiting the reels tab builds its cubit exactly once',
    );
    // Tabs still unvisited stay un-constructed.
    expect(count('favorites'), 0);
    expect(count('exerciseList'), 0);
  });
}
