import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/profile/domain/entities/update_profile_params.dart';
import 'package:falconclubapp/feature/profile/domain/usecases/update_my_profile.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_edit_cubit.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_edit_state.dart';
import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:falconclubapp/shared/domain/entities/profile.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:falconclubapp/shared/domain/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockUpdateMyProfile extends Mock implements UpdateMyProfile {}

/// A female coach whose profile parses from the Arabic read (Gender.female) and
/// carries a valid Saudi phone. Used to prove the edit form preselects the real
/// gender rather than defaulting to male.
const Profile _female = Profile(
  id: 'c1',
  firstName: 'سارة',
  lastName: 'أحمد',
  role: UserRole.club,
  phone: '0512345678',
  gender: Gender.female,
  photoUrl: 'https://cdn/x/p.png',
  clubName: 'نادي الصقور',
);

void main() {
  setUpAll(() {
    registerFallbackValue(
      UpdateProfileParams(
        firstName: '',
        lastName: '',
        phone: PhoneNumber.forSaudiRegistration('0500000000').toNullable()!,
        gender: Gender.male,
      ),
    );
  });

  late _MockUpdateMyProfile updateMyProfile;

  setUp(() => updateMyProfile = _MockUpdateMyProfile());

  group('seed', () {
    test('preselects the real gender from the domain profile (not male)', () {
      final ProfileEditCubit cubit = ProfileEditCubit(updateMyProfile);
      addTearDown(cubit.close);
      cubit.seed(_female);

      expect(cubit.firstNameController.text, 'سارة');
      expect(cubit.lastNameController.text, 'أحمد');
      expect(cubit.phoneController.text, '0512345678');
      expect(cubit.gender, Gender.female); // the fix: not defaulted to male
      expect(cubit.currentPhotoUrl, 'https://cdn/x/p.png');
      expect(cubit.newImagePath, isNull);
    });

    test('leaves gender null when the stored value was unknown', () {
      final ProfileEditCubit cubit = ProfileEditCubit(updateMyProfile);
      addTearDown(cubit.close);
      cubit.seed(
        const Profile(
          id: 'c2',
          firstName: 'x',
          lastName: 'y',
          role: UserRole.club,
          phone: '0512345678',
        ),
      );

      expect(cubit.gender, isNull); // never invented
    });
  });

  group('submit', () {
    blocTest<ProfileEditCubit, ProfileEditState>(
      'valid: emits [Submitting, Success] and writes the chosen gender as its int',
      build: () {
        when(
          () => updateMyProfile(any()),
        ).thenAnswer((_) async => const Right<Failure, Unit>(unit));
        return ProfileEditCubit(updateMyProfile);
      },
      act: (c) {
        c.seed(_female);
        return c.submit();
      },
      expect: () => <Matcher>[
        isA<ProfileEditSubmitting>(),
        isA<ProfileEditSuccess>(),
      ],
      verify: (_) {
        final UpdateProfileParams sent =
            verify(() => updateMyProfile(captureAny())).captured.single
                as UpdateProfileParams;
        expect(sent.gender, Gender.female);
        expect(sent.gender.apiValue, 1); // int on the wire
        expect(sent.phone.value, '0512345678');
        expect(sent.imagePath, isNull);
      },
    );

    blocTest<ProfileEditCubit, ProfileEditState>(
      'no gender chosen: fails and never calls the use case',
      build: () => ProfileEditCubit(updateMyProfile),
      act: (c) {
        c.seed(
          const Profile(
            id: 'c3',
            firstName: 'x',
            lastName: 'y',
            role: UserRole.club,
            phone: '0512345678',
          ),
        );
        return c.submit();
      },
      expect: () => <Matcher>[isA<ProfileEditFailure>()],
      verify: (_) => verifyNever(() => updateMyProfile(any())),
    );

    blocTest<ProfileEditCubit, ProfileEditState>(
      'invalid phone: fails via the value object and never calls the use case',
      build: () => ProfileEditCubit(updateMyProfile),
      act: (c) {
        c.seed(_female);
        c.phoneController.text = 'not-a-number';
        return c.submit();
      },
      expect: () => <Matcher>[isA<ProfileEditFailure>()],
      verify: (_) => verifyNever(() => updateMyProfile(any())),
    );

    blocTest<ProfileEditCubit, ProfileEditState>(
      'use-case failure surfaces its message',
      build: () {
        when(() => updateMyProfile(any())).thenAnswer(
          (_) async => const Left<Failure, Unit>(
            ServerFailure(message: 'فشل الحفظ'),
          ),
        );
        return ProfileEditCubit(updateMyProfile);
      },
      act: (c) {
        c.seed(_female);
        return c.submit();
      },
      expect: () => <Matcher>[
        isA<ProfileEditSubmitting>(),
        isA<ProfileEditFailure>().having(
          (f) => f.message,
          'message',
          'فشل الحفظ',
        ),
      ],
    );
  });
}
