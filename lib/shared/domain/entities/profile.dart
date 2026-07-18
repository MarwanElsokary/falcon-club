import 'package:equatable/equatable.dart';

import 'gender.dart';
import 'subscription.dart';
import 'user_role.dart';

/// The authenticated user (a Club, Scout, or Main Club account).
///
/// Distinct from `PlayerProfile` and `Player` on purpose: a Profile has a
/// session, a role, and a subscription; a viewed player has none of those and is
/// only ever read.
///
/// SRP: identity + entitlement of the *current user*. It does not know how to
/// persist, refresh, or draw itself — the work `MainCubit`/`ClubTeamCubit`
/// currently do for every role at once.
///
/// [role] is resolved from the stored session, not the profile payload
/// (`Club/GetProfile` does not return a role) — see `ProfileRepositoryImpl`.
final class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.email,
    this.phone,
    this.photoUrl,
    this.gender,
    this.accountNumber,
    this.clubName,
    this.positionName,
    this.subscription = Subscription.none,
    this.isProfileCompleted = true,
  });

  final String id;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String? email;
  final String? phone;
  final String? photoUrl;

  /// `null` when the backend sent no gender or one we do not recognise — the UI
  /// shows an "unknown" state rather than assuming male. See [Gender].
  final Gender? gender;

  final String? accountNumber;

  /// The club this account is associated with, when the backend returns one.
  /// Absent from the lean Scout-token `Club/GetProfile` capture, so read
  /// tolerantly — null when not present.
  final String? clubName;

  /// The backend's role/position label (e.g. "مدرب"), shown as the drawer-header
  /// subtitle. Free text, distinct from [role] (the enum); read tolerantly.
  final String? positionName;

  final Subscription subscription;
  final bool isProfileCompleted;

  String get fullName => '$firstName $lastName'.trim();

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Delegates to the role and the subscription (tell, don't ask). A Club is
  /// entitled without paying; a Scout must have a live subscription.
  bool get canAccessPaidContent =>
      !role.requiresSubscription || subscription.isActive;

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    role,
    email,
    phone,
    photoUrl,
    gender,
    accountNumber,
    clubName,
    positionName,
    subscription,
    isProfileCompleted,
  ];
}
