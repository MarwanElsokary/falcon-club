import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import 'secure_store.dart';

/// [SecureStore] backed by the platform keystore/keychain.
///
/// LSP: adds nothing beyond the interface, so a test fake substitutes cleanly.
///
/// Security note: unlike `SharedPrefHelper.setSecuredString`, this deliberately
/// logs nothing. That method `debugPrint`s the auth token in plaintext on every
/// write.
@LazySingleton(as: SecureStore)
class SecureStorageStore implements SecureStore {
  const SecureStorageStore(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}
