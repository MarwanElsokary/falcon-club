import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/get_terms_and_policies.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/registration_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/registration_state.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/terms_cubit.dart';
import 'package:falconclubapp/feature/auth/presentation/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRegistrationCubit extends MockCubit<RegistrationState>
    implements RegistrationCubit {}

class _MockGetTermsAndPolicies extends Mock implements GetTermsAndPolicies {}

/// Proves the consent gate actually blocks registration.
///
/// The original screens hard-blocked submission on `_agreedToTerms`
/// (`club_sign_up_screen.dart:581`). That gate was lost when the two forked
/// signup screens were unified into one, so accounts could be created without
/// accepting the terms — a compliance gap, not a styling one.
///
/// A unit test cannot catch this: the gate lives in the widget, between the form
/// and the cubit. So this pumps the real screen and asserts the cubit is never
/// called while the box is unticked.
void main() {
  late _MockRegistrationCubit registrationCubit;
  late TermsCubit termsCubit;

  // RegistrationInput is `final` and cannot be faked — the sealing is
  // deliberate. Register a real instance instead.
  setUpAll(
    () => registerFallbackValue(
      const RegistrationInput(
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        password: '',
        gender: null,
      ),
    ),
  );

  setUp(() {
    registrationCubit = _MockRegistrationCubit();
    when(() => registrationCubit.state).thenReturn(const RegistrationIdle());
    when(() => registrationCubit.submit(any())).thenAnswer((_) async {});

    final _MockGetTermsAndPolicies getTerms = _MockGetTermsAndPolicies();
    termsCubit = TermsCubit(getTerms);
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp(
          home: MultiBlocProvider(
            providers: <BlocProvider<dynamic>>[
              BlocProvider<RegistrationCubit>.value(value: registrationCubit),
              BlocProvider<TermsCubit>.value(value: termsCubit),
            ],
            child: const RegistrationScreen(
              title: 'تسجيل كشاف',
              requiresClub: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('the consent checkbox is rendered and starts unticked', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    final Finder checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);
  });

  // THE regression test for the compliance gap.
  testWidgets('registration is BLOCKED while the terms are unaccepted', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    // Tap submit without ticking the box.
    await tester.tap(find.text('إنشاء حساب'));
    await tester.pump();

    verifyNever(() => registrationCubit.submit(any()));
  });

  testWidgets('ticking the box records consent', (WidgetTester tester) async {
    await pumpScreen(tester);

    // The checkbox sits below the fold on a test-sized viewport.
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });
}
