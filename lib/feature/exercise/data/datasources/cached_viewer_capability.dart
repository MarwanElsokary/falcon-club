import 'package:injectable/injectable.dart';

import '../../../../core/storage/key_value_store.dart';
import '../../../../core/storage/storage_keys.dart';
import '../../../../shared/domain/subscription_reader.dart';
import '../../domain/entities/exercise_capability.dart';
import '../../domain/repositories/viewer_capability_port.dart';

/// Resolves the viewer's capability from what is already on the device.
///
/// * the **role**, from [StorageKeys.userRole] (`'userType'`) — written at
///   sign-in by `SessionLocalDataSource`, and the same key `CacheHelper` uses;
/// * the **subscription**, from [SubscriptionReader] — the single entitlement
///   rule the whole app now shares. This class deliberately does *not* re-derive
///   it; a paywall that computes its own answer is how the app ended up with four
///   different ones.
///
/// ## Everything here fails closed
///
/// A permission check that guesses generously is not a permission check. Each
/// step degrades toward *less* privilege, never more:
///
/// * an unreadable or unknown role → [ScoutCapability] (read-only, paywalled),
///   via [ExerciseCapability.forStoredRole];
/// * a missing or corrupt profile → `Subscription.none`, so a Scout is paywalled
///   rather than let through.
///
/// Neither degradation can produce a [CoachCapability], so no storage failure can
/// conjure an upload button.
@LazySingleton(as: ViewerCapabilityPort)
class CachedViewerCapability implements ViewerCapabilityPort {
  const CachedViewerCapability(this._store, this._subscriptions);

  final KeyValueStore _store;
  final SubscriptionReader _subscriptions;

  @override
  ExerciseCapability current() => ExerciseCapability.forStoredRole(
    _store.readString(StorageKeys.userRole),
    _subscriptions.current(),
  );
}
