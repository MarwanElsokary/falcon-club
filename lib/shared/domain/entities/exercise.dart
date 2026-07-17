import 'package:equatable/equatable.dart';

import 'subscription.dart';

/// A training exercise, as it appears in a list.
///
/// One entity serves Club, Scout and MainClub alike. The app currently maintains
/// two parallel stacks for this — `training` and `scout_training` — whose repos
/// hit the *same endpoint* (`club/GetAllExercises`) with the same arguments and
/// whose only real difference is a cubit name and a route constant. Nothing about
/// the exercise itself differs by role, so the domain does not branch on role at
/// all. What differs by role is what you may *do* with it — see
/// `ExerciseCapability`.
///
/// ## Corrected in Phase 1
///
/// This entity was drafted during the Auth foundation before the exercise
/// payload had been read. It declared `isPopular`, which is **not a field**:
/// `popular` is a *query parameter* on `GetAllExercises`, a filter you send, not
/// an attribute the backend returns. It also omitted `bookings`, which the
/// exercise card renders on every row. Both are fixed here.
final class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.title,
    this.description,
    this.photoUrl,
    this.categoryId,
    this.categoryName,
    this.categoryIconUrl,
    this.skillNames = const <String>[],
    this.bookingsCount = 0,
    this.isPaid = false,
    this.colorCode,
  });

  final String id;
  final String title;
  final String? description;
  final String? photoUrl;

  final String? categoryId;
  final String? categoryName;
  final String? categoryIconUrl;

  /// Skills this exercise is scored against.
  final List<String> skillNames;

  /// How many players have taken this exercise ("N اشتراك" on the card).
  final int bookingsCount;

  /// Whether the exercise sits behind a subscription.
  ///
  /// Carried through from the payload but **not acted on**: no client-side
  /// paywall is applied to the exercise list today, and gating is the backend's
  /// (it truncates the list for unsubscribed users). Preserved rather than
  /// dropped so that entitlement work has the flag to hand — deliberately not a
  /// behaviour change in this pass.
  final bool isPaid;

  /// The exercise's brand colour, as a bare hex string (`"0C5147"`).
  ///
  /// Kept as the raw code, not a `Color`: a `dart:ui` type in a domain entity
  /// would drag Flutter into the domain layer, and the domain has no opinion
  /// about how a colour is *painted*. `ColorCode.parse` turns it into a `Color`
  /// at the presentation boundary.
  ///
  /// The client used to ignore this entirely and cycle a hard-coded three-colour
  /// palette **by list index**, so an exercise's colour changed if the backend
  /// reordered the response.
  final String? colorCode;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Whether this exercise is behind the paywall for [subscription].
  ///
  /// The rule lives on the entity so every surface that shows an exercise asks
  /// the same question, rather than each re-deriving `isPaid && !subscribed`.
  /// Entitlement itself is [Subscription.isActive] — the single rule the whole
  /// app shares, which counts an *expired* plan as not entitled.
  ///
  /// Until now this was not enforced at all: `isPaid` was parsed and read by
  /// nothing, so a paid exercise looked exactly like a free one.
  bool isLockedFor(Subscription subscription) =>
      isPaid && !subscription.isActive;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    photoUrl,
    categoryId,
    categoryName,
    categoryIconUrl,
    skillNames,
    bookingsCount,
    isPaid,
    colorCode,
  ];
}
