import 'dart:convert';

import 'package:falconclubapp/core/storage/key_value_store.dart';
import 'package:falconclubapp/core/storage/timed_cache.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory [KeyValueStore], so the cache's freshness logic can be driven by
/// planting entries with a chosen `savedAt` rather than by sleeping.
class _FakeStore implements KeyValueStore {
  final Map<String, String> strings = <String, String>{};

  @override
  String? readString(String key) => strings[key];

  @override
  Future<void> writeString(String key, String value) async =>
      strings[key] = value;

  @override
  Future<void> remove(String key) async => strings.remove(key);

  @override
  Future<void> clear() async => strings.clear();

  @override
  bool? readBool(String key) => null;

  @override
  Future<void> writeBool(String key, {required bool value}) async {}
}

void main() {
  late _FakeStore store;
  late TimedCache cache;

  setUp(() {
    store = _FakeStore();
    cache = TimedCache(store);
  });

  /// Plants an entry as if it had been written [age] ago.
  void plant(String key, Map<String, dynamic> payload, {required Duration age}) {
    store.strings[key] = jsonEncode(<String, dynamic>{
      'savedAt': DateTime.now().subtract(age).millisecondsSinceEpoch,
      'payload': payload,
    });
  }

  const Duration ttl = Duration(minutes: 5);

  test('a fresh entry is returned', () async {
    await cache.write('k', <String, dynamic>{'id': '7'});

    expect(cache.read('k', maxAge: ttl), <String, dynamic>{'id': '7'});
  });

  // The whole point of the rewrite: the old cache had no TTL, so an entry
  // written once was served until the user signed out.
  test('a stale entry is a miss, not a stale hit', () {
    plant('k', <String, dynamic>{'id': '7'}, age: const Duration(minutes: 6));

    expect(cache.read('k', maxAge: ttl), isNull);
  });

  test('an entry exactly at the boundary is still fresh', () {
    plant('k', <String, dynamic>{'id': '7'}, age: const Duration(minutes: 4));

    expect(cache.read('k', maxAge: ttl), isNotNull);
  });

  test('a missing entry is a miss', () {
    expect(cache.read('absent', maxAge: ttl), isNull);
  });

  // `ExperianceDetailsRepo` decodes its cached JSON with no guard, so one bad
  // blob fails the trial screen permanently — it never refetches and nothing
  // clears the entry.
  group('a corrupt entry never becomes permanent', () {
    test('unparseable JSON misses AND is evicted', () {
      store.strings['k'] = 'not json at all';

      expect(cache.read('k', maxAge: ttl), isNull);
      expect(store.strings.containsKey('k'), isFalse, reason: 'evicted');
    });

    test('a valid envelope with no timestamp is treated as stale', () {
      store.strings['k'] = jsonEncode(<String, dynamic>{
        'payload': <String, dynamic>{'id': '7'},
      });

      expect(cache.read('k', maxAge: ttl), isNull);
    });

    test('a payload that is not an object misses', () {
      store.strings['k'] = jsonEncode(<String, dynamic>{
        'savedAt': DateTime.now().millisecondsSinceEpoch,
        'payload': 'a string',
      });

      expect(cache.read('k', maxAge: ttl), isNull);
    });
  });

  test('invalidate forces the next read to miss', () async {
    await cache.write('k', <String, dynamic>{'id': '7'});
    expect(cache.read('k', maxAge: ttl), isNotNull);

    await cache.invalidate('k');

    expect(cache.read('k', maxAge: ttl), isNull);
  });

  test('entries do not collide across keys', () async {
    await cache.write('a', <String, dynamic>{'id': 'a'});
    await cache.write('b', <String, dynamic>{'id': 'b'});

    expect(cache.read('a', maxAge: ttl)!['id'], 'a');
    expect(cache.read('b', maxAge: ttl)!['id'], 'b');
  });
}
