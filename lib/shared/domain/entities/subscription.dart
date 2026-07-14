import 'package:equatable/equatable.dart';

/// A user's paid-access state.
///
/// OOP (tell, don't ask): the entitlement *rule* lives on the entity as
/// [isActive], so callers ask the subscription whether it is active instead of
/// re-deriving it from raw fields. Today that rule exists in two places that
/// disagree — `subscription_helper.dart` checks both `isSubscribed` and
/// `remainingDays > 0`, while `package_screen.dart:146` checks only
/// `isSubscribed` and would grant access on an expired subscription.
///
/// SRP: one reason to change — the definition of "currently entitled".
final class Subscription extends Equatable {
  const Subscription({required this.isPurchased, this.remainingDays});

  /// The backend's `isSubscribed` flag: a plan was bought at some point.
  final bool isPurchased;

  /// Days left on the plan. `null` means the backend did not report a horizon,
  /// in which case [isPurchased] alone decides.
  final int? remainingDays;

  /// Never-subscribed state. Used as a safe default when a profile omits it.
  static const Subscription none = Subscription(isPurchased: false);

  /// The single source of truth for "can this user reach paid content?".
  bool get isActive {
    if (!isPurchased) return false;
    final int? days = remainingDays;
    if (days == null) return true;
    return days > 0;
  }

  bool get hasExpired => isPurchased && !isActive;

  @override
  List<Object?> get props => [isPurchased, remainingDays];
}
