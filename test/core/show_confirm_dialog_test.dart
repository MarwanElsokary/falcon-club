import 'package:falconclubapp/core/thems/thems.dart';
import 'package:falconclubapp/core/widget/show_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// The shared yes/no confirmation. Replaces two bare Material AlertDialogs that
/// inherited nothing from the design system.
void main() {
  void ignoreRenderNoise() {
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final String text = details.exceptionAsString();
      // The Lottie asset is not loadable in the test bundle; FavIconClick has
      // its own errorBuilder for exactly this.
      if (text.contains('overflowed') || text.contains('Unable to load asset')) {
        return;
      }
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);
  }

  Future<void> openDialog(
    WidgetTester tester, {
    required VoidCallback onConfirm,
    bool isDestructive = false,
  }) async {
    ignoreRenderNoise();
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) => ElevatedButton(
                onPressed: () => showConfirmDialog(
                  context: context,
                  title: 'هل تريد حذف "أحمد" من الفريق؟',
                  isDestructive: isDestructive,
                  onConfirm: onConfirm,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pump();
    // Real frames, not one time-jump: the dialog route and the staggered
    // entrance need a couple of frames to initialise before the content is
    // hit-testable. A single large `pump(Duration)` builds one frame and skips
    // that, so taps then land on the modal barrier. This is independent of the
    // entrance duration.
    for (int i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// The confirm pill's own Container — the one carrying the fill colour.
  Color confirmFill(WidgetTester tester) {
    final Container container = tester.widget<Container>(
      find
          .ancestor(of: find.text('نعم'), matching: find.byType(Container))
          .first,
    );
    return (container.decoration! as BoxDecoration).color!;
  }

  testWidgets('renders the title and both actions', (WidgetTester tester) async {
    await openDialog(tester, onConfirm: () {});

    expect(find.text('هل تريد حذف "أحمد" من الفريق؟'), findsOneWidget);
    expect(find.text('نعم'), findsOneWidget);
    expect(find.text('لا'), findsOneWidget);
  });

  testWidgets('confirm dismisses the dialog and runs the callback', (
    WidgetTester tester,
  ) async {
    int confirmed = 0;
    await openDialog(tester, onConfirm: () => confirmed++);

    await tester.tap(find.text('نعم'));
    await tester.pumpAndSettle();

    expect(confirmed, 1);
    expect(find.text('نعم'), findsNothing); // dismissed
  });

  testWidgets('cancel dismisses without running the callback', (
    WidgetTester tester,
  ) async {
    int confirmed = 0;
    await openDialog(tester, onConfirm: () => confirmed++);

    await tester.tap(find.text('لا'));
    await tester.pumpAndSettle();

    expect(confirmed, 0);
    expect(find.text('لا'), findsNothing); // dismissed
  });

  testWidgets('destructive confirm is red; non-destructive is the primary', (
    WidgetTester tester,
  ) async {
    await openDialog(tester, onConfirm: () {}, isDestructive: true);
    expect(confirmFill(tester), redClr);
  });

  testWidgets('non-destructive confirm keeps the primary colour', (
    WidgetTester tester,
  ) async {
    await openDialog(tester, onConfirm: () {});
    expect(confirmFill(tester), mainColor);
  });
}
