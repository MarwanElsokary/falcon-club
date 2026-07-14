import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/registration_details.dart';
import '../../domain/entities/registration_fields.dart';
import '../../domain/entities/registration_outcome.dart';
import '../../domain/usecases/register_scout.dart';
import 'registration_cubit.dart';
import 'registration_state.dart';

/// Registers a scout.
///
/// Substitutable for [ClubRegistrationCubit] behind [RegistrationCubit] (LSP),
/// which is why one screen serves both.
///
/// It ignores [RegistrationInput.club] entirely — scout registration is
/// club-less by design, confirmed with product. `ScoutRegistrationDetails` has
/// no club field at all, so there is nothing to forget to send and nothing a
/// future reader could mistake for an oversight.
@injectable
class ScoutRegistrationCubit extends RegistrationCubit {
  ScoutRegistrationCubit(this._registerScout);

  final RegisterScout _registerScout;

  @override
  Future<void> submit(RegistrationInput input) async {
    final Either<ValidationFailure, RegistrationFields> fields =
        RegistrationFields.create(
          firstName: input.firstName,
          lastName: input.lastName,
          email: input.email,
          phone: input.phone,
          password: input.password,
          gender: input.gender,
          photoPath: input.photoPath,
        );

    await fields.fold(
      (ValidationFailure failure) async =>
          emit(RegistrationFailed(failure.message)),
      (RegistrationFields validated) =>
          _register(ScoutRegistrationDetails(fields: validated)),
    );
  }

  Future<void> _register(ScoutRegistrationDetails details) async {
    emit(const RegistrationInProgress());
    final result = await _registerScout(details);
    emit(
      result.fold(
        (Failure failure) => RegistrationFailed(failure.message),
        (RegistrationOutcome outcome) => RegistrationSucceeded(outcome),
      ),
    );
  }
}
