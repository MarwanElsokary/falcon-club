import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/profile/domain/usecases/get_my_profile.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:falconclubapp/feature/profile/domain/profile_cache.dart';
import 'package:falconclubapp/feature/profile/presentation/widgets/profile_drawer_header.dart';
import 'package:falconclubapp/shared/domain/entities/profile.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetMyProfile extends Mock implements GetMyProfile {}

Profile _profile({required UserRole role, required Subscription subscription}) =>
    Profile(
      id: 'x',
      firstName: 'محمد',
      lastName: 'العنزي',
      role: role,
      positionName: 'مدرب',
      subscription: subscription,
    );

void main() {
  void ignoreOverflow() {
    final void Function(FlutterErrorDetails)? prev = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails d) {
      if (d.exceptionAsString().contains('overflowed')) return;
      prev?.call(d);
    };
    addTearDown(() => FlutterError.onError = prev);
  }

  Future<void> pump(
    WidgetTester tester, {
    required Profile profile,
    required bool showSubscriptionBadge,
  }) async {
    ignoreOverflow();
    final _MockGetMyProfile getMyProfile = _MockGetMyProfile();
    when(getMyProfile.call).thenAnswer(
      (_) async => Right<Failure, Profile>(profile),
    );
    final ProfileCubit cubit = ProfileCubit(getMyProfile, ProfileCache());
    await cubit.load();
    addTearDown(cubit.close);

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.black,
            body: BlocProvider<ProfileCubit>.value(
              value: cubit,
              child: ProfileDrawerHeader(
                onClose: () {},
                showSubscriptionBadge: showSubscriptionBadge,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('Club variant: greeting only, no subtitle, no badge', (
    tester,
  ) async {
    await pump(
      tester,
      profile: _profile(role: UserRole.club, subscription: Subscription.none),
      showSubscriptionBadge: false,
    );

    expect(tester.takeException(), isNull);
    expect(find.text('هلا محمد!'), findsOneWidget);
    // The position/subtitle line was dropped from the header display.
    expect(find.text('مدرب'), findsNothing);
    expect(find.byIcon(Icons.close), findsOneWidget);
    // No badge when the flag is off.
    expect(find.text('غير مشترك'), findsNothing);
    expect(find.byIcon(Icons.lock_outline), findsNothing);
  });

  testWidgets('Scout variant, not subscribed: shows the red "غير مشترك" badge', (
    tester,
  ) async {
    await pump(
      tester,
      profile: _profile(role: UserRole.scout, subscription: Subscription.none),
      showSubscriptionBadge: true,
    );

    expect(tester.takeException(), isNull);
    expect(find.text('هلا محمد!'), findsOneWidget);
    expect(find.text('غير مشترك'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets('Scout variant, subscribed: shows the green days badge', (
    tester,
  ) async {
    await pump(
      tester,
      profile: _profile(
        role: UserRole.scout,
        subscription: const Subscription(isPurchased: true, remainingDays: 30),
      ),
      showSubscriptionBadge: true,
    );

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    expect(find.textContaining('30'), findsOneWidget); // remaining days
  });
}
