import 'dart:async';

import 'package:injectable/injectable.dart';

/// Announces that the stored session is no longer usable.
///
/// The network layer detects this (a 401 on an expired token) but must not
/// decide what happens next — it has no `BuildContext`, and "sign the user out
/// and send them to the login screen" is a policy decision, not a transport
/// one. So the interceptor only announces; a listener at the app root reacts.
///
/// Same shape as `FavoritesSync`: a small broadcast hub, deliberately scoped to
/// one concern rather than a general event bus.
@lazySingleton
class AuthEvents {
  final StreamController<void> _sessionExpired =
      StreamController<void>.broadcast();

  /// Fires when a request came back 401 *and* the stored token was genuinely
  /// expired. Never fires for a 401 that is really an authorisation problem.
  Stream<void> get sessionExpired => _sessionExpired.stream;

  void notifySessionExpired() {
    if (!_sessionExpired.isClosed) _sessionExpired.add(null);
  }

  void dispose() => _sessionExpired.close();
}
