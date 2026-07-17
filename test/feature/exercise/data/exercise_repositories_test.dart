import 'package:dio/dio.dart';
import 'package:falconclubapp/core/error/error_mapper.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/core/storage/timed_cache.dart';
import 'package:falconclubapp/feature/exercise/data/datasources/exercise_remote_data_source.dart';
import 'package:falconclubapp/feature/exercise/data/repositories/attempt_repository_impl.dart';
import 'package:falconclubapp/feature/exercise/data/repositories/exercise_cache_keys.dart';
import 'package:falconclubapp/feature/exercise/data/repositories/exercise_repository_impl.dart';
import 'package:falconclubapp/feature/exercise/domain/value_objects/attempt_video.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements ExerciseRemoteDataSource {}

class _MockCache extends Mock implements TimedCache {}

AttemptVideo _video() =>
    AttemptVideo.create('/tmp/clip.mp4').getRight().toNullable()!;

Map<String, dynamic> _detailsBody({int attemptCount = 1}) => <String, dynamic>{
  'data': <String, dynamic>{
    'id': '7',
    'title': 'تمرين',
    'players': <dynamic>[
      <String, dynamic>{
        'id': 'p1',
        'name': 'أحمد',
        'attemptCount': attemptCount,
      },
    ],
  },
};

