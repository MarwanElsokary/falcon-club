/// Plain, non-secret local persistence.
///
/// ISP: deliberately narrow — read, write, remove, clear. It does *not* expose
/// JSON blob caching, TTL logic, or profile-shaped accessors the way
/// `CacheHelper` does (`getmyProfile`, `saveCategories`, `isMyProfileValid`).
/// Those are feature concerns and belong in a feature's local data source,
/// which composes this interface rather than extending it.
///
/// DIP: consumers depend on this abstraction, so `shared_preferences` never
/// appears above the data layer. Today 15 widgets import `CacheHelper` or
/// `SharedPrefHelper` directly; nothing above `data/` will import this.
abstract interface class KeyValueStore {
  String? readString(String key);

  Future<void> writeString(String key, String value);

  bool? readBool(String key);

  Future<void> writeBool(String key, {required bool value});

  Future<void> remove(String key);

  Future<void> clear();
}
