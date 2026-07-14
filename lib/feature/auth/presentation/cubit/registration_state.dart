import 'package:equatable/equatable.dart';

import '../../domain/entities/registration_outcome.dart';

/// States for both registration screens.
///
/// One state type, two cubits. Club and Scout registration differ in *what they
/// submit*, not in how the screen behaves — so sharing the state avoids the kind
/// of copy-paste that produced two 700-line, 82%-identical signup screens.
///
/// Note there is no "signed in" state. [RegistrationSucceeded] carries a
/// [RegistrationOutcome], which has no token: the screen's only move is to send
/// the user to the login screen.
sealed class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object?> get props => const [];
}

final class RegistrationIdle extends RegistrationState {
  const RegistrationIdle();
}

final class RegistrationInProgress extends RegistrationState {
  const RegistrationInProgress();
}

final class RegistrationSucceeded extends RegistrationState {
  const RegistrationSucceeded(this.outcome);

  final RegistrationOutcome outcome;

  @override
  List<Object?> get props => [outcome];
}

final class RegistrationFailed extends RegistrationState {
  const RegistrationFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
