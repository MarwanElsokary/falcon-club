import 'package:equatable/equatable.dart';

import 'subscription.dart';
import 'user_role.dart';

/// The authenticated user (a Club, Scout, or Main Club account).
///
/// Distinct from [Player] on purpose: a Profile has a session, a role, and a
/// subscription; a Player has none of those and is only ever read.
///
/// SRP: identity + entitlement of the *current user*. It does not know how to
/// persist itself, refresh itself, or draw itself — `MainCubit` currently does
/// all three for every role at once.
final class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.fullName,
    required this.role,
    this.photoUrl,
    this.phone,
    this.subscription = Subscription.none,
    this.isProfileCompleted = true,
  });

  final String id;
  final String fullName;
  final UserRole role;
  final String? photoUrl;
  final String? phone;
  final Subscription subscription;
  final bool isProfileCompleted;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Delegates to the role and the subscription rather than re-deriving either
  /// (tell, don't ask). A Club is entitled without paying; a Scout must have a
  /// live subscription.
  bool get canAccessPaidContent =>
      !role.requiresSubscription || subscription.isActive;

  @override
  List<Object?> get props => [
    id,
    fullName,
    role,
    photoUrl,
    phone,
    subscription,
    isProfileCompleted,
  ];
}
