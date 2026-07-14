import 'package:injectable/injectable.dart';

import '../../../../core/storage/key_value_store.dart';
import '../../../../core/storage/secure_store.dart';
import '../../../../core/storage/storage_keys.dart';

/// Reads and writes the persisted session.
///
/// DIP: depends on the [SecureStore] / [KeyValueStore] abstractions, not on
/// `FlutterSecureStorage`, `SharedPreferences`, `CacheHelper`, or
/// `SharedPrefHelper`. It is the only place in the new stack that knows a
/// session is stored at all.
abstract interface class SessionLocalDataSource {
  Future<String?> readToken();

  Future<String?> readUserId();

  Future<String?> readRole();

  Future<void> write({
    required String token,
    required String userId,
    required String role,
  });

  Future<void> clear();
}

/// Writes the token and user id to secure storage, and the role to **both**
/// stores.
///
/// ## Why the role is dual-written
///
/// The audit found that the app writes the role to secure storage but reads it
/// back from plain prefs in `CustomDrawer` (`custom_drawer_widget.dart:45`), so
/// the two never agree. Rather than "fixing" one side and silently breaking the
/// other, this writes to both until every reader is migrated off direct storage
/// access (Phase 3+). The dual-write is transitional and tracked; when
/// `CustomDrawer`, `SplashScreen`, and friends consume `ReadSession` instead,
/// the [KeyValueStore] line below is deleted.
///
/// LSP: adds no public API beyond the interface, so a fake substitutes cleanly.
@LazySingleton(as: SessionLocalDataSource)
class StoredSessionLocalDataSource implements SessionLocalDataSource {
  const StoredSessionLocalDataSource(this._secureStore, this._keyValueStore);

  final SecureStore _secureStore;
  final KeyValueStore _keyValueStore;

  @override
  Future<String?> readToken() => _secureStore.read(StorageKeys.authToken);

  @override
  Future<String?> readUserId() => _secureStore.read(StorageKeys.userId);

  @override
  Future<String?> readRole() => _secureStore.read(StorageKeys.userRole);

  @override
  Future<void> write({
    required String token,
    required String userId,
    required String role,
  }) async {
    await _secureStore.write(StorageKeys.authToken, token);
    await _secureStore.write(StorageKeys.userId, userId);
    await _secureStore.write(StorageKeys.userRole, role);
    // Transitional: CustomDrawer still reads the role from plain prefs.
    await _keyValueStore.writeString(StorageKeys.userRole, role);
  }

  /// Signing out wipes the secure keys **and the whole plain store**.
  ///
  /// Removing only [StorageKeys.userRole] from the plain store would leave the
  /// previous user's cached profile (`myProfile`), categories and trials behind
  /// for whoever signs in next — `CacheHelper` reads them straight back with no
  /// ownership check. The two logout dialogs this replaces avoided that by
  /// calling `SharedPrefHelper.clearAllData()` *and* `CacheHelper.clearShared()`,
  /// both of which bottom out in `SharedPreferences.clear()`. The same
  /// `SharedPreferences` singleton backs [KeyValueStore], so one `clear()` here
  /// is equivalent — including the side effect of resetting the onboarding flag,
  /// which is pre-existing behaviour, not a regression.
  @override
  Future<void> clear() async {
    await _secureStore.delete(StorageKeys.authToken);
    await _secureStore.delete(StorageKeys.refreshToken);
    await _secureStore.delete(StorageKeys.userId);
    await _secureStore.delete(StorageKeys.userRole);
    await _keyValueStore.clear();
  }
}
