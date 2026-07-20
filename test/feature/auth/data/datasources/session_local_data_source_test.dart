import 'package:falconclubapp/core/storage/key_value_store.dart';
import 'package:falconclubapp/core/storage/secure_store.dart';
import 'package:falconclubapp/core/storage/storage_keys.dart';
import 'package:falconclubapp/feature/auth/data/datasources/session_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStore extends Mock implements SecureStore {}

class _MockKeyValueStore extends Mock implements KeyValueStore {}

void main() {
  late _MockSecureStore secureStore;
  late _MockKeyValueStore keyValueStore;
  late StoredSessionLocalDataSource dataSource;

  setUp(() {
    secureStore = _MockSecureStore();
    keyValueStore = _MockKeyValueStore();
    dataSource = StoredSessionLocalDataSource(secureStore, keyValueStore);

    when(() => secureStore.write(any(), any())).thenAnswer((_) async {});
    when(() => secureStore.delete(any())).thenAnswer((_) async {});
    when(() => keyValueStore.writeString(any(), any())).thenAnswer((_) async {});
    when(() => keyValueStore.remove(any())).thenAnswer((_) async {});
    when(() => keyValueStore.clear()).thenAnswer((_) async {});
  });

  group('write', () {
    test('puts the token where DioFactory looks for it', () async {
      await dataSource.write(token: 'jwt', userId: 'id', role: 'Scout');

      // dio_factory.dart:41 reads SecureStore['userToken'] on every request.
      // If this key ever drifts, every authenticated call in the app breaks.
      verify(() => secureStore.write(StorageKeys.authToken, 'jwt')).called(1);
      expect(StorageKeys.authToken, 'userToken');
    });

    // The audit's storage bug: login writes the role to SECURE storage while
    // CustomDrawer reads it from PLAIN prefs. Until the drawer is migrated,
    // both must be written or one reader is orphaned.
    test('dual-writes the role to secure AND plain storage', () async {
      await dataSource.write(token: 'jwt', userId: 'id', role: 'MainClub');

      verify(() => secureStore.write(StorageKeys.userRole, 'MainClub'))
          .called(1);
      verify(() => keyValueStore.writeString(StorageKeys.userRole, 'MainClub'))
          .called(1);
    });

    test('uses the legacy key names the rest of the app still reads', () {
      expect(StorageKeys.userRole, 'userType');
      expect(StorageKeys.userId, 'userId');
    });
  });

  group('clear', () {
    test('removes the token, refresh token, and user id', () async {
      await dataSource.clear();

      verify(() => secureStore.delete(StorageKeys.authToken)).called(1);
      verify(() => secureStore.delete(StorageKeys.refreshToken)).called(1);
      verify(() => secureStore.delete(StorageKeys.userId)).called(1);
      verify(() => secureStore.delete(StorageKeys.userRole)).called(1);
    });

    // Signing out must not leave the previous user's data on the device.
    // Removing only the role key would strand `myProfile`, `categories` and
    // `home_trials` in shared prefs — `CacheHelper` reads them straight back
    // with no ownership check, so the next person to sign in on this handset
    // would briefly see someone else's profile.
    //
    // This used to call `clear()` on the whole plain store, which achieved that
    // but also destroyed keys that have nothing to do with the session: the
    // store is the same `SharedPreferences` singleton `easy_localization` keeps
    // the chosen locale in, so logging out reset the app's language. Each
    // user-scoped key is now removed by name; the assertions below pin BOTH
    // halves — everything of the user's goes, and the store is not wiped.
    test('removes every user-scoped key from the plain store', () async {
      await dataSource.clear();

      for (final String key in <String>[
        'userType',
        'isCompleted',
        'userToken',
        'secured_userToken',
        'refreshToken',
        'userId',
        'myProfile',
        'categories',
        'home_trials',
      ]) {
        verify(() => keyValueStore.remove(key)).called(1);
      }
    });

    test('does NOT wipe the whole plain store (the locale must survive)', () async {
      await dataSource.clear();

      verifyNever(() => keyValueStore.clear());
    });
  });
}
