import 'package:bloc_test/bloc_test.dart';
import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/feature/auth/domain/usecases/get_terms_and_policies.dart';
import 'package:falconclubapp/feature/auth/presentation/cubit/terms_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetTermsAndPolicies extends Mock implements GetTermsAndPolicies {}

void main() {
  late _MockGetTermsAndPolicies getTerms;

  setUp(() => getTerms = _MockGetTermsAndPolicies());

  blocTest<TermsCubit, TermsState>(
    'loads the terms text',
    build: () {
      when(() => getTerms()).thenAnswer(
        (_) async => const Right<Failure, List<String>>(<String>[
          'البند الأول',
          'البند الثاني',
        ]),
      );
      return TermsCubit(getTerms);
    },
    act: (TermsCubit cubit) => cubit.load(),
    expect: () => const <TermsState>[
      TermsState(isLoading: true),
      TermsState(paragraphs: <String>['البند الأول', 'البند الثاني']),
    ],
    verify: (TermsCubit cubit) => expect(cubit.state.hasText, isTrue),
  );

  // Consent must remain possible even if the text cannot be shown. Blocking
  // registration because a GET failed would be a worse outcome than showing a
  // fallback notice — the checkbox itself is still mandatory.
  blocTest<TermsCubit, TermsState>(
    'a failed fetch degrades to no text, without blocking anything',
    build: () {
      when(() => getTerms()).thenAnswer(
        (_) async => const Left<Failure, List<String>>(NetworkFailure()),
      );
      return TermsCubit(getTerms);
    },
    act: (TermsCubit cubit) => cubit.load(),
    verify: (TermsCubit cubit) {
      expect(cubit.state.hasText, isFalse);
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, isNotNull);
    },
  );

  test('an empty terms list reports no text', () {
    expect(const TermsState().hasText, isFalse);
  });
}
