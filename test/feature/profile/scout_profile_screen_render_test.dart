import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/profile/domain/usecases/get_my_profile.dart';
import 'package:falconclubapp/feature/profile/domain/usecases/update_my_profile.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:falconclubapp/feature/profile/domain/profile_cache.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_edit_cubit.dart';
import 'package:falconclubapp/feature/profile/presentation/screens/scout_profile_screen.dart';
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

class _MockUpdateMyProfile extends Mock implements UpdateMyProfile {}

/// A Scout profile that (defensively) even carries a clubName, so the test can
/// assert the Scout screen NEVER renders it — a Scout has no club.
const Profile _scout = Profile(
  id: 's1',
  firstName: 'سالم',
  lastName: 'الدوسري',
  role: UserRole.scout,
  phone: '0512345678',
  gender: Gender.male,
  clubName: 'نادي لا يجب أن يظهر',
);

void main() {
  late _MockGetMyProfile getMyProfile;
  late _MockUpdateMyProfile updateMyProfile;

  setUp(() {
    getMyProfile = _MockGetMyProfile();
    when(getMyProfile.call).thenAnswer(
      (_) async => const Right<Failure, Profile>(_scout),
    );
    updateMyProfile = _MockUpdateMyProfile();
  });

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

    final ProfileCubit profileCubit = ProfileCubit(getMyProfile, ProfileCache());
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
              BlocProvider<ProfileEditCubit>(
                create: (_) => ProfileEditCubit(updateMyProfile),
              ),
            ],
            child: const ScoutProfileScreen(),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('Scout profile renders name, contact, edit — and NO club', (
    WidgetTester tester,
  ) async {
    await pumpScreen(tester);

    expect(tester.takeException(), isNull);
    expect(find.byType(ScoutProfileScreen), findsOneWidget);
    expect(find.text('سالم الدوسري'), findsOneWidget); // full name
    expect(find.text('معلومات'), findsOneWidget); // section title
    expect(find.text('0512345678'), findsOneWidget); // phone
    expect(find.text('ذكر'), findsOneWidget); // gender
    expect(find.text('تعديل الملف الشخصي'), findsOneWidget); // edit tile
    // The club must never appear on a Scout profile.
    expect(find.text('نادي لا يجب أن يظهر'), findsNothing);
  });
}
