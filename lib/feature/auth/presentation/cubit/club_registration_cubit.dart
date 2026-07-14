import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/club_option.dart';
import '../../domain/entities/registration_details.dart';
import '../../domain/entities/registration_fields.dart';
import '../../domain/entities/registration_outcome.dart';
import '../../domain/usecases/register_club.dart';
import 'registration_cubit.dart';
import 'registration_state.dart';

/// Registers a club.
///
/// Depends on one use case. It holds no `TextEditingController`s and no
/// `GlobalKey<FormState>` — the screen owns those — so every branch here is
/// testable without a widget tree.
@injectable
class ClubRegistrationCubit extends RegistrationCubit {
  ClubRegistrationCubit(this._registerClub);

  final RegisterClub _registerClub;

  static const String _clubRequiredMessage = 'يرجى اختيار النادي';

  @override
  Future<void> submit(RegistrationInput input) async {
    final ClubOption? club = input.club;
    if (club == null) {
      emit(const RegistrationFailed(_clubRequiredMessage));
      return;
    }

    final Either<ValidationFailure, RegistrationFields> fields =
        _validate(input);

    await fields.fold(
      (ValidationFailure failure) async =>
          emit(RegistrationFailed(failure.message)),
      // The club is non-null past the guard above, and ClubRegistrationDetails
      // *requires* it — so the club can no longer be validated and then dropped
      // from the request body (finding B1).
      (RegistrationFields validated) =>
          _register(ClubRegistrationDetails(fields: validated, club: club)),
    );
  }

  Either<ValidationFailure, RegistrationFields> _validate(
    RegistrationInput input,
  ) => RegistrationFields.create(
    firstName: input.firstName,
    lastName: input.lastName,
    email: input.email,
    phone: input.phone,
    password: input.password,
    gender: input.gender,
    photoPath: input.photoPath,
  );

  Future<void> _register(ClubRegistrationDetails details) async {
    emit(const RegistrationInProgress());
    final result = await _registerClub(details);
    emit(
      result.fold(
        (Failure failure) => RegistrationFailed(failure.message),
        (RegistrationOutcome outcome) => RegistrationSucceeded(outcome),
      ),
    );
  }
}
