import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/attempt_repository.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/viewer_capability_port.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/upload_attempt_for_player.dart';
import 'package:falconclubapp/feature/exercise/domain/value_objects/attempt_video.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/attempt_upload_cubit.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/attempt_upload_state.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockAttemptRepository extends Mock implements AttemptRepository {}

class _StubCapability implements ViewerCapabilityPort {
  const _StubCapability(this._capability);

  final ExerciseCapability _capability;

  @override
  ExerciseCapability current() => _capability;
}

/// Phase 5: the upload runs through [AttemptUploadCubit] → [UploadAttemptForPlayer]
/// → [AttemptRepository]. The cubit resolves the caller's capability and hands it
/// to the use case; the use case enforces the Scout ban at the domain boundary.
///
/// The real [UploadAttemptForPlayer] is used (not a mock) so the guard actually
/// runs — that guard is the security fix. Only the repository is mocked, so
/// "nothing reached the network" is `verifyNever` on it.
void main() {
  late _MockAttemptRepository repo;

  setUpAll(() {
    registerFallbackValue(
      AttemptVideo.create('/fallback.mp4').getRight().toNullable()!,
    );
    registerFallbackValue((int _) {});
  });

  setUp(() => repo = _MockAttemptRepository());

  AttemptUploadCubit cubitFor(ExerciseCapability capability) =>
      AttemptUploadCubit(
        UploadAttemptForPlayer(repo),
        _StubCapability(capability),
      );

  Future<void> attemptUpload(AttemptUploadCubit cubit) => cubit.uploadAttempt(
    playerId: 'p1',
    exerciseId: '9',
    videoPath: '/tmp/clip.mp4',
  );

  void verifyNothingUploaded() => verifyNever(
    () => repo.uploadAttemptForPlayer(
      playerId: any(named: 'playerId'),
      exerciseId: any(named: 'exerciseId'),
      video: any(named: 'video'),
      onProgress: any(named: 'onProgress'),
    ),
  );

  group('a Scout is refused, and NOTHING reaches the network', () {
    for (final (String label, Subscription subscription) in <(
      String,
      Subscription,
    )>[
      ('unsubscribed', Subscription.none),
      ('subscribed', Subscription(isPurchased: true, remainingDays: 30)),
    ]) {
      blocTest<AttemptUploadCubit, AttemptUploadState>(
        '$label scout',
        build: () => cubitFor(ScoutCapability(subscription)),
        act: attemptUpload,
        expect: () => <Matcher>[
          isA<AttemptUploadInProgress>(),
          isA<AttemptUploadFailure>(),
        ],
        verify: (_) => verifyNothingUploaded(),
      );
    }
  });

  blocTest<AttemptUploadCubit, AttemptUploadState>(
    'MainClub is refused too — it is read-only',
    build: () => cubitFor(const MainClubCapability()),
    act: attemptUpload,
    expect: () => <Matcher>[
      isA<AttemptUploadInProgress>(),
      isA<AttemptUploadFailure>(),
    ],
    verify: (_) => verifyNothingUploaded(),
  );

  blocTest<AttemptUploadCubit, AttemptUploadState>(
    'a blank path is refused before the use case is ever reached',
    build: () => cubitFor(const CoachCapability()),
    act: (cubit) => cubit.uploadAttempt(
      playerId: 'p1',
      exerciseId: '9',
      videoPath: '   ',
    ),
    // No AttemptUploadInProgress: validation fails before any upload starts.
    expect: () => <Matcher>[isA<AttemptUploadFailure>()],
    verify: (_) => verifyNothingUploaded(),
  );

  blocTest<AttemptUploadCubit, AttemptUploadState>(
    'a Club coach uploads, and progress is reported before success',
    setUp: () => when(
      () => repo.uploadAttemptForPlayer(
        playerId: any(named: 'playerId'),
        exerciseId: any(named: 'exerciseId'),
        video: any(named: 'video'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((invocation) async {
      final UploadProgress? onProgress =
          invocation.namedArguments[#onProgress] as UploadProgress?;
      onProgress?.call(50);
      return const Right<Failure, void>(null);
    }),
    build: () => cubitFor(const CoachCapability()),
    act: attemptUpload,
    expect: () => <AttemptUploadState>[
      const AttemptUploadInProgress(0),
      const AttemptUploadInProgress(50),
      const AttemptUploadSuccess(),
    ],
    verify: (_) => verify(
      () => repo.uploadAttemptForPlayer(
        playerId: 'p1',
        exerciseId: '9',
        video: any(named: 'video'),
        onProgress: any(named: 'onProgress'),
      ),
    ).called(1),
  );

  blocTest<AttemptUploadCubit, AttemptUploadState>(
    'a transport failure surfaces as AttemptUploadFailure, not a throw',
    setUp: () => when(
      () => repo.uploadAttemptForPlayer(
        playerId: any(named: 'playerId'),
        exerciseId: any(named: 'exerciseId'),
        video: any(named: 'video'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer(
      (_) async => const Left<Failure, void>(NetworkFailure()),
    ),
    build: () => cubitFor(const CoachCapability()),
    act: attemptUpload,
    expect: () => <Matcher>[
      isA<AttemptUploadInProgress>(),
      isA<AttemptUploadFailure>(),
    ],
  );
}
