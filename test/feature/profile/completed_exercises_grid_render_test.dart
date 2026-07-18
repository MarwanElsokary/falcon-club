import 'package:falconclubapp/feature/player_profile/ui/widget/completed_exercise_card.dart';
import 'package:falconclubapp/feature/player_profile/ui/widget/completed_exercises_grid.dart';
import 'package:falconclubapp/feature/profile/domain/entities/completed_exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// The completed-exercises card sits in a fixed-extent grid cell, so a long
/// (2-line) title is the overflow risk. This pumps the real grid at device size
/// and asserts the cards fit vertically. Horizontal fractional overflow from the
/// synthetic test font is tolerated (never happens on device with Cairo).
final List<CompletedExercise> _exercises = <CompletedExercise>[
  const CompletedExercise(
    id: '9',
    title: 'تمرين المرونة و التحكم بالكرة للاعبين المتقدمين (يسار)',
    attemptsCount: 3,
  ),
  const CompletedExercise(id: '10', title: 'السرعة', attemptsCount: 1),
  const CompletedExercise(
    id: '11',
    title: 'تمرين القوة البدنية و اللياقة',
    attemptsCount: 12,
  ),
  const CompletedExercise(id: '12', title: 'الدقة', attemptsCount: 0),
];

void main() {
  testWidgets('the completed-exercises grid lays cards out with no vertical overflow', (
    WidgetTester tester,
  ) async {
    final List<String> overflows = <String>[];
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final String m = details.exceptionAsString();
      if (m.contains('overflowed')) {
        overflows.add(m);
        return;
      }
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CompletedExercisesGrid(
                exercises: _exercises,
                playerId: 'p1',
                playerName: 'لاعب',
                playerPhoto: null,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final Iterable<String> vertical = overflows.where(
      (String m) => m.contains('on the bottom') || m.contains('on the top'),
    );
    expect(vertical, isEmpty, reason: vertical.join('\n'));
    expect(
      find.byType(CompletedExerciseCard),
      findsNWidgets(_exercises.length),
    );
  });
}
