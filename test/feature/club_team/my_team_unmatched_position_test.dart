import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_exercises_cubit.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_state.dart';
import 'package:falconclubapp/feature/club_team/data/model/club_player_model.dart';
import 'package:falconclubapp/feature/club_team/data/repo/club_exercises_repo.dart';
import 'package:falconclubapp/feature/club_team/data/repo/club_team_repo.dart';
import 'package:falconclubapp/feature/club_team/ui/screen/club_my_team_screen.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/viewer_capability_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockClubTeamRepo extends Mock implements ClubTeamRepo {}

class _MockClubExercisesRepo extends Mock implements ClubExercisesRepo {}

class _FakeCapabilityPort implements ViewerCapabilityPort {
  @override
  ExerciseCapability current() => const CoachCapability();
}

/// Lets the test seed the roster the way the cubit does — `groupedPlayers` is
/// the authoritative public field the screen reads directly.
class _FakeClubTeamCubit extends ClubTeamCubit {
  _FakeClubTeamCubit() : super(_MockClubTeamRepo());

  void seed(Map<String, List<ClubPlayer>> grouped) {
    groupedPlayers = grouped;
    emit(ClubTeamState.clubPlayerssuccess(Map<String, List<ClubPlayer>>.from(grouped)));
  }
}

ClubPlayer _player({required String id, required String name, required String position}) =>
    ClubPlayer(
      id: id,
      accountNumber: 'A$id',
      name: name,
      age: 17,
      gender: 'ذكر',
      position: position,
      direction: 0,
      foot: 'يمين',
      tps: 8.5,
    );

void main() {
  setUp(() {
    getIt.reset();
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

  Future<void> pumpRoster(
    WidgetTester tester,
    Map<String, List<ClubPlayer>> grouped,
  ) async {
    ignoreRenderNoise();
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final _FakeClubTeamCubit cubit = _FakeClubTeamCubit()..seed(grouped);
    addTearDown(cubit.close);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: BlocProvider<ClubTeamCubit>.value(
            value: cubit,
            child: const ClubMyTeamScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  const String emptyState = 'لا يوجد لاعبون في هذا النادي';

  testWidgets(
    'players bucketed into أخرى (unmatched/absent position) still render',
    (WidgetTester tester) async {
      // `_getSectionKey` returns 'أخرى' for any position it does not recognise,
      // and the API's `withoutPosition` list lands here too. This bucket used to
      // be filtered out entirely, so a squad like this rendered as "no players".
      await pumpRoster(tester, <String, List<ClubPlayer>>{
        'أخرى': <ClubPlayer>[
          _player(id: '1', name: 'سالم الدوسري', position: ''),
        ],
      });

      expect(find.text('سالم الدوسري'), findsOneWidget);
      expect(find.text(emptyState), findsNothing);
    },
  );

  testWidgets('canonical sections still render (no regression)', (
    WidgetTester tester,
  ) async {
    await pumpRoster(tester, <String, List<ClubPlayer>>{
      'الهجوم': <ClubPlayer>[
        _player(id: '2', name: 'مهاجم أول', position: 'مهاجم'),
      ],
    });

    expect(find.text('مهاجم أول'), findsOneWidget);
    expect(find.text(emptyState), findsNothing);
  });

  testWidgets('canonical and leftover sections render together', (
    WidgetTester tester,
  ) async {
    await pumpRoster(tester, <String, List<ClubPlayer>>{
      'الحارس': <ClubPlayer>[
        _player(id: '3', name: 'حارس المرمى', position: 'حارس'),
      ],
      'أخرى': <ClubPlayer>[
        _player(id: '4', name: 'بدون مركز', position: ''),
      ],
    });

    expect(find.text('حارس المرمى'), findsOneWidget);
    expect(find.text('بدون مركز'), findsOneWidget);
  });

  testWidgets('a genuinely empty roster still shows the empty state', (
    WidgetTester tester,
  ) async {
    await pumpRoster(tester, <String, List<ClubPlayer>>{});

    expect(find.text(emptyState), findsOneWidget);
  });
}
