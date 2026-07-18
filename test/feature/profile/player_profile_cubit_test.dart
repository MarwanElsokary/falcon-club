import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/profile/domain/entities/player_profile.dart';
import 'package:falconclubapp/feature/profile/domain/usecases/get_player_profile.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/player_profile_cubit.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/player_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPlayerProfile extends Mock implements GetPlayerProfile {}

const PlayerProfile _player = PlayerProfile(
  id: 'p1',
  firstName: 'جسار',
  lastName: 'الجابري',
  positionName: 'راس حربة',
);

void main() {
  late _MockGetPlayerProfile getPlayerProfile;

  setUp(() => getPlayerProfile = _MockGetPlayerProfile());

  blocTest<PlayerProfileCubit, PlayerProfileState>(
    'load success emits [Loading, Loaded] with the fetched player',
    build: () {
      when(() => getPlayerProfile(any())).thenAnswer(
        (_) async => const Right<Failure, PlayerProfile>(_player),
      );
      return PlayerProfileCubit(getPlayerProfile);
    },
    act: (c) => c.load('p1'),
    expect: () => <Matcher>[
      isA<PlayerProfileLoading>(),
      isA<PlayerProfileLoaded>().having((s) => s.profile, 'profile', _player),
    ],
    verify: (_) => verify(() => getPlayerProfile('p1')).called(1),
  );

  blocTest<PlayerProfileCubit, PlayerProfileState>(
    'load failure emits [Loading, Failure] with the message',
    build: () {
      when(() => getPlayerProfile(any())).thenAnswer(
        (_) async => const Left<Failure, PlayerProfile>(
          ServerFailure(message: 'لا يوجد لاعب'),
        ),
      );
      return PlayerProfileCubit(getPlayerProfile);
    },
    act: (c) => c.load('missing'),
    expect: () => <Matcher>[
      isA<PlayerProfileLoading>(),
      isA<PlayerProfileFailure>().having(
        (s) => s.message,
        'message',
        'لا يوجد لاعب',
      ),
    ],
  );
}
