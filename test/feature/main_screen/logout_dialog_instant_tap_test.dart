import 'package:falconclubapp/core/di/dependency_injection.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/log_out.dart';
import 'package:falconclubapp/feature/main_screen/ui/widget/log_out_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockLogOut extends Mock implements LogOut {}

/// The logout confirm shares `SlideEnimationWidget` and its entrance timing
/// with the shared delete dialog. These assert that both actions work when
/// tapped promptly after the dialog opens, and that cancel never signs the
/// user out — the shipped flow had no test at all before.
void main() {
  late _MockLogOut logOut;

  setUp(() async {
    // Must be awaited — GetIt.reset() is async, and an unawaited reset lands
    // *after* the registrations below and silently wipes them.
    await getIt.reset();
    logOut = _MockLogOut();
    when(() => logOut()).thenAnswer(
      (_) async => const Right<Failure, void>(null),
    );
    getIt.registerFactory<LogOut>(() => logOut);
  });

  tearDown(() => getIt.reset());

  void ignoreRenderNoise() {
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      final String text = details.exceptionAsString();
      if (text.contains('overflowed') || text.contains('Unable to load asset')) {
        return;
      }
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);
  }

  Future<void> openLogout(
    WidgetTester tester, {
    required VoidCallback onLogout,
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
                onPressed: () => showLogoutDialog(
                  context,
                  onLogout,
                  'هل تريد تسجيل الخروج؟',
                  'assets/lottie/Log out.json',
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
    // Real frames, not one time-jump — see show_confirm_dialog_test.
    for (int i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('confirm responds to a tap right after the dialog appears', (
    WidgetTester tester,
  ) async {
    int loggedOut = 0;
    await openLogout(tester, onLogout: () => loggedOut++);

    await tester.tap(find.text('نعم'));
    await tester.pumpAndSettle();

    verify(() => logOut()).called(1);
    expect(loggedOut, 1);
  });

  testWidgets('cancel responds to a tap right after the dialog appears', (
    WidgetTester tester,
  ) async {
    int loggedOut = 0;
    await openLogout(tester, onLogout: () => loggedOut++);

    await tester.tap(find.text('لا '));
    await tester.pumpAndSettle();

    verifyNever(() => logOut());
    expect(loggedOut, 0);
    expect(find.text('نعم'), findsNothing); // dismissed
  });
}
