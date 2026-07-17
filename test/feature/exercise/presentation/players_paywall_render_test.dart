import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/exercise/data/models/exercise_details_model.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_details.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/viewer_capability_port.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_exercise_details.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/exercise_details_cubit.dart';
import 'package:falconclubapp/feature/exercise/presentation/screens/exercise_details_screen.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:falconclubapp/shared/domain/subscription_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetExerciseDetails extends Mock implements GetExerciseDetails {}

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
/// profile says `isSubscribed: false`. The backend truncates it to three. Parsed
/// through the real [ExerciseDetailsModel] so the test exercises the same wire
/// shape the screen sees in production.
ExerciseDetails _details({required List<dynamic> players}) =>
    ExerciseDetailsModel.fromJson(<String, dynamic>{
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
        'players': players,
      },
    });

final List<dynamic> _fullRoster = <dynamic>[
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
];

/// Does the subscribe widget ACTUALLY render on the merged details screen?
///
/// Phase 8a: the screen now runs on one [ExerciseDetailsCubit] over
/// [GetExerciseDetails] — details and roster come from a single fetch. The
/// paywall is still decided by the [ExerciseCapability] injected at the route,
/// so the same five cases (unsubscribed / expired / subscribed / empty roster /
/// coach) are asserted against the same widget, unchanged.
void main() {
  const String paywallHeadline = 'القائمة الكاملة مغلقة';
  const String exerciseId = '9';

  late _MockGetExerciseDetails getExerciseDetails;

  setUp(() async {
    getExerciseDetails = _MockGetExerciseDetails();
    when(() => getExerciseDetails(any())).thenAnswer(
      (_) async => Right<Failure, ExerciseDetails>(
        _details(players: _fullRoster),
      ),
    );
    await GetIt.instance.reset();
  });

  tearDown(() => GetIt.instance.reset());

  /// Registers the entitlement the whole app reads. The `capability` is what the
  /// screen is driven by.
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
  /// These tests assert what is *rendered*, not how it is laid out.
  void ignoreOverflowWarnings() {
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);
  }

  /// Pumps the REAL `ExerciseDetailsScreen` with [capability] injected, its one
  /// cubit already loaded.
  Future<void> pumpScreen(
    WidgetTester tester,
    ExerciseCapability capability,
  ) async {
    ignoreOverflowWarnings();
    final ExerciseDetailsCubit cubit = ExerciseDetailsCubit(getExerciseDetails);
    await cubit.load(exerciseId);

    // The default 800x600 test surface is narrower than the design and the
    // player row overflows it. Pump at the real device size.
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: BlocProvider<ExerciseDetailsCubit>.value(
            value: cubit,
            child: ExerciseDetailsScreen(capability: capability),
          ),
        ),
      ),
    );

    // Explicit pumps, not pumpAndSettle: the screen's image placeholders are
    // `Skeletonizer(enabled: true)` shimmers, which animate forever.
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

  testWidgets('an unsubscribed scout with an EMPTY roster still gets prompted', (
    WidgetTester tester,
  ) async {
    signedInAs(Subscription.none);
    when(() => getExerciseDetails(any())).thenAnswer(
      (_) async =>
          Right<Failure, ExerciseDetails>(_details(players: <dynamic>[])),
    );

    await pumpScreen(tester, ScoutCapability(Subscription.none));

    expect(find.text(paywallHeadline), findsOneWidget);
    expect(find.text('لا يوجد لاعبون بعد'), findsNothing);
  });

  testWidgets('a Club coach here is never paywalled', (
    WidgetTester tester,
  ) async {
    signedInAs(Subscription.none);

    await pumpScreen(tester, const CoachCapability());

    expect(find.text(paywallHeadline), findsNothing);
  });
}
