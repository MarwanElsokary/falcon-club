import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_exercises.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/exercise_list_cubit.dart';
import 'package:falconclubapp/feature/exercise/presentation/cubit/exercise_list_state.dart';
import 'package:falconclubapp/shared/domain/entities/exercise.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetExercises extends Mock implements GetExercises {}

const Exercise _running = Exercise(id: '1', title: 'الجري السريع');
const SelectedCategory _endurance = SelectedCategory(
  id: '3',
  name: 'تحمل',
  iconUrl: 'https://x/i.png',
);

void main() {
  late _MockGetExercises getExercises;

  setUp(() {
    getExercises = _MockGetExercises();
    registerFallbackValue(ExerciseFilter.all);
  });

  void succeeds() => when(() => getExercises(any())).thenAnswer(
    (_) async => const Right<Failure, List<Exercise>>(<Exercise>[_running]),
  );

  void fails() => when(() => getExercises(any())).thenAnswer(
    (_) async => const Left<Failure, List<Exercise>>(
      ServerFailure(message: 'تعذّر الاتصال'),
    ),
  );

  ExerciseListCubit build() => ExerciseListCubit(getExercises);

  blocTest<ExerciseListCubit, ExerciseListState>(
    'loadAll fetches the unfiltered list',
    setUp: succeeds,
    build: build,
    act: (ExerciseListCubit cubit) => cubit.loadAll(),
    expect: () => <ExerciseListState>[
      const ExerciseListState(status: ExerciseListLoading()),
      const ExerciseListState(
        status: ExerciseListLoaded(<Exercise>[_running]),
      ),
    ],
    verify: (_) => verify(() => getExercises(ExerciseFilter.all)).called(1),
  );

  blocTest<ExerciseListCubit, ExerciseListState>(
    'a failure surfaces a message instead of an endless skeleton',
    setUp: fails,
    build: build,
    act: (ExerciseListCubit cubit) => cubit.loadAll(),
    expect: () => <ExerciseListState>[
      const ExerciseListState(status: ExerciseListLoading()),
      const ExerciseListState(status: ExerciseListFailed('تعذّر الاتصال')),
    ],
  );

  group('category filtering', () {
    // The selection must be applied BEFORE the fetch resolves, or the chip
    // visibly deselects itself for the duration of the round-trip.
    blocTest<ExerciseListCubit, ExerciseListState>(
      'selecting a category highlights it immediately, then loads',
      setUp: succeeds,
      build: build,
      act: (ExerciseListCubit cubit) => cubit.toggleCategory(_endurance),
      expect: () => <ExerciseListState>[
        const ExerciseListState(
          status: ExerciseListLoading(),
          selectedCategory: _endurance,
        ),
        const ExerciseListState(
          status: ExerciseListLoaded(<Exercise>[_running]),
          selectedCategory: _endurance,
        ),
      ],
      verify: (_) => verify(
        () => getExercises(const ExerciseFilter(categoryId: '3')),
      ).called(1),
    );

    blocTest<ExerciseListCubit, ExerciseListState>(
      'tapping the SAME category again clears the filter',
      setUp: succeeds,
      build: build,
      seed: () => const ExerciseListState(selectedCategory: _endurance),
      act: (ExerciseListCubit cubit) => cubit.toggleCategory(_endurance),
      expect: () => <ExerciseListState>[
        const ExerciseListState(status: ExerciseListLoading()),
        const ExerciseListState(
          status: ExerciseListLoaded(<Exercise>[_running]),
        ),
      ],
      verify: (_) => verify(() => getExercises(ExerciseFilter.all)).called(1),
    );

    // The bug the two old widgets shared: clearing reset `selectedFilter` but
    // left `iconSelected` set, because they were two separate setState fields.
    // One object cannot half-clear.
    blocTest<ExerciseListCubit, ExerciseListState>(
      'clearing drops the whole selection, icon included',
      setUp: succeeds,
      build: build,
      seed: () => const ExerciseListState(selectedCategory: _endurance),
      act: (ExerciseListCubit cubit) => cubit.clearCategory(),
      verify: (ExerciseListCubit cubit) {
        expect(cubit.state.selectedCategory, isNull);
        expect(cubit.state.hasSelection, isFalse);
      },
    );

    blocTest<ExerciseListCubit, ExerciseListState>(
      'switching categories replaces the selection rather than stacking it',
      setUp: succeeds,
      build: build,
      seed: () => const ExerciseListState(selectedCategory: _endurance),
      act: (ExerciseListCubit cubit) => cubit.toggleCategory(
        const SelectedCategory(id: '4', name: 'سرعة'),
      ),
      verify: (ExerciseListCubit cubit) {
        expect(cubit.state.selectedCategory?.id, '4');
        expect(cubit.state.isSelected('3'), isFalse);
        verify(
          () => getExercises(const ExerciseFilter(categoryId: '4')),
        ).called(1);
      },
    );

    blocTest<ExerciseListCubit, ExerciseListState>(
      'the selection survives a failed load, so the chip stays where it was',
      setUp: fails,
      build: build,
      act: (ExerciseListCubit cubit) => cubit.toggleCategory(_endurance),
      verify: (ExerciseListCubit cubit) {
        expect(cubit.state.status, isA<ExerciseListFailed>());
        expect(cubit.state.selectedCategory, _endurance);
      },
    );
  });

  blocTest<ExerciseListCubit, ExerciseListState>(
    'an empty result is a real state, not a blank screen',
    setUp: () => when(() => getExercises(any())).thenAnswer(
      (_) async => const Right<Failure, List<Exercise>>(<Exercise>[]),
    ),
    build: build,
    act: (ExerciseListCubit cubit) => cubit.loadAll(),
    verify: (ExerciseListCubit cubit) {
      final ExerciseListStatus status = cubit.state.status;
      expect(status, isA<ExerciseListLoaded>());
      expect((status as ExerciseListLoaded).isEmpty, isTrue);
    },
  );
}
