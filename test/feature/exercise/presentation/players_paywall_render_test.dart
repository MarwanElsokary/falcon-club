import 'package:falconclubapp/feature/training_details/cubit/training_details_cubit.dart';
import 'package:falconclubapp/feature/training_details/data/model/exercise_details_model.dart';
import 'package:falconclubapp/feature/training_details/data/repo/training_details_repo.dart';
import 'package:falconclubapp/feature/training_details/ui/screen/exercise_details_screen.dart';
import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/viewer_capability_port.dart';
import 'package:falconclubapp/feature/experiance_details_screen/cubit/experiance_details_cubit.dart';
import 'package:falconclubapp/feature/experiance_details_screen/data/model/exerciseWithPlayersModel.dart';
import 'package:falconclubapp/feature/experiance_details_screen/data/repo/experiance_details_repo.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:falconclubapp/shared/domain/subscription_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class _MockExperianceRepo extends Mock implements ExperianceDetailsRepo {}

class _MockTrainingDetailsRepo extends Mock implements TrainingDetailsRepo {}

class _StubReader implements SubscriptionReader {
  const _StubReader(this._subscription);
  final Subscription _subscription;

  @override
  Subscription current() => _subscription;
}

class _StubCapability implements ViewerCapabilityPort {
  const _StubCapability(this._capability);
  final ExerciseCapability _capability;

  @override
  ExerciseCapability current() => _capability;
}

/// The live `GET /api/Club/GetExercise` roster, fetched with a Scout token whose
/// profile says `isSubscribed: false`. The backend truncates it to three.
ExerciseDetailsWithPlayersModel _roster() =>
    ExerciseDetailsWithPlayersModel.fromJson(<String, dynamic>{
      'message': 'Success',
      'data': <String, dynamic>{
        'id': 9,
        'photoPath': null,
        'title': 'تمرين المرونة  (يسار)',
        'description': 'x',
        'skills': <dynamic>[],
        'equipments': <dynamic>[],
        'playerInstructions': <dynamic>[],
        'videos': <dynamic>[],
        'players': <dynamic>[
          <String, dynamic>{
            'id': '005d572f',
            'photo': null,
            'age': 0,
            'name': 'عبدالله شداد الرشيدي',
            'position': null,
            'attemptCount': 2,
          },
          <String, dynamic>{
            'id': '3358a0b4',
            'photo': null,
            'age': 0,
            'name': 'جمال رائد نجدي',
            'position': null,
            'attemptCount': 1,
          },
        ],
      },
    });

