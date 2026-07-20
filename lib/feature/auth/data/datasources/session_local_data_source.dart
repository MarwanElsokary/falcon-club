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

  /// Signing out wipes the secure keys and **every plain key that belongs to a
  /// user** — but not the whole store.
  ///
  /// It used to call `_keyValueStore.clear()`. That did remove the previous
  /// user's data, but `KeyValueStore` is backed by the same `SharedPreferences`
  /// singleton that everything else uses, so it also destroyed things that have
  /// nothing to do with the session — most visibly the locale
  /// `easy_localization` persists, so logging out reset the app's language back
  /// to the `startLocale`.
  ///
  /// The keys below are removed by name instead. Leaving any of them behind
  /// would hand the next user the previous one's data: `CacheHelper` reads
  /// `myProfile` back with no ownership check, and `CachedSubscriptionReader`
  /// derives entitlement from that same blob.
  ///
  /// Deliberately *not* removed: the locale and the FCM device token, neither
  /// of which belongs to a user account.
  @override
  Future<void> clear() async {
    await _secureStore.delete(StorageKeys.authToken);
    await _secureStore.delete(StorageKeys.refreshToken);
    await _secureStore.delete(StorageKeys.userId);
    await _secureStore.delete(StorageKeys.userRole);

    for (final String key in _userScopedPlainKeys) {
      await _keyValueStore.remove(key);
    }
  }

  /// Plain-store keys written per user, by the session layer or by the legacy
  /// `CacheHelper`/`SharedPrefHelper` paths that still shadow it.
  static const List<String> _userScopedPlainKeys = <String>[
    StorageKeys.userRole, // dual-written by [write]
    StorageKeys.isProfileCompleted,
    StorageKeys.authToken, // legacy plain copies of the secure values
    StorageKeys.refreshToken,
    StorageKeys.userId,
    'secured_userToken', // CacheHelper's shadow copy of the token
    // Cached content fetched while signed in. Not secret, but it is the
    // previous account's view of the app, so it goes with them.
    'myProfile',
    'categories',
    'home_trials',
  ];
}
