import 'dart:convert';

import 'package:falconclubapp/core/storage/key_value_store.dart';
import 'package:falconclubapp/shared/data/cached_subscription_reader.dart';
import 'package:falconclubapp/shared/domain/entities/subscription.dart';
import 'package:flutter_test/flutter_test.dart';

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

/// The single entitlement rule, pinned.
///
/// Five places in the app gate content on a subscription, and before this they
/// used **four different rules**. Three of them checked only `isSubscribed` —
/// i.e. "a plan was bought at some point" — so an EXPIRED subscription still
/// unlocked the rank screen, still displayed "مشترك" in the drawer, and still
/// blocked the user from renewing on the package screen.
void main() {
  late _FakeStore store;
  late CachedSubscriptionReader reader;

  setUp(() {
    store = _FakeStore();
    reader = CachedSubscriptionReader(store);
  });

  void cacheProfile({required Object? subscribed, Object? remainingDays}) {
    store.strings['myProfile'] = jsonEncode(<String, dynamic>{
      'time': 0,
      'data': <String, dynamic>{
        'message': 'Success',
        'data': <String, dynamic>{
          'isSubscribed': subscribed,
          'remainingSubscriptionDays': remainingDays,
        },
      },
    });
  }

  // The real Scout login response: {"isSubscribed": false, ...}
  test('an unsubscribed scout is not entitled', () {
    cacheProfile(subscribed: false);

    final Subscription subscription = reader.current();

    expect(subscription.isPurchased, isFalse);
    expect(subscription.isActive, isFalse);
  });

  test('an active subscription is entitled', () {
    cacheProfile(subscribed: true, remainingDays: 30);

    expect(reader.current().isActive, isTrue);
  });

  // THE bug the other three call sites shared.
  test('an EXPIRED subscription is not entitled — bought is not active', () {
    cacheProfile(subscribed: true, remainingDays: 0);

    final Subscription subscription = reader.current();

    expect(subscription.isPurchased, isTrue, reason: 'a plan was bought');
    expect(subscription.isActive, isFalse, reason: 'but it has run out');
    expect(subscription.hasExpired, isTrue);
  });

  // A Club profile comes back without a day count; absence means "no expiry to
  // check", not "expired".
  test('a missing day count falls back to the purchased flag', () {
    cacheProfile(subscribed: true);

    expect(reader.current().isActive, isTrue);
  });

  test('a stringified day count is still read', () {
    cacheProfile(subscribed: true, remainingDays: '15');

    expect(reader.current().isActive, isTrue);
  });

  group('it fails closed — paid content never falls open', () {
    test('no profile cached', () {
      expect(reader.current(), Subscription.none);
      expect(reader.current().isActive, isFalse);
    });

    test('a corrupt profile blob', () {
      store.strings['myProfile'] = 'not json at all';

      expect(reader.current().isActive, isFalse);
    });

    test('an unexpectedly shaped profile', () {
      store.strings['myProfile'] = jsonEncode(<String, dynamic>{'data': 42});

      expect(reader.current().isActive, isFalse);
    });

    // Anything that is not literally `true` is not a subscription.
    test('a non-boolean isSubscribed does not grant entitlement', () {
      cacheProfile(subscribed: 'yes', remainingDays: 30);

      expect(reader.current().isActive, isFalse);
    });
  });
}
