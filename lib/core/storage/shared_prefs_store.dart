import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error/exceptions.dart';
import '../error/failure_messages.dart';
import 'key_value_store.dart';

/// [KeyValueStore] backed by `shared_preferences`.
///
/// LSP: substitutable for any other [KeyValueStore] — an in-memory fake in
/// tests, or a Hive/Isar implementation later — with no caller change. That is
/// only true because it adds no public API of its own beyond the interface.
///
/// SRP: stores and retrieves primitives. It does not decide *what* is worth
/// caching or for how long; no TTL, no domain-shaped getters.
///
/// Throws [CacheException] rather than returning null-on-error, so the
/// repository layer can translate it uniformly through [ErrorMapper].
@LazySingleton(as: KeyValueStore)
class SharedPrefsStore implements KeyValueStore {
  const SharedPrefsStore(this._preferences);

  final SharedPreferences _preferences;

  @override
  String? readString(String key) => _preferences.getString(key);

  @override
  Future<void> writeString(String key, String value) async {
    final bool didWrite = await _preferences.setString(key, value);
    if (!didWrite) throw _writeFailure(key);
  }

  @override
  bool? readBool(String key) => _preferences.getBool(key);

  @override
  Future<void> writeBool(String key, {required bool value}) async {
    final bool didWrite = await _preferences.setBool(key, value);
    if (!didWrite) throw _writeFailure(key);
  }

  @override
  Future<void> remove(String key) => _preferences.remove(key);

  @override
  Future<void> clear() => _preferences.clear();

  CacheException _writeFailure(String key) => CacheException(
    message: '${FailureMessages.cacheWriteFailed} ($key)',
  );
}
