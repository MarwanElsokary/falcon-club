import 'entities/subscription.dart';

/// The one place the app asks "is this user entitled to paid content?".
///
/// ## Why this exists
///
/// Before it, six places derived entitlement and **four of them derived it
/// differently**:
///
/// * `subscription_helper.isActiveSubscription()` — `isSubscribed && days > 0`
///   (the correct rule)
/// * `rank_cubit.dart:27` — `isSubscribed` only, so an **expired** subscription
///   still opened the full ranking
/// * `custom_drawer_widget_scout.dart:199` — `isSubscribed` only, so an expired
///   subscription still displayed "مشترك"
/// * `package_screen.dart:147` — `isSubscribed` only
/// * `player_profile_screen.dart:258` — **`skills.length >= 5`**, which is not a
///   subscription check at all: it infers entitlement from how many skills the AI
///   happened to score, so a subscribed player with only three rated skills was
///   shown padlocks on skills they had paid for
/// * `ScoutCapability.isPaywalled` — via [Subscription.isActive]
///
/// A rule that lives in six places is six rules. They had already drifted.
///
/// Synchronous, for the same reason [ViewerCapabilityPort] is: the answer is
/// already on the device, and a check that forces an async rebuild is a check
/// someone will skip.
abstract interface class SubscriptionReader {
  /// The current user's entitlement. Never null — an unknown or unreadable state
  /// is [Subscription.none], so paid content stays shut rather than falling open.
  Subscription current();
}
