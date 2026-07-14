/// The single source of truth for persistence keys.
///
/// ## These strings are load-bearing — do not "clean them up"
///
/// The values below are the **exact** keys the legacy app already reads. They
/// look untidy (`userType` for a role, `userToken` for an auth token) but they
/// cannot be renamed until every legacy reader is migrated, because:
///
/// * `DioFactory`'s auth interceptor reads `userToken` from secure storage on
///   every single request (`dio_factory.dart:41`). Change that key and every
///   authenticated call in the app starts failing.
/// * ~14 other call sites read these keys directly — `splash_screen`,
///   `login_button_widget`, `home_app_bar_widget`, `log_out_widget`,
///   `custom_drawer_widget`, and several repositories.
///
/// Renaming them is a separate, deliberate migration once nothing outside the
/// session layer touches storage. Until then, the new session layer writes
/// where the old readers look.
///
/// ## The role is deliberately written to BOTH stores
///
/// This is the bug from the audit: login writes the role to *secure* storage
/// (`SharedPrefHelper.setSecuredString(userType)`) while `CustomDrawer` reads it
/// from *plain* prefs (`CacheHelper.getString('userType')`). Two stores, one
/// value. Until the drawer is migrated, [SessionLocalDataSource] writes the role
/// to both so neither reader is orphaned — see the dual-write there.
abstract final class StorageKeys {
  const StorageKeys._();

  /// Secret — [SecureStore]. Read by `DioFactory` on every request.
  static const String authToken = 'userToken';
  static const String refreshToken = 'refreshToken';

  /// The registration token, kept **only** to authenticate phone confirmation.
  ///
  /// ⚠️ Deliberately a **different key** from [authToken]. `DioFactory`'s
  /// interceptor and `SessionRepository.readSession()` both read [authToken] and
  /// neither reads this one — which is precisely what stops a pending
  /// registration from becoming a session or silently authenticating ordinary
  /// requests. Do not merge the two.
  static const String pendingRegistrationToken = 'pendingRegistrationToken';

  /// When the pending registration token was received, ISO-8601 UTC.
  ///
  /// Stored because the 15-minute confirmation window is a **server-side rule**
  /// that the token itself does not encode — its JWT `exp` is ~45 years out. The
  /// deadline can only be reconstructed from when we received it, so a user who
  /// closes the app and returns still gets an honest countdown.
  static const String pendingRegistrationIssuedAt =
      'pendingRegistrationIssuedAt';

  /// Not a secret, but currently kept in [SecureStore] by the legacy code.
  static const String userId = 'userId';

  /// The user's role. Written to BOTH stores during the transition — see above.
  static const String userRole = 'userType';

  static const String isProfileCompleted = 'isCompleted';
  static const String languageCode = 'lang';
}
