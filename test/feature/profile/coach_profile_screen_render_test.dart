import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_cubit.dart';
import 'package:falconclubapp/feature/club_team/cubit/club_team_state.dart';
import 'package:falconclubapp/feature/profile/domain/usecases/get_my_profile.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:falconclubapp/feature/profile/presentation/screens/coach_profile_screen.dart';
import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:falconclubapp/shared/domain/entities/profile.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetMyProfile extends Mock implements GetMyProfile {}

class _MockClubTeamCubit extends MockCubit<ClubTeamState>
    implements ClubTeamCubit {}

/// A Coach profile with a distinct club name (so it is findable apart from the
/// coach's own name) and the contact facts populated. Guards that the whole
/// screen lays out and scrolls under the unbounded `SingleChildScrollView` — the
/// context that threw `RenderBox was not laid out / hasSize` on device.
const Profile _coach = Profile(
  id: 'c1',
  firstName: 'محمد',
  lastName: 'العنزي',
  role: UserRole.club,
  phone: '0501234567',
  gender: Gender.male,
  clubName: 'نادي الصقور',
);

void main() {
  late _MockGetMyProfile getMyProfile;
  late _MockClubTeamCubit clubTeamCubit;

  setUp(() {
    getMyProfile = _MockGetMyProfile();
    when(getMyProfile.call).thenAnswer(
      (_) async => const Right<Failure, Profile>(_coach),
    );

    clubTeamCubit = _MockClubTeamCubit();
    whenListen(
      clubTeamCubit,
      const Stream<ClubTeamState>.empty(),
      initialState: const ClubTeamState.initial(),
    );
  });

  /// Swallows only RenderFlex *overflow* reports — the synthetic test font's
  /// Arabic metrics differ from Cairo's and a label can overflow a cell by a few
  /// px. A real layout assertion (`hasSize`) is NOT swallowed, so the render bug
  /// this test guards against still fails it.
  void ignoreOverflowWarnings() {
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      previous?.call(details);
    };
    addTearDown(() => FlutterError.onError = previous);
  }

  Future<void> pumpScreen(WidgetTester tester) async {
    ignoreOverflowWarnings();

    final ProfileCubit profileCubit = ProfileCubit(getMyProfile);
    await profileCubit.load();

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: profileCubit),
              BlocProvider<ClubTeamCubit>.value(value: clubTeamCubit),
            ],
            child: const CoachProfileScreen(),
          ),
        ),
      ),
    );

    // Explicit pumps, not pumpAndSettle: the photo placeholder is a
    // `Skeletonizer(enabled: true)` shimmer, which animates forever.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('Coach profile renders its content without a layout assertion', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    // If the `hasSize` assertion fired during layout, pumpWidget would have
    // captured the exception and these would never be reached / takeException
    // would fail the test.
    expect(tester.takeException(), isNull);
    expect(find.byType(CoachProfileScreen), findsOneWidget);
    expect(find.text('محمد العنزي'), findsOneWidget); // full name
    expect(find.text('نادي الصقور'), findsOneWidget); // club, under the name
    expect(find.text('معلومات'), findsOneWidget); // section title
    expect(find.text('0501234567'), findsOneWidget); // phone row
    expect(find.text('ذكر'), findsOneWidget); // gender row (Arabic label)
    expect(find.text('تعديل الملف الشخصي'), findsOneWidget); // edit tile
  });

  testWidgets('Coach profile content scrolls', (WidgetTester tester) async {
    await pumpScreen(tester);

    final Finder scrollView = find.byType(SingleChildScrollView);
    expect(scrollView, findsOneWidget);

    await tester.drag(scrollView, const Offset(0, -200));
    await tester.pump();

    // A successful drag with no thrown exception proves the viewport was laid
    // out with a bounded height (the failure mode left it size: MISSING).
    expect(tester.takeException(), isNull);
    expect(find.byType(CoachProfileScreen), findsOneWidget);
  });
}
