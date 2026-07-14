import 'package:injectable/injectable.dart';

import '../../../../core/storage/secure_store.dart';
import '../../../../core/storage/storage_keys.dart';

/// Stores the registration token awaiting phone confirmation.
///
/// It writes to [StorageKeys.pendingRegistrationToken] and
/// [StorageKeys.pendingRegistrationIssuedAt] — **never**
/// [StorageKeys.authToken]. That single fact is what keeps a pending
/// registration from becoming a session: `SessionLocalDataSource` and
/// `DioFactory` both read `authToken`, and neither looks here.
///
/// The issue time is persisted alongside the token because the 15-minute
/// confirmation window is a server-side rule the token does not encode (its JWT
/// `exp` is ~45 years out). Without it, a user who reopened the app would get a
/// nonsense countdown — which is exactly the bug this replaces.
///
/// Kept in [SecureStore] rather than plain preferences because it is still a
/// bearer token: it authenticates two endpoints and must not sit in cleartext.
abstract interface class PendingRegistrationLocalDataSource {
  Future<String?> readToken();

  /// `null` when absent or unparseable — treated as "no pending registration"
  /// rather than guessed at, so a corrupt value fails closed.
  Future<DateTime?> readIssuedAt();

  Future<void> write({required String token, required DateTime issuedAt});

  Future<void> clear();
}

@LazySingleton(as: PendingRegistrationLocalDataSource)
class SecurePendingRegistrationLocalDataSource
    implements PendingRegistrationLocalDataSource {
  const SecurePendingRegistrationLocalDataSource(this._secureStore);

  final SecureStore _secureStore;

  @override
  Future<String?> readToken() =>
      _secureStore.read(StorageKeys.pendingRegistrationToken);

  @override
  Future<DateTime?> readIssuedAt() async {
    final String? stored = await _secureStore.read(
      StorageKeys.pendingRegistrationIssuedAt,
    );
    if (stored == null || stored.isEmpty) return null;
    return DateTime.tryParse(stored)?.toUtc();
  }

  @override
  Future<void> write({
    required String token,
    required DateTime issuedAt,
  }) async {
    await _secureStore.write(StorageKeys.pendingRegistrationToken, token);
    await _secureStore.write(
      StorageKeys.pendingRegistrationIssuedAt,
      issuedAt.toUtc().toIso8601String(),
    );
  }

  @override
  Future<void> clear() async {
    await _secureStore.delete(StorageKeys.pendingRegistrationToken);
    await _secureStore.delete(StorageKeys.pendingRegistrationIssuedAt);
  }
}
