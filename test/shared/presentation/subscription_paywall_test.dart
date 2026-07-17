import 'package:falconclubapp/feature/exercise/presentation/widgets/exercise_lock_prompt.dart';
import 'package:falconclubapp/feature/exercise/presentation/widgets/exercise_players_paywall.dart';
import 'package:falconclubapp/shared/presentation/widgets/subscription_paywall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// The three "subscribers only" surfaces used to be three copy-pasted cards.
/// They now share one [SubscriptionPaywall], and the locked-exercise prompt in
/// particular was rebuilt to reuse it instead of a hand-cut reconstruction.
/// These tests assert what is actually painted, so a future edit cannot quietly
/// let one of them drift back to a bespoke design.
Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: SingleChildScrollView(child: child)),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('SubscriptionPaywall renders its copy, checklist and CTA', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const SubscriptionPaywall(
        title: 'عنوان',
        message: 'رسالة',
        features: <String>['ميزة أولى', 'ميزة ثانية'],
      ),
    );

    expect(find.text('عنوان'), findsOneWidget);
    expect(find.text('رسالة'), findsOneWidget);
    expect(find.text('ميزة أولى'), findsOneWidget);
    expect(find.text('ميزة ثانية'), findsOneWidget);
    expect(find.text('اشترك الآن'), findsOneWidget);
    // The feature checklist uses check_circle icons — one per feature.
    expect(find.byIcon(Icons.check_circle), findsNWidgets(2));
  });

  testWidgets('ExercisePlayersPaywall is the full design, not a stub', (
    WidgetTester tester,
  ) async {
    await _pump(tester, const ExercisePlayersPaywall());

    expect(find.text('القائمة الكاملة مغلقة'), findsOneWidget);
    expect(find.byType(SubscriptionPaywall), findsOneWidget);
    // Its four benefit bullets — proof it kept the checklist.
    expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
    expect(find.text('اشترك الآن'), findsOneWidget);
  });

  // The reported #2: the locked-exercise prompt reconstructed a cut-down card
  // with no checklist. It must now open the real SubscriptionPaywall.
  testWidgets('the locked-exercise sheet opens the canonical paywall', (
    WidgetTester tester,
  ) async {
    // A modal sheet fills its own route; the paywall card is taller than the
    // default 800x600 test surface, so it reports a RenderFlex overflow under
    // the synthetic test font. It lays out fine on a device. This test asserts
    // what is *rendered*, so swallow overflow warnings (only those) for it.
    final void Function(FlutterErrorDetails)? previousOnError =
        FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await _pump(
      tester,
      Builder(
        builder: (BuildContext context) => ElevatedButton(
          onPressed: () =>
              showExerciseLockedSheet(context, title: 'تمرين السرعة'),
          child: const Text('open'),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(SubscriptionPaywall), findsOneWidget);
    expect(find.text('هذا التمرين مغلق'), findsOneWidget);
    // The exercise name is woven into the message.
    expect(find.textContaining('تمرين السرعة'), findsOneWidget);
    // And it has the checklist the old reconstruction lacked.
    expect(find.byIcon(Icons.check_circle), findsNWidgets(4));
    expect(find.text('اشترك الآن'), findsOneWidget);
  });
}
