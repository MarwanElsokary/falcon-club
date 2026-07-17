import 'package:falconclubapp/shared/data/cached_subscription_reader.dart';
import 'dart:convert';

import 'package:falconclubapp/core/storage/key_value_store.dart';
import 'package:falconclubapp/core/storage/storage_keys.dart';
import 'package:falconclubapp/feature/exercise/data/datasources/cached_viewer_capability.dart';
import 'package:falconclubapp/feature/exercise/domain/entities/exercise_capability.dart';
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

/// The regression guard for a **live security bug**: a Scout could upload an
/// attempt for a player.
///
/// The Home → trials flow routed every role to `ClubTrainingDetailsScreen`,
/// which had no notion of a role and always rendered "+ محاولة". Whatever else
/// changes, resolving a capability must never hand a non-Club user the ability
/// to upload — and it must never do so by *accident*, e.g. because a storage
/// read came back empty.
void main() {
  late _FakeStore store;
  late CachedViewerCapability capability;

  setUp(() {
    store = _FakeStore();
    // Composed with the REAL subscription reader, not a stub: the point of the
    // refactor is that the exercise paywall and every other paywall in the app
    // now resolve entitlement through one rule. A stub here would let the two
    // drift apart again without a test noticing.
    capability = CachedViewerCapability(store, CachedSubscriptionReader(store));
  });

  void signedInAs(String role) => store.strings[StorageKeys.userRole] = role;

  void withProfile({required bool subscribed, int? remainingDays}) {
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

  group('a Scout can never upload', () {
    test('unsubscribed', () {
      signedInAs('Scout');
      withProfile(subscribed: false);

      final ExerciseCapability result = capability.current();

      expect(result, isA<ScoutCapability>());
      expect(result.canUploadAttempt, isFalse);
      expect(result.rowAction, isA<ViewAttemptsAction>());
      expect(result.isPaywalled, isTrue);
    });

    test('subscribed — paying does not buy write access', () {
      signedInAs('Scout');
      withProfile(subscribed: true, remainingDays: 30);

      final ExerciseCapability result = capability.current();

      expect(result.isPaywalled, isFalse);
      expect(result.canUploadAttempt, isFalse);
    });

    test('with no profile cached at all', () {
      signedInAs('Scout');

      expect(capability.current().canUploadAttempt, isFalse);
    });
  });

  test('a Club coach can upload, and is never paywalled', () {
    signedInAs('Club');
    withProfile(subscribed: false);

    final ExerciseCapability result = capability.current();

    expect(result, isA<CoachCapability>());
    expect(result.canUploadAttempt, isTrue);
    expect(result.isPaywalled, isFalse);
  });

  test('MainClub is read-only', () {
    signedInAs('MainClub');
    withProfile(subscribed: true, remainingDays: 10);

    expect(capability.current().canUploadAttempt, isFalse);
  });

  group('it fails CLOSED — a storage problem never grants privilege', () {
    // `UserRole.fromApiValue` is lenient and defaults to `club`. Feeding a
    // missing role through it would have handed an unidentifiable user the
    // upload button. `forStoredRole` refuses.
    test('a missing role does not become a Club', () {
      final ExerciseCapability result = capability.current();

      expect(result.canUploadAttempt, isFalse);
      expect(result, isA<ScoutCapability>(), reason: 'least privilege');
    });

    test('an unrecognised role does not become a Club', () {
      signedInAs('Administrator');

      expect(capability.current().canUploadAttempt, isFalse);
    });

    test('an empty role string does not become a Club', () {
      signedInAs('');

      expect(capability.current().canUploadAttempt, isFalse);
    });

    // A Player token cannot exist in this app (sign-in refuses it), but if one
    // ever did, it must not be silently upgraded to Club either.
    test('a Player role does not become a Club', () {
      signedInAs('Player');

      expect(capability.current().canUploadAttempt, isFalse);
    });

    test('a corrupt profile blob yields no subscription, not a crash', () {
      signedInAs('Scout');
      store.strings['myProfile'] = 'not json';

      final ExerciseCapability result = capability.current();

      expect(result.isPaywalled, isTrue);
      expect(result.canUploadAttempt, isFalse);
    });

    test('an unexpectedly shaped profile yields no subscription', () {
      signedInAs('Scout');
      store.strings['myProfile'] = jsonEncode(<String, dynamic>{'data': 42});

      expect(capability.current().isPaywalled, isTrue);
    });
  });

  group('subscription is read from the cached profile', () {
    test('an expired subscription is not active', () {
      signedInAs('Scout');
      withProfile(subscribed: true, remainingDays: 0);

      expect(capability.current().isPaywalled, isTrue);
    });

    test('a stringified day count is still read', () {
      signedInAs('Scout');
      store.strings['myProfile'] = jsonEncode(<String, dynamic>{
        'data': <String, dynamic>{
          'data': <String, dynamic>{
            'isSubscribed': true,
            'remainingSubscriptionDays': '15',
          },
        },
      });

      expect(capability.current().isPaywalled, isFalse);
    });
  });
}
