import 'package:falconclubapp/feature/profile/domain/usecases/update_my_profile.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_edit_cubit.dart';
import 'package:falconclubapp/feature/profile/presentation/widgets/profile_edit_sheet.dart';
import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:falconclubapp/shared/domain/entities/profile.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUpdateMyProfile extends Mock implements UpdateMyProfile {}

/// No photoUrl on purpose — the preview would otherwise be a `NetworkImage`,
/// which the test asset bundle can't fetch. The camera icon path is what renders
/// here; the network-preview path is exercised on device.
const Profile _coach = Profile(
  id: 'c1',
  firstName: 'محمد',
  lastName: 'العنزي',
  role: UserRole.club,
  phone: '0512345678',
  gender: Gender.male,
);

void main() {
  testWidgets('ProfileEditSheet renders seeded fields and gender selection', (
    WidgetTester tester,
  ) async {
    final ProfileEditCubit cubit = ProfileEditCubit(_MockUpdateMyProfile())
      ..seed(_coach);
    addTearDown(cubit.close);

    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: BlocProvider<ProfileEditCubit>.value(
              value: cubit,
              child: const ProfileEditSheet(),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('تعديل الملف الشخصي'), findsOneWidget);
    expect(find.text('محمد'), findsOneWidget); // seeded first name
    expect(find.text('العنزي'), findsOneWidget); // seeded last name
    expect(find.text('0512345678'), findsOneWidget); // seeded phone
    expect(find.text('ذكر'), findsOneWidget); // gender option
    expect(find.text('أنثى'), findsOneWidget);
    expect(find.text('حفظ التغييرات'), findsOneWidget); // save
    // No photo → camera-icon path, not a NetworkImage.
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });
}
