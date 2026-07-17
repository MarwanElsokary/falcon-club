import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/attempt_repository.dart';
import 'package:falconclubapp/feature/exercise/domain/repositories/exercise_repository.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_exercises.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_player_attempts.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/upload_attempt_for_player.dart';
import 'package:falconclubapp/feature/exercise/domain/value_objects/attempt_video.dart';
import 'package:falconclubapp/shared/domain/entities/attempt.dart';
import 'package:falconclubapp/shared/domain/entities/exercise.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockExerciseRepository extends Mock implements ExerciseRepository {}

class _MockAttemptRepository extends Mock implements AttemptRepository {}

AttemptVideo _video(String path) =>
    AttemptVideo.create(path).getRight().toNullable()!;

Attempt _attempt(String id) =>
    Attempt(id: id, status: AttemptStatus.completed);

void main() {
  group('AttemptVideo', () {
    test('refuses a blank path so an empty upload never reaches the wire', () {
      expect(AttemptVideo.create('   ').isLeft(), isTrue);
      expect(AttemptVideo.create('').isLeft(), isTrue);
    });

    test('derives the filename from a POSIX path', () {
      expect(_video('/storage/emulated/0/clip.mp4').fileName, 'clip.mp4');
    });

    // The three inline `split('/').last` copies this replaces return the entire
    // path here, because they hard-code the POSIX separator.
    test('derives the filename from a Windows path too', () {
      expect(_video(r'C:\Users\x\clip.mp4').fileName, 'clip.mp4');
    });

    test('a bare filename survives unchanged', () {
      expect(_video('clip.mp4').fileName, 'clip.mp4');
    });

    test('never leaks the device path through toString', () {
      expect(
        _video('/private/storage/user/clip.mp4').toString(),
        isNot(contains('private')),
      );
    });
  });

  group('UploadAttemptForPlayer', () {
    late _MockAttemptRepository repository;
    late UploadAttemptForPlayer useCase;

    setUp(() {
      repository = _MockAttemptRepository();
      useCase = UploadAttemptForPlayer(repository);
      registerFallbackValue(_video('/tmp/x.mp4'));
    });

    AttemptUpload uploadAs(ExerciseCapability capability) => AttemptUpload(
      capability: capability,
      playerId: 'player-1',
      exerciseId: '7',
      video: _video('/tmp/clip.mp4'),
    );

    // The button is unbuildable for a Scout — but a use case must not rely on
    // the UI to enforce a permission. A deep link or a reused sheet would
    // bypass that entirely.
    test('refuses a Scout and makes NO request', () async {
      final result = await useCase(
        uploadAs(const ScoutCapability(Subscription.none)),
      );

      expect(result.isLeft(), isTrue);
      expect(result.getLeft().toNullable(), isA<UnauthorizedFailure>());
      verifyNever(
        () => repository.uploadAttemptForPlayer(
          playerId: any(named: 'playerId'),
          exerciseId: any(named: 'exerciseId'),
          video: any(named: 'video'),
          onProgress: any(named: 'onProgress'),
        ),
      );
    });

    test('refuses a subscribed Scout just the same', () async {
      const Subscription active = Subscription(
        isPurchased: true,
        remainingDays: 30,
      );

      final result = await useCase(uploadAs(const ScoutCapability(active)));

      expect(result.isLeft(), isTrue);
      verifyNever(
        () => repository.uploadAttemptForPlayer(
          playerId: any(named: 'playerId'),
          exerciseId: any(named: 'exerciseId'),
          video: any(named: 'video'),
          onProgress: any(named: 'onProgress'),
        ),
      );
    });

    test('refuses MainClub, which is read-only', () async {
      final result = await useCase(uploadAs(const MainClubCapability()));

      expect(result.isLeft(), isTrue);
      verifyNever(
        () => repository.uploadAttemptForPlayer(
          playerId: any(named: 'playerId'),
          exerciseId: any(named: 'exerciseId'),
          video: any(named: 'video'),
          onProgress: any(named: 'onProgress'),
        ),
      );
    });

    test('lets a Club through, passing the video and the player', () async {
      when(
        () => repository.uploadAttemptForPlayer(
          playerId: any(named: 'playerId'),
          exerciseId: any(named: 'exerciseId'),
          video: any(named: 'video'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((_) async => const Right<Failure, void>(null));

      final result = await useCase(uploadAs(const CoachCapability()));

      expect(result.isRight(), isTrue);
      verify(
        () => repository.uploadAttemptForPlayer(
          playerId: 'player-1',
          exerciseId: '7',
          video: _video('/tmp/clip.mp4'),
          onProgress: null,
        ),
      ).called(1);
    });
  });

  group('GetExercises', () {
    late _MockExerciseRepository repository;
    late GetExercises useCase;

    setUp(() {
      repository = _MockExerciseRepository();
      useCase = GetExercises(repository);
    });

    test('the default filter asks for everything, unfiltered', () async {
      when(
        () => repository.getExercises(
          categoryId: any(named: 'categoryId'),
          popular: any(named: 'popular'),
        ),
      ).thenAnswer(
        (_) async => const Right<Failure, List<Exercise>>(<Exercise>[]),
      );

      await useCase(ExerciseFilter.all);

      verify(
        () => repository.getExercises(categoryId: '', popular: false),
      ).called(1);
    });

    test('a cleared category is an empty string, not a null', () {
      expect(ExerciseFilter.all.hasCategory, isFalse);
      expect(const ExerciseFilter(categoryId: '3').hasCategory, isTrue);
    });
  });

  group('GetPlayerAttempts', () {
    late _MockAttemptRepository repository;
    late GetPlayerAttempts useCase;

    setUp(() {
      repository = _MockAttemptRepository();
      useCase = GetPlayerAttempts(repository);
    });

    Future<List<Attempt>> fetch(List<Attempt> stored) async {
      when(
        () => repository.getPlayerAttempts(
          exerciseId: any(named: 'exerciseId'),
          playerId: any(named: 'playerId'),
        ),
      ).thenAnswer((_) async => Right<Failure, List<Attempt>>(stored));

      final result = await useCase(
        const PlayerAttemptsQuery(exerciseId: '7', playerId: 'p1'),
      );
      return result.getRight().toNullable()!;
    }

    // This use case used to sort "newest first". It never could: the backend
    // sends no timestamp, only a formatted label ("منذ 7 شهور"). Every date
    // parsed to null, so the comparator returned 0 for every pair — and Dart's
    // sort is NOT stable, so it was free to permute the backend's own ordering
    // for no benefit at all. The order is now passed through untouched.
    test('preserves the backend order exactly', () async {
      final List<Attempt> result = await fetch(<Attempt>[
        _attempt('first'),
        _attempt('second'),
        _attempt('third'),
      ]);

      expect(result.map((Attempt a) => a.id), <String>[
        'first',
        'second',
        'third',
      ]);
    });

    test('an empty list stays empty', () async {
      expect(await fetch(<Attempt>[]), isEmpty);
    });
  });
}
