import 'package:equatable/equatable.dart';

import 'club_option.dart';
import 'registration_fields.dart';

/// What a user submits to create an account.
///
/// `sealed`, with one variant per registration kind. This is the polymorphism
/// that replaces role-string branching: the data layer picks the endpoint and
/// builds the body by an **exhaustive `switch`** over these two types, so adding
/// a third registration kind is a compile error at every site that must handle
/// it — not a silently-missed `else`.
sealed class RegistrationDetails extends Equatable {
  const RegistrationDetails(this.fields);

  /// The data both variants share, already validated.
  final RegistrationFields fields;

  @override
  List<Object?> get props => [fields];
}

/// Registering a club.
///
/// ## This type is the fix for B1
///
/// [club] is a **required** constructor argument. The backend requires `ClubId`
/// on `RegisterClub`, and the app currently makes the user pick a club, *blocks
/// submission until they do*, and then builds a request body that omits it
/// entirely — the value is validated and thrown away.
///
/// Here, a `ClubRegistrationDetails` **cannot be constructed without a club**.
/// The bug is no longer something to remember not to reintroduce; it is
/// unrepresentable.
final class ClubRegistrationDetails extends RegistrationDetails {
  const ClubRegistrationDetails({
    required RegistrationFields fields,
    required this.club,
  }) : super(fields);

  /// Carries the GUID the backend expects as `ClubId`.
  final ClubOption club;

  @override
  List<Object?> get props => [fields, club];
}

/// Registering a scout.
///
/// Deliberately club-less: scout registration is not attached to a club, so
/// there is no `ClubId` to send and no city/club cascade to fill in. That is a
/// product rule, and it is expressed by this class simply *not having the
/// field* — rather than by a nullable `clubId` that a future reader might think
/// was an oversight.
final class ScoutRegistrationDetails extends RegistrationDetails {
  const ScoutRegistrationDetails({required RegistrationFields fields})
    : super(fields);
}
