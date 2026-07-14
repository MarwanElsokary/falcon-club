/// Encrypted local persistence, for secrets only.
///
/// SRP / ISP: kept as a *separate* interface from [KeyValueStore] rather than
/// bolting `setSecuredString`/`getSecuredString` onto the same class (as
/// `SharedPrefHelper` does). The split is what makes "tokens live in secure
/// storage, everything else does not" a compile-time property instead of a
/// convention that the drawer already violates.
///
/// Every method is async because platform keystores are genuinely async —
/// unlike `SharedPrefHelper`, which mixed a sync `getString` with an async one
/// of the same name on the same class.
abstract interface class SecureStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);

  Future<void> clear();
}
