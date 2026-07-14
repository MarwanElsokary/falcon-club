import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/gender.dart';
import '../../domain/entities/club_option.dart';
import 'registration_state.dart';

/// Raw form input, straight from the screen.
///
/// Deliberately made of primitives: the *screen* should not have to know how to
/// build an `EmailAddress` or a `Password`. It hands over what the user typed,
/// and the cubit runs it through `RegistrationFields.create`, which is the one
/// authority on validity.
final class RegistrationInput extends Equatable {
  const RegistrationInput({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
    this.photoPath,
    this.club,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;

  /// `null` until the user picks — rejected rather than defaulted (B5).
  final Gender? gender;

  final String? photoPath;

  /// Club registration requires this; Scout registration ignores it.
  final ClubOption? club;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    password,
    gender,
    photoPath,
    club,
  ];
}

/// What both registration screens talk to.
///
/// LSP: `ClubRegistrationCubit` and `ScoutRegistrationCubit` are freely
/// substitutable behind this type — same input, same states, same contract. That
/// is what lets **one** `RegistrationScreen` serve both roles.
///
/// It is the direct answer to the duplication in the codebase today: the Club
/// and Scout signup screens are 702 and 628 lines and 82% identical, forked
/// solely because one calls `registerClub()` and the other `registerScout()`.
/// Here that difference lives in the subclass, and nothing else is copied.
abstract class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(const RegistrationIdle());

  Future<void> submit(RegistrationInput input);
}
