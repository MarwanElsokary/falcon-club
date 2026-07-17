import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/trial.dart';
import 'package:falconclubapp/feature/exercise/domain/usecases/get_trial_details.dart';
import 'package:falconclubapp/feature/trial_details/cubit/trial_details_cubit.dart';
import 'package:falconclubapp/feature/trial_details/cubit/trial_details_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetTrialDetails extends Mock implements GetTrialDetails {}

void main() {
  late _MockGetTrialDetails getTrialDetails;

  const Trial trial = Trial(
    title: 'تجارب نادي أبطال المدينة',
    minAge: 6,
    maxAge: 10,
  );

  setUp(() => getTrialDetails = _MockGetTrialDetails());

  TrialDetailsCubit build() => TrialDetailsCubit(getTrialDetails);

  blocTest<TrialDetailsCubit, TrialDetailsState>(
    'loading -> loaded carries the trial',
    setUp: () => when(
      () => getTrialDetails(any()),
    ).thenAnswer((_) async => const Right<Failure, Trial>(trial)),
    build: build,
    act: (cubit) => cubit.load('7'),
    expect: () => <Matcher>[
      isA<TrialDetailsLoading>(),
      isA<TrialDetailsLoaded>().having((s) => s.trial, 'trial', trial),
    ],
    verify: (_) => verify(() => getTrialDetails('7')).called(1),
  );

  blocTest<TrialDetailsCubit, TrialDetailsState>(
    'loading -> failure carries the message',
    setUp: () => when(() => getTrialDetails(any())).thenAnswer(
      (_) async =>
          const Left<Failure, Trial>(NetworkFailure(message: 'لا يوجد اتصال')),
    ),
    build: build,
    act: (cubit) => cubit.load('7'),
    expect: () => <Matcher>[
      isA<TrialDetailsLoading>(),
      isA<TrialDetailsFailure>().having(
        (s) => s.message,
        'message',
        'لا يوجد اتصال',
      ),
    ],
  );
}
