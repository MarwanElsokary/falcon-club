import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_player_attempts.dart';
import 'package:falconclubapp/feature/player_attempts/cubit/player_attempts_cubit.dart';
import 'package:falconclubapp/feature/player_attempts/cubit/player_attempts_state.dart';
import 'package:falconclubapp/shared/domain/entities/attempt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPlayerAttempts extends Mock implements GetPlayerAttempts {}

void main() {
  late _MockGetPlayerAttempts getPlayerAttempts;

  final List<Attempt> attempts = <Attempt>[
    const Attempt(id: '1', status: AttemptStatus.completed),
    const Attempt(id: '2', status: AttemptStatus.underReview),
    const Attempt(id: '3', status: AttemptStatus.rejected),
  ];

  setUpAll(
    () => registerFallbackValue(
      const PlayerAttemptsQuery(exerciseId: '9', playerId: 'p1'),
    ),
  );

  setUp(() => getPlayerAttempts = _MockGetPlayerAttempts());

  PlayerAttemptsCubit build() => PlayerAttemptsCubit(getPlayerAttempts);

  Future<void> load(PlayerAttemptsCubit cubit) =>
      cubit.load(exerciseId: '9', playerId: 'p1');

  blocTest<PlayerAttemptsCubit, PlayerAttemptsState>(
    'loading -> loaded with a tally computed from the attempts',
    setUp: () => when(() => getPlayerAttempts(any())).thenAnswer(
      (_) async => Right<Failure, List<Attempt>>(attempts),
    ),
    build: build,
    act: load,
    expect: () => <Matcher>[
      isA<PlayerAttemptsLoading>(),
      isA<PlayerAttemptsLoaded>()
          .having((s) => s.attempts, 'attempts', hasLength(3))
          .having((s) => s.tally.total, 'total', 3)
          .having((s) => s.tally.completed, 'completed', 1)
          .having((s) => s.tally.underReview, 'underReview', 1)
          .having((s) => s.tally.rejected, 'rejected', 1),
    ],
  );

  blocTest<PlayerAttemptsCubit, PlayerAttemptsState>(
    'loading -> failure carries the failure message',
    setUp: () => when(() => getPlayerAttempts(any())).thenAnswer(
      (_) async => const Left<Failure, List<Attempt>>(
        NetworkFailure(message: 'لا يوجد اتصال'),
      ),
    ),
    build: build,
    act: load,
    expect: () => <Matcher>[
      isA<PlayerAttemptsLoading>(),
      isA<PlayerAttemptsFailure>().having(
        (s) => s.message,
        'message',
        'لا يوجد اتصال',
      ),
    ],
  );
}
