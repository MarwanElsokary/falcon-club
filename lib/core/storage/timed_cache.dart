import 'dart:convert';

import 'package:injectable/injectable.dart';

import 'key_value_store.dart';

/// A key-value cache whose entries expire.
///
/// ## Why this exists
///
/// The repositories it replaces cache with `CacheHelper.setString(key, json)`
/// and **never expire anything**. An exercise's details are written once and
/// read back forever: upload an attempt and the player's attempt count is stale
/// until the user signs out, because signing out is the only thing that clears
/// the store. (`myProfile` has a 10-minute freshness check —
/// `CacheHelper.isMyProfileValid` — so the pattern was understood; it just was
/// not applied here.)
///
/// Two of those repositories also cache the *same* endpoint under two different
/// keys (`exercise_details_$id` and `scout_exercise_details_$id`), so a Club and
/// a Scout on the same device keep separate, separately-stale copies.
///
/// ## Behaviour
///
/// An entry is stored as `{"savedAt": <epoch ms>, "payload": {...}}`. [read]
/// returns `null` when the entry is missing, unparseable, or older than
/// [maxAge] — a stale entry is indistinguishable from no entry, so callers have
/// exactly one path to handle rather than a freshness flag to check and forget.
///
/// A corrupt entry is **evicted, not fatal**. `ExperianceDetailsRepo` decodes
/// its cached JSON with no inner guard, so one bad blob makes the trial screen
/// fail permanently, with no refetch — it never self-heals. Here a decode
/// failure just misses the cache.
///
/// SRP: it knows about freshness and serialisation. It does not know what an
/// exercise is; [KeyValueStore] does not know what a TTL is.
@lazySingleton
class TimedCache {
  const TimedCache(this._store);

  final KeyValueStore _store;

  static const String _savedAtField = 'savedAt';
  static const String _payloadField = 'payload';

  /// The cached object, or `null` if absent, stale, or corrupt.
  Map<String, dynamic>? read(String key, {required Duration maxAge}) {
    final String? raw = _store.readString(key);
    if (raw == null || raw.isEmpty) return null;

    final Map<String, dynamic>? envelope = _decode(raw);
    if (envelope == null) {
      // Corrupt. Drop it rather than let it fail every future read.
      _store.remove(key);
      return null;
    }

    if (_isStale(envelope[_savedAtField], maxAge)) return null;

    final Object? payload = envelope[_payloadField];
    return payload is Map<String, dynamic> ? payload : null;
  }

  Future<void> write(String key, Map<String, dynamic> payload) {
    final String envelope = jsonEncode(<String, dynamic>{
      _savedAtField: DateTime.now().millisecondsSinceEpoch,
      _payloadField: payload,
    });
    return _store.writeString(key, envelope);
  }

  /// Drops an entry, so the next read goes to the network.
  ///
  /// Call this after a write that invalidates it — uploading an attempt changes
  /// the exercise's roster counts.
  Future<void> invalidate(String key) => _store.remove(key);

  Map<String, dynamic>? _decode(String raw) {
    try {
      final Object? decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  /// Fails closed: an entry with no usable timestamp is treated as stale rather
  /// than as fresh-forever.
  bool _isStale(Object? savedAt, Duration maxAge) {
    if (savedAt is! int) return true;
    final DateTime writtenAt = DateTime.fromMillisecondsSinceEpoch(savedAt);
    return DateTime.now().difference(writtenAt) > maxAge;
  }
}
