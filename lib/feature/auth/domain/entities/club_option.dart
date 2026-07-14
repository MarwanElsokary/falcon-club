import 'package:equatable/equatable.dart';

/// A club a registering user can be attached to — one entry in the signup
/// dropdown.
///
/// This is the entity behind bug **B1**. Its [id] is the GUID that
/// `RegisterClub` requires as `ClubId` and that the app currently collects,
/// validates, and then throws away. Once `ClubRegistrationDetails` takes a
/// `ClubOption` as a **required** constructor argument (Phase 4), omitting it
/// stops being possible.
///
/// [id] is a `String` because the backend keys clubs by GUID (confirmed by the
/// `Dashboard/GetClubLists` contract, whose `id` is a GUID). It is held
/// verbatim for the same reason as [City.id].
final class ClubOption extends Equatable {
  const ClubOption({required this.id, required this.name});

  /// The GUID the backend expects in `RegisterClub.ClubId`.
  final String id;

  final String name;

  @override
  List<Object?> get props => [id, name];
}