/// Does the subscribe widget ACTUALLY render on the merged details screen?
///
/// The logic looked right and the bug was reported anyway, so this pumps the real
/// `ExerciseDetailsScreen` with the real cubits and asserts on what is painted —
/// rather than asserting that a boolean is false somewhere and hoping.
///
/// One screen now serves every role: what it offers is decided by the
/// `ExerciseCapability` injected at the route, not by which screen was opened.
/// So the paywall cases (unsubscribed / expired / subscribed / empty roster) and
/// the coach case are all exercised against the SAME widget — the fork that used
/// to make "the Scout screen" and "the Club screen" behave differently is gone.
void main() {
  const String paywallHeadline = 'القائمة الكاملة مغلقة';
  const String exerciseId = '9';

  late _MockExperianceRepo experianceRepo;
  late _MockTrainingDetailsRepo trainingRepo;

  setUp(() async {
    experianceRepo = _MockExperianceRepo();
    trainingRepo = _MockTrainingDetailsRepo();

    when(
      () =>
          experianceRepo.exercisePlayers(exerciseId: any(named: 'exerciseId')),
    ).thenAnswer((_) async => ApiResult.success(_roster()));

    when(
      () => trainingRepo.exerciseDetails(exerciseId: any(named: 'exerciseId')),
    ).thenAnswer(
      (_) async => ApiResult.success(
        ExerciseDetailsModel.fromJson(<String, dynamic>{
          'message': 'Success',
          'data': <String, dynamic>{
            'id': 9,
            'title': 'تمرين المرونة  (يسار)',
            'description': 'x',
            'skills': <dynamic>[],
            'equipments': <dynamic>[],
            'playerInstructions': <dynamic>[],
            'videos': <dynamic>[],
          },
        }),
      ),
    );

    await GetIt.instance.reset();
  });

  tearDown(() => GetIt.instance.reset());

  /// Registers the entitlement the whole app reads. The `capability` is what the
  /// screen is driven by; the reader is what `ExperianceDetailsCubit` consults.
  void signedInAs(Subscription subscription) {
    GetIt.instance.registerSingleton<SubscriptionReader>(
      _StubReader(subscription),
    );
    GetIt.instance.registerSingleton<ViewerCapabilityPort>(
      _StubCapability(ScoutCapability(subscription)),
    );
  }

  /// Swallows RenderFlex overflow reports for the duration of a test.
  ///
  /// The player row's "المحاولات: N" line can overflow by a few px under the
  /// test's synthetic font, whose Arabic glyph metrics are nothing like Cairo's.
  /// These tests assert what is *rendered*, not how it is laid out, so a layout
  /// warning must not mask the result — but nothing else is suppressed.
  void ignoreOverflowWarnings() {
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);
  }

  /// Pumps the REAL `ExerciseDetailsScreen` with [capability] injected — the one
  /// screen the trials flow, the exercise list, and the Home slider all open.
  Future<void> pumpScreen(
    WidgetTester tester,
    ExerciseCapability capability,
  ) async {
    ignoreOverflowWarnings();
    final ExperianceDetailsCubit players = ExperianceDetailsCubit(
      experianceRepo,
    );
    final TrainingDetailsCubit details = TrainingDetailsCubit(trainingRepo);

    details.emitexerciseDetails(exerciseId: exerciseId);
    await players.fetchExercisePlayers(exerciseId: exerciseId);

    // The default 800x600 test surface is narrower than the design and the
    // player row overflows it. Pump at the real device size.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<ExperianceDetailsCubit>.value(value: players),
              BlocProvider<TrainingDetailsCubit>.value(value: details),
            ],
            child: ExerciseDetailsScreen(capability: capability),
          ),
        ),
      ),
    );

    // Explicit pumps, not pumpAndSettle: the screen's image placeholders are
    // `Skeletonizer(enabled: true)` shimmers, which animate forever, so
    // pumpAndSettle never settles and times out.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('an UNSUBSCRIBED scout sees the subscribe widget', (
    WidgetTester tester,
  ) async {
    signedInAs(Subscription.none);

    await pumpScreen(tester, ScoutCapability(Subscription.none));

    expect(find.text(paywallHeadline), findsOneWidget);
  });

  testWidgets('an EXPIRED scout sees it too', (WidgetTester tester) async {
    const Subscription expired = Subscription(
      isPurchased: true,
      remainingDays: 0,
    );
    signedInAs(expired);

    await pumpScreen(tester, const ScoutCapability(expired));

    expect(find.text(paywallHeadline), findsOneWidget);
  });

  testWidgets('a SUBSCRIBED scout does not', (WidgetTester tester) async {
    const Subscription active = Subscription(
      isPurchased: true,
      remainingDays: 30,
    );
    signedInAs(active);

    await pumpScreen(tester, const ScoutCapability(active));

    expect(find.text(paywallHeadline), findsNothing);
  });

  // An empty roster used to swallow the paywall entirely: the players section
  // returned the "no players yet" card before ever reaching the paywall branch.
  // To a paywalled viewer an empty roster is indistinguishable from a hidden
  // one, so that card was asserting something the client cannot know.
  testWidgets('an unsubscribed scout with an EMPTY roster still gets prompted', (
    WidgetTester tester,
  ) async {
    signedInAs(Subscription.none);
    when(
      () => experianceRepo.exercisePlayers(exerciseId: any(named: 'exerciseId')),
    ).thenAnswer(
      (_) async => ApiResult.success(
        ExerciseDetailsWithPlayersModel.fromJson(<String, dynamic>{
          'message': 'Success',
          'data': <String, dynamic>{'id': 9, 'players': <dynamic>[]},
        }),
      ),
    );

    await pumpScreen(tester, ScoutCapability(Subscription.none));

    expect(find.text(paywallHeadline), findsOneWidget);
    expect(find.text('لا يوجد لاعبون بعد'), findsNothing);
  });

  // The reported bug: the paywall lived only inside the Scout players section,
  // but a Scout reaches this screen from Home → trials for every role. Now there
  // is one screen driven by the injected capability, a coach here is never
  // paywalled even when their subscription is none.
  testWidgets('a Club coach here is never paywalled', (
    WidgetTester tester,
  ) async {
    signedInAs(Subscription.none);

    await pumpScreen(tester, const CoachCapability());

    expect(find.text(paywallHeadline), findsNothing);
  });
}
