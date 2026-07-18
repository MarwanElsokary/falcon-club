import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/profile/domain/profile_cache.dart';
import 'package:falconclubapp/feature/profile/domain/usecases/get_my_profile.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/profile_state.dart';
import 'package:falconclubapp/shared/domain/entities/profile.dart';
import 'package:falconclubapp/shared/domain/entities/user_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetMyProfile extends Mock implements GetMyProfile {}

const Profile _p1 = Profile(
  id: '1',
  firstName: 'قديم',
  lastName: 'x',
  role: UserRole.club,
);
const Profile _p2 = Profile(
  id: '1',
  firstName: 'جديد',
  lastName: 'x',
  role: UserRole.club,
);

void main() {
  late _MockGetMyProfile getMyProfile;
  late ProfileCache cache;

  setUp(() {
    getMyProfile = _MockGetMyProfile();
    cache = ProfileCache();
  });

  blocTest<ProfileCubit, ProfileState>(
    'cold cache: [Loading, Loaded] and caches the result',
    build: () {
      when(getMyProfile.call).thenAnswer(
        (_) async => const Right<Failure, Profile>(_p1),
      );
      return ProfileCubit(getMyProfile, cache);
    },
    act: (c) => c.load(),
    expect: () => <Matcher>[
      isA<ProfileLoading>(),
      isA<ProfileLoaded>().having((s) => s.profile, 'profile', _p1),
    ],
    verify: (_) => expect(cache.value, _p1),
  );

  blocTest<ProfileCubit, ProfileState>(
    'warm cache: shows cached instantly (no Loading) then revalidates',
    build: () {
      cache.save(_p1);
      when(getMyProfile.call).thenAnswer(
        (_) async => const Right<Failure, Profile>(_p2),
      );
      return ProfileCubit(getMyProfile, cache);
    },
    act: (c) => c.load(),
    expect: () => <Matcher>[
      isA<ProfileLoaded>().having((s) => s.profile, 'stale', _p1),
      isA<ProfileLoaded>().having((s) => s.profile, 'fresh', _p2),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'warm cache + refresh failure: keeps the stale profile, no Failure',
    build: () {
      cache.save(_p1);
      when(getMyProfile.call).thenAnswer(
        (_) async => const Left<Failure, Profile>(
          ServerFailure(message: 'offline'),
        ),
      );
      return ProfileCubit(getMyProfile, cache);
    },
    act: (c) => c.load(),
    expect: () => <Matcher>[
      isA<ProfileLoaded>().having((s) => s.profile, 'stale', _p1),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'cold cache + failure: [Loading, Failure]',
    build: () {
      when(getMyProfile.call).thenAnswer(
        (_) async => const Left<Failure, Profile>(
          ServerFailure(message: 'فشل'),
        ),
      );
      return ProfileCubit(getMyProfile, cache);
    },
    act: (c) => c.load(),
    expect: () => <Matcher>[
      isA<ProfileLoading>(),
      isA<ProfileFailure>().having((s) => s.message, 'message', 'فشل'),
    ],
  );
}