void main() {
  late _MockRemote remote;
  late _MockCache cache;
  late ErrorMapper errorMapper;

  setUp(() {
    remote = _MockRemote();
    cache = _MockCache();
    errorMapper = const ErrorMapper();

    registerFallbackValue(_video());
    registerFallbackValue(Duration.zero);
    registerFallbackValue(<String, dynamic>{});
    when(() => cache.write(any(), any())).thenAnswer((_) async {});
    when(() => cache.invalidate(any())).thenAnswer((_) async {});
  });

  group('ExerciseRepositoryImpl', () {
    late ExerciseRepositoryImpl repository;

    setUp(
      () => repository = ExerciseRepositoryImpl(remote, cache, errorMapper),
    );

    test('a cache hit is served without touching the network', () async {
      when(
        () => cache.read(any(), maxAge: any(named: 'maxAge')),
      ).thenReturn(_detailsBody(attemptCount: 4));

      final result = await repository.getExerciseDetails('7');

      expect(result.isRight(), isTrue);
      expect(
        result.getRight().toNullable()!.players.single.attemptCount,
        4,
      );
      verifyNever(() => remote.fetchExerciseDetails(any()));
    });

    test('a miss fetches and then caches the body it received', () async {
      when(
        () => cache.read(any(), maxAge: any(named: 'maxAge')),
      ).thenReturn(null);
      when(
        () => remote.fetchExerciseDetails('7'),
      ).thenAnswer((_) async => _detailsBody());

      final result = await repository.getExerciseDetails('7');

      expect(result.isRight(), isTrue);
      verify(() => remote.fetchExerciseDetails('7')).called(1);
      // Cached under ONE key — not one per role, as the old repos did.
      verify(
        () => cache.write(ExerciseCacheKeys.details('7'), any()),
      ).called(1);
    });

    // A full disk must not fail a request whose data already arrived.
    test('a failing cache write does not fail the request', () async {
      when(
        () => cache.read(any(), maxAge: any(named: 'maxAge')),
      ).thenReturn(null);
      when(
        () => remote.fetchExerciseDetails('7'),
      ).thenAnswer((_) async => _detailsBody());
      when(() => cache.write(any(), any())).thenThrow(Exception('disk full'));

      final result = await repository.getExerciseDetails('7');

      expect(result.isRight(), isTrue);
    });

    test('a network error becomes a Failure, never an exception', () async {
      when(
        () => cache.read(any(), maxAge: any(named: 'maxAge')),
      ).thenReturn(null);
      when(() => remote.fetchExerciseDetails('7')).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      final result = await repository.getExerciseDetails('7');

      expect(result.isLeft(), isTrue);
      expect(result.getLeft().toNullable(), isA<Failure>());
    });

    test('the exercise list is not cached', () async {
      when(
        () => remote.fetchExercises(
          categoryId: any(named: 'categoryId'),
          popular: any(named: 'popular'),
        ),
      ).thenAnswer(
        (_) async => <String, dynamic>{
          'data': <dynamic>[
            <String, dynamic>{'id': 1, 'title': 'تمرين'},
          ],
        },
      );

      final result = await repository.getExercises(
        categoryId: '',
        popular: false,
      );

      expect(result.getRight().toNullable(), hasLength(1));
      verifyNever(() => cache.read(any(), maxAge: any(named: 'maxAge')));
      verifyNever(() => cache.write(any(), any()));
    });

    test('a data array that is not a list yields an empty list, not a crash', () async {
      when(
        () => remote.fetchExercises(
          categoryId: any(named: 'categoryId'),
          popular: any(named: 'popular'),
        ),
      ).thenAnswer((_) async => <String, dynamic>{'data': null});

      final result = await repository.getExercises(
        categoryId: '',
        popular: false,
      );

      expect(result.getRight().toNullable(), isEmpty);
    });
  });

  group('AttemptRepositoryImpl', () {
    late AttemptRepositoryImpl repository;

    setUp(() => repository = AttemptRepositoryImpl(remote, cache, errorMapper));

    // The reason this repository holds a cache it never reads: the roster inside
    // club/GetExercise carries each player's attemptCount, and the upload just
    // changed it. Without this, the coach returns to the exercise and sees the
    // old number.
    test('a successful upload invalidates the exercise details cache', () async {
      when(
        () => remote.uploadAttempt(
          playerId: any(named: 'playerId'),
          exerciseId: any(named: 'exerciseId'),
          video: any(named: 'video'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((_) async {});

      final result = await repository.uploadAttemptForPlayer(
        playerId: 'p1',
        exerciseId: '7',
        video: _video(),
      );

      expect(result.isRight(), isTrue);
      verify(
        () => cache.invalidate(ExerciseCacheKeys.details('7')),
      ).called(1);
    });

    // A failed upload changed nothing, so binning a valid cache entry would only
    // cost a needless request.
    test('a failed upload leaves the cache alone', () async {
      when(
        () => remote.uploadAttempt(
          playerId: any(named: 'playerId'),
          exerciseId: any(named: 'exerciseId'),
          video: any(named: 'video'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.uploadAttemptForPlayer(
        playerId: 'p1',
        exerciseId: '7',
        video: _video(),
      );

      expect(result.isLeft(), isTrue);
      verifyNever(() => cache.invalidate(any()));
    });

    test('progress is forwarded to the caller', () async {
      final List<int> reported = <int>[];
      when(
        () => remote.uploadAttempt(
          playerId: any(named: 'playerId'),
          exerciseId: any(named: 'exerciseId'),
          video: any(named: 'video'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((Invocation call) async {
        final onProgress =
            call.namedArguments[#onProgress] as void Function(int)?;
        onProgress?.call(50);
        onProgress?.call(100);
      });

      await repository.uploadAttemptForPlayer(
        playerId: 'p1',
        exerciseId: '7',
        video: _video(),
        onProgress: reported.add,
      );

      expect(reported, <int>[50, 100]);
    });

    test('attempts are never served from cache — they change server-side', () async {
      when(
        () => remote.fetchPlayerAttempts(
          exerciseId: any(named: 'exerciseId'),
          playerId: any(named: 'playerId'),
        ),
      ).thenAnswer(
        (_) async => <String, dynamic>{
          'data': <dynamic>[
            <String, dynamic>{'id': 1, 'isProcessed': 1},
          ],
        },
      );

      final result = await repository.getPlayerAttempts(
        exerciseId: '7',
        playerId: 'p1',
      );

      expect(result.getRight().toNullable(), hasLength(1));
      verifyNever(() => cache.read(any(), maxAge: any(named: 'maxAge')));
    });
  });
}
