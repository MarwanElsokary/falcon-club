import '../../shared/domain/subscription_reader.dart';
import '../di/dependency_injection.dart';

/// Whether the current user may reach paid content.
///
/// This used to parse `CacheHelper.getmyProfile()` and apply its own
/// `isSubscribed && (days == null || days > 0)` rule. That rule was the *right*
/// one — but it was one of **four** different rules in the app, and the other
/// three were wrong (see [SubscriptionReader]). It now delegates, so every caller
/// shares a single answer and the rule has one place to be corrected.
///
/// Behaviour is unchanged for this call site: [Subscription.isActive] applies
/// exactly the same logic, including treating a missing `remainingDays` (which is
/// how a Club profile comes back) as "no expiry to check".
///
/// Kept as a free function only so the existing call sites keep compiling. New
/// code should depend on [SubscriptionReader] directly rather than reaching
/// through a global.
bool isActiveSubscription() => getIt<SubscriptionReader>().current().isActive;
