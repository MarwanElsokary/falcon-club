import 'dart:convert';

import 'package:falconclubapp/core/error/error_mapper.dart';
import 'package:falconclubapp/core/storage/key_value_store.dart';
import 'package:falconclubapp/core/storage/secure_store.dart';
import 'package:falconclubapp/core/storage/storage_keys.dart';
import 'package:falconclubapp/feature/auth/data/datasources/pending_registration_local_data_source.dart';
import 'package:falconclubapp/feature/auth/data/datasources/session_local_data_source.dart';
import 'package:falconclubapp/feature/auth/data/repositories/pending_registration_repository_impl.dart';
import 'package:falconclubapp/feature/auth/data/repositories/session_repository_impl.dart';
import 'package:falconclubapp/feature/auth/domain/entities/registration_credential.dart';
import 'package:flutter_test/flutter_test.dart';

/// An in-memory [SecureStore], so both repositories talk to the *same* storage.
///
/// A mock would prove nothing here: the whole question is whether saving a
/// pending credential can leak into the session's keys when they share a store.
class _InMemorySecureStore implements SecureStore {
  final Map<String, String> entries = <String, String>{};

  @override
  Future<String?> read(String key) async => entries[key];

  @override
  Future<void> write(String key, String value) async => entries[key] = value;

  @override
  Future<void> delete(String key) async => entries.remove(key);

  @override
  Future<void> clear() async => entries.clear();
}

class _InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, Object> entries = <String, Object>{};

  @override
  String? readString(String key) => entries[key] as String?;

  @override
  Future<void> writeString(String key, String value) async =>
      entries[key] = value;

  @override
  bool? readBool(String key) => entries[key] as bool?;

  @override
  Future<void> writeBool(String key, {required bool value}) async =>
      entries[key] = value;

  @override
  Future<void> remove(String key) async => entries.remove(key);

  @override
  Future<void> clear() async => entries.clear();
}

