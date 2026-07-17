import 'package:equatable/equatable.dart';

import '../../../../shared/domain/entities/subscription.dart';
import '../../../../shared/domain/entities/user_role.dart';

/// What a player row on an exercise roster lets you *do*.
///
/// A sealed type rather than a `bool canUpload`, so the presentation layer
/// switches exhaustively and adding a third action becomes a compile error at
/// every call site that must handle it (OCP).
sealed class PlayerRowAction extends Equatable {
  const PlayerRowAction();

  @override
  List<Object?> get props => const <Object?>[];
}

/// Upload a video as an attempt for this player. **Club/coach only.**
final class UploadAttemptAction extends PlayerRowAction {
  const UploadAttemptAction();
}

/// Open this player's previous attempts, read-only.
final class ViewAttemptsAction extends PlayerRowAction {
  const ViewAttemptsAction();
}

/// What a given viewer may do with an exercise's roster.
///
/// ## Why this is a type and not two booleans
///
/// There are exactly two role differences in this whole feature area:
///
/// 1. A Club coach may upload an attempt for a player. **A Scout may never** —
///    this is intentional and confirmed, not a missing feature.
/// 2. A Scout sees a subscribe paywall over the roster. **A Club never does** —
///    a coach's own team is not paid content.
///
/// Expressed as `{bool canUpload, bool showPaywall}` those two rules admit four
/// combinations, two of which are product violations (a Scout who can upload; a
/// Club behind a paywall), and the invariant then lives in whoever remembers to
/// set the flags correctly at each call site.
///
/// Here the capability *is* the type. [ScoutCapability] has no code path that
/// returns an [UploadAttemptAction]; [CoachCapability.isPaywalled] is a constant
/// `false`. Neither violation is a flag you can flip — you would have to change
/// the class, which is exactly the friction that should exist.
///
/// DIP: the presentation layer takes an [ExerciseCapability] and asks it. No
/// widget in this feature reads [UserRole], and none contains an `if (role ==
/// ...)`.
sealed class ExerciseCapability extends Equatable {
  const ExerciseCapability();

  /// The one role → capability mapping in the app. Resolved once, at the route.
  ///
  /// A Player is not a role in this app (sign-in refuses one), so it cannot
  /// appear here.
  ///
  /// ## MainClub is deliberately read-only — please confirm
  ///
  /// MainClub reaches the exercise screens (`DrawerPermissions.canShowTraining`
  /// returns `true` for every role), so it needs a capability. Whether it may
  /// *upload* an attempt was never stated. The existing, already-reviewed
  /// `UserRole.canUploadPlayerAttempts` says `role == UserRole.club` — club
  /// only — so that is what this honours.
  ///
  /// This fails closed on purpose: withholding a capability shows a
  /// supervisor a "view" button they expected to be "upload", which is
  /// reported in a day. Granting one we were never asked for lets a role write
  /// data it may have no business writing, and nobody notices. If MainClub
  /// should be able to upload, it becomes [CoachCapability] here and nothing
  /// else changes.
  factory ExerciseCapability.forRole(
    UserRole role,
    Subscription subscription,
  ) => switch (role) {
    UserRole.club => const CoachCapability(),
    UserRole.scout => ScoutCapability(subscription),
    UserRole.mainClub => const MainClubCapability(),
  };

  /// Resolves a capability from the **stored** role string, failing closed.
  ///
  /// This exists because [UserRole.fromApiValue] is *lenient*: it defaults an
  /// unknown or missing value to [UserRole.club]. Feeding that into
  /// [ExerciseCapability.forRole] would hand an unidentifiable user a
  /// [CoachCapability] — the upload button — which is precisely the wrong way to
  /// fail on a permission decision.
  ///
  /// So an unreadable role degrades to [ScoutCapability], the **most restricted**
  /// capability there is: read-only, and paywalled. If we cannot establish who is
  /// asking, they get the least privilege, not the most.
  factory ExerciseCapability.forStoredRole(
    String? storedRole,
    Subscription subscription,
  ) {
    final UserRole? role = UserRole.tryFromApiValue(storedRole);
    if (role == null) return ScoutCapability(subscription);
    return ExerciseCapability.forRole(role, subscription);
  }

  /// The action offered on each player row.
  PlayerRowAction get rowAction;

  /// Whether the roster is behind a subscribe prompt.
  bool get isPaywalled;

  /// Convenience for the upload flow's guard clauses. Deliberately derived from
  /// [rowAction] rather than stored, so the two can never disagree.
  bool get canUploadAttempt => rowAction is UploadAttemptAction;

  @override
  List<Object?> get props => <Object?>[rowAction, isPaywalled];
}

/// A Club coach.
///
/// May upload an attempt for any player on **their own team** — which is every
/// player they can see, because the backend scopes the roster to the bearer
/// token and the client has no parameter with which to ask for anyone else's
/// (see [ExerciseRepository]).
///
/// Never paywalled: a coach managing their own squad is not a paid feature.
final class CoachCapability extends ExerciseCapability {
  const CoachCapability();

  @override
  PlayerRowAction get rowAction => const UploadAttemptAction();

  /// Not a flag — a property of being a coach.
  @override
  bool get isPaywalled => false;
}

/// A Main Club supervisor.
///
/// Read-only, pending confirmation — see [ExerciseCapability.forRole]. Not
/// paywalled: MainClub accounts are onboarded, not sold to.
///
/// It is a separate type rather than an alias of [ScoutCapability] because the
/// two are read-only for unrelated reasons: a Scout is read-only *by product
/// design and forever*, whereas MainClub is read-only *because nobody has told
/// us otherwise yet*. Collapsing them would lose that distinction and make the
/// open question invisible.
final class MainClubCapability extends ExerciseCapability {
  const MainClubCapability();

  @override
  PlayerRowAction get rowAction => const ViewAttemptsAction();

  @override
  bool get isPaywalled => false;
}

/// A Scout.
///
/// Read-only **by design**. There is no branch here that yields an
/// [UploadAttemptAction], so "scout can upload" is not a regression that a
/// future change can introduce by accident.
///
/// Paywalled when the subscription is not active. Note this is the *client's*
/// prompt only — the backend independently truncates the roster for an
/// unsubscribed scout, so the paywall reflects a boundary that is already
/// enforced rather than creating one.
final class ScoutCapability extends ExerciseCapability {
  const ScoutCapability(this.subscription);

  final Subscription subscription;

  @override
  PlayerRowAction get rowAction => const ViewAttemptsAction();

  /// [Subscription.isActive] checks `isPurchased` *and* the remaining days.
  /// `package_screen.dart` currently checks only the former and would let an
  /// expired subscription through; routing the rule through the entity closes
  /// that quietly.
  @override
  bool get isPaywalled => !subscription.isActive;

  @override
  List<Object?> get props => <Object?>[...super.props, subscription];
}
