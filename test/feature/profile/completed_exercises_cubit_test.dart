import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/profile/domain/entities/completed_exercise.dart';
import 'package:falconclubapp/feature/profile/domain/usecases/get_player_exercises.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/completed_exercises_cubit.dart';
import 'package:falconclubapp/feature/profile/presentation/cubit/completed_exercises_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPlayerExercises extends Mock implements GetPlayerExercises {}

const List<CompletedExercise> _list = <CompletedExercise>[
  CompletedExercise(id: '9', title: 'المرونة', attemptsCount: 3),
  CompletedExercise(id: '10', title: 'السرعة', attemptsCount: 1),
];

void main() {
  late _MockGetPlayerExercises getPlayerExercises;

  setUp(() => getPlayerExercises = _MockGetPlayerExercises());

  blocTest<CompletedExercisesCubit, CompletedExercisesState>(
    'load success emits [Loading, Loaded]',
    build: () {
      when(() => getPlayerExercises(any())).thenAnswer(
        (_) async => const Right<Failure, List<CompletedExercise>>(_list),
      );
      return CompletedExercisesCubit(getPlayerExercises);
    },
    act: (c) => c.load('p1'),
    expect: () => <Matcher>[
      isA<CompletedExercisesLoading>(),
      isA<CompletedExercisesLoaded>().having(
        (s) => s.exercises,
        'exercises',
        _list,
      ),
    ],
    verify: (_) => verify(() => getPlayerExercises('p1')).called(1),
  );

  blocTest<CompletedExercisesCubit, CompletedExercisesState>(
    'load failure emits [Loading, Failure]',
    build: () {
      when(() => getPlayerExercises(any())).thenAnswer(
        (_) async => const Left<Failure, List<CompletedExercise>>(
          ServerFailure(message: 'فشل'),
        ),
      );
      return CompletedExercisesCubit(getPlayerExercises);
    },
    act: (c) => c.load('p1'),
    expect: () => <Matcher>[
      isA<CompletedExercisesLoading>(),
      isA<CompletedExercisesFailure>().having(
        (s) => s.message,
        'message',
        'فشل',
      ),
    ],
  );
}