void main() {
  late _InMemorySecureStore secureStore;
  late _InMemoryKeyValueStore keyValueStore;
  late PendingRegistrationRepositoryImpl pendingRegistration;
  late SessionRepositoryImpl session;

  String liveToken() {
    final String payload = base64Url.encode(
      utf8.encode(
        jsonEncode(<String, dynamic>{
          'exp':
              DateTime.now()
                  .toUtc()
                  .add(const Duration(days: 1))
                  .millisecondsSinceEpoch ~/
              Duration.millisecondsPerSecond,
        }),
      ),
    );
    return 'header.$payload.signature';
  }

  setUp(() {
    secureStore = _InMemorySecureStore();
    keyValueStore = _InMemoryKeyValueStore();
    pendingRegistration = PendingRegistrationRepositoryImpl(
      SecurePendingRegistrationLocalDataSource(secureStore),
      const ErrorMapper(),
    );
    session = SessionRepositoryImpl(
      StoredSessionLocalDataSource(secureStore, keyValueStore),
      const ErrorMapper(),
    );
  });

  group('a pending registration is NOT a session', () {
    // 🔒 THE guarantee behind the whole design. Registration must never sign
    // anyone in. Because the OTP endpoints identify the account only by the
    // registration token, we have to keep that token — so the safety has to come
    // from WHERE it is kept, not from discarding it.
    test('saving a credential leaves readSession() returning null', () async {
      await pendingRegistration.save(RegistrationCredential.issuedNow(liveToken()));

      final result = await session.readSession();

      expect(result.isRight(), isTrue);
      expect(
        result.getRight().toNullable(),
        isNull,
        reason: 'a pending registration must never grant app entry',
      );
    });

    test('the credential is written under its own key, not the session key',
        () async {
      final String token = liveToken();

      await pendingRegistration.save(RegistrationCredential.issuedNow(token));

      expect(secureStore.entries[StorageKeys.pendingRegistrationToken], token);
      // dio_factory attaches THIS key to every request. It must stay empty.
      expect(secureStore.entries[StorageKeys.authToken], isNull);
      expect(secureStore.entries[StorageKeys.userId], isNull);
    });

    test('a pending credential is invisible to the session data source',
        () async {
      await pendingRegistration.save(RegistrationCredential.issuedNow(liveToken()));

      final SessionLocalDataSource sessionSource = StoredSessionLocalDataSource(
        secureStore,
        keyValueStore,
      );

      expect(await sessionSource.readToken(), isNull);
      expect(await sessionSource.readUserId(), isNull);
    });
  });

  group('read', () {
    test('returns null when there is no pending registration', () async {
      final result = await pendingRegistration.read();

      expect(result.getRight().toNullable(), isNull);
    });

    // The issue time must survive persistence: the 15-minute window is a
    // server-side rule the token does not encode, so without it a returning user
    // would get a nonsense deadline — which was exactly the bug.
    test('round-trips the token AND its issue time', () async {
      final String token = liveToken();
      final DateTime issuedAt = DateTime.utc(2026, 7, 14, 12);

      await pendingRegistration.save(
        RegistrationCredential(token, issuedAt: issuedAt),
      );

      final RegistrationCredential? restored =
          (await pendingRegistration.read()).getRight().toNullable();

      expect(restored?.token, token);
      expect(restored?.issuedAt, issuedAt);
      expect(restored?.expiresAt, DateTime.utc(2026, 7, 14, 12, 15));
    });

    test('a freshly saved credential reads back as usable', () async {
      await pendingRegistration.save(
        RegistrationCredential.issuedNow(liveToken()),
      );

      final RegistrationCredential? restored =
          (await pendingRegistration.read()).getRight().toNullable();

      expect(restored?.isUsable, isTrue);
      expect(restored!.remainingValidity.inMinutes, greaterThanOrEqualTo(14));
    });

    // Fail closed: without the issue time the deadline is unknowable.
    test('a token stored without an issue time is treated as absent', () async {
      secureStore.entries[StorageKeys.pendingRegistrationToken] = liveToken();

      final result = await pendingRegistration.read();

      expect(result.getRight().toNullable(), isNull);
    });

    test('clear() removes it', () async {
      await pendingRegistration.save(RegistrationCredential.issuedNow(liveToken()));

      await pendingRegistration.clear();

      expect((await pendingRegistration.read()).getRight().toNullable(), isNull);
    });
  });

  group('RegistrationCredential.isUsable', () {
    // The deadline is measured from issuedAt, NOT from the token's JWT `exp`.
    // The real backend issues a token whose `exp` is in 2071, so reading the
    // window from the claim produced a countdown of tens of millions of minutes.
    test('is false once 15 minutes have passed since issue', () {
      final RegistrationCredential stale = RegistrationCredential(
        liveToken(),
        issuedAt: DateTime.now().toUtc().subtract(const Duration(minutes: 16)),
      );

      expect(stale.isUsable, isFalse);
      expect(stale.remainingValidity, Duration.zero);
    });

    test('is true within the window, even though the JWT never expires', () {
      final RegistrationCredential fresh = RegistrationCredential(
        liveToken(),
        issuedAt: DateTime.now().toUtc().subtract(const Duration(minutes: 5)),
      );

      expect(fresh.isUsable, isTrue);
      expect(fresh.remainingValidity.inMinutes, inInclusiveRange(9, 10));
    });

    test('is false for a blank token', () {
      expect(RegistrationCredential.issuedNow('').isUsable, isFalse);
    });

    test('never leaks the token through toString', () {
      final String token = liveToken();

      expect(
        RegistrationCredential.issuedNow(token).toString(),
        isNot(contains(token)),
      );
    });

    test('renders the exact Authorization header the endpoints expect', () {
      expect(
        RegistrationCredential.issuedNow('abc').authorizationHeader,
        'Bearer abc',
      );
    });
  });
}
