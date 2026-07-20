import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_exercises_cubit.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_state.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:falconclubapp/feature/club_team/data/repo/club_exercises_repo.dart';
import 'package:falconclubapp/feature/club_team/data/repo/club_team_repo.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/viewer_capability_port.dart';
import 'package:falconclubapp/feature/main_club/ui/screens/ClubMyTeamScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockClubTeamRepo extends Mock implements ClubTeamRepo {}

class _MockClubExercisesRepo extends Mock implements ClubExercisesRepo {}

class _FakeCapabilityPort implements ViewerCapabilityPort {
  @override
  ExerciseCapability current() => const MainClubCapability();
}

class _FakeClubTeamCubit extends ClubTeamCubit {
  _FakeClubTeamCubit() : super(_MockClubTeamRepo());

  void seed(Map<String, List<ClubPlayer>> grouped) {
    groupedPlayers = grouped;
    emit(
      ClubTeamState.clubPlayerssuccess(
        Map<String, List<ClubPlayer>>.from(grouped),
      ),
    );
  }

  // The screen calls this when the coaches tab opens; the real one would hit
  // the network.
  @override
  Future<void> fetchClubTrainees() async {}
}

ClubPlayer _player({required String id, required String name}) => ClubPlayer(
  id: id,
  accountNumber: 'A$id',
  name: name,
  age: 17,
  gender: 'ذكر',
  position: 'مهاجم',
  direction: 0,
  foot: 'يمين',
  tps: 8.5,
);

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<ClubExercisesCubit>(
      () => ClubExercisesCubit(_MockClubExercisesRepo()),
    );
    getIt.registerLazySingleton<ViewerCapabilityPort>(_FakeCapabilityPort.new);
  });

  tearDown(() => getIt.reset());

  void ignoreRenderNoise() {
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final String text = details.exceptionAsString();
      if (text.contains('overflowed') ||
          text.contains('Unable to load asset') ||
          text.contains('MissingPluginException')) {
        return;
      }
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);
  }

  Future<_FakeClubTeamCubit> pumpTeam(WidgetTester tester) async {
    ignoreRenderNoise();
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final _FakeClubTeamCubit cubit = _FakeClubTeamCubit()
      ..seed(<String, List<ClubPlayer>>{
        'الهجوم': <ClubPlayer>[_player(id: '1', name: 'مهاجم أول')],
      });
    addTearDown(cubit.close);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: BlocProvider<ClubTeamCubit>.value(
            value: cubit,
            child: const ClubMainMyTeamScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    return cubit;
  }

  // The players list is the tab signal: it renders on tab 0 and not on tab 1.
  // The coaches body is deliberately not asserted on — with no trainees fetched
  // it sits in its skeleton state, which says nothing about which tab is up.
  const String playerName = 'مهاجم أول';

  testWidgets('opens on the players tab', (WidgetTester tester) async {
    await pumpTeam(tester);

    expect(find.text(playerName), findsOneWidget);
  });

  testWidgets('a requested players tab wins over the tab last left behind', (
    WidgetTester tester,
  ) async {
    // The regression this guards: the screen stays mounted, so it remembers the
    // coaches tab. Home then asks for the players tab by writing 0 — the value
    // the notifier already held before the user ever switched. If the screen
    // does not mirror manual switches back onto the notifier, that write
    // publishes nothing and the user lands on coaches.
    final _FakeClubTeamCubit cubit = await pumpTeam(tester);

    await tester.tap(find.text('المدربين'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text(playerName), findsNothing);

    cubit.requestedTeamTab.value = 0;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(playerName), findsOneWidget);
  });

  testWidgets('switching tabs by hand keeps the notifier in step', (
    WidgetTester tester,
  ) async {
    final _FakeClubTeamCubit cubit = await pumpTeam(tester);
    expect(cubit.requestedTeamTab.value, 0);

    await tester.tap(find.text('المدربين'));
    await tester.pump();

    expect(cubit.requestedTeamTab.value, 1);
  });

  testWidgets('a requested coaches tab opens the coaches list', (
    WidgetTester tester,
  ) async {
    final _FakeClubTeamCubit cubit = await pumpTeam(tester);
    expect(find.text(playerName), findsOneWidget);

    cubit.requestedTeamTab.value = 1;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(playerName), findsNothing);
  });

  testWidgets('each tile keeps landing on its own tab, switch after switch', (
    WidgetTester tester,
  ) async {
    // The coaches tile used to share the players tile's handler, so it reset to
    // tab 0 and opened the players list. Alternating several times also covers
    // the stale-notifier case in both directions, not just from a fresh mount.
    final _FakeClubTeamCubit cubit = await pumpTeam(tester);

    for (int round = 0; round < 3; round++) {
      // Coaches tile.
      cubit.requestedTeamTab.value = 1;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.text(playerName),
        findsNothing,
        reason: 'coaches tile, round $round',
      );

      // Players tile.
      cubit.requestedTeamTab.value = 0;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.text(playerName),
        findsOneWidget,
        reason: 'players tile, round $round',
      );

      // And again with a manual switch in between, which is what made the
      // notifier stale in the original bug.
      await tester.tap(find.text('المدربين'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.text(playerName),
        findsNothing,
        reason: 'manual switch, round $round',
      );
    }
  });
}
