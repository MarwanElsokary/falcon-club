import 'dart:convert';

import 'package:falconclubapp/core/security/auth_events.dart';
import 'package:falconclubapp/core/security/jwt_token.dart';
import 'package:flutter_test/flutter_test.dart';

/// The rule deciding whether a 401 kills the session.
///
/// A 401 alone is not enough: it can equally mean "this account may not do
/// that", and one endpoint refusing a role must not sign everybody out. The
/// interceptor only announces when the token it actually sent is expired,
/// reusing [JwtToken.isExpired] — the same check the splash screen applies, so
/// expiry has one definition rather than two.
///
/// These test the rule and the announcement channel directly; the interceptor
/// itself is a thin wiring of the two.
String _jwt({required DateTime expiry}) {
  String segment(Map<String, dynamic> json) =>
      base64Url.encode(utf8.encode(jsonEncode(json))).replaceAll('=', '');
  return '${segment(<String, dynamic>{'alg': 'HS256'})}'
      '.${segment(<String, dynamic>{'exp': expiry.millisecondsSinceEpoch ~/ 1000})}'
      '.signature';
}

void main() {
  group('fatality rule', () {
    test('an expired token is session-fatal', () {
      final String expired = _jwt(
        expiry: DateTime.now().subtract(const Duration(hours: 1)),
      );

      expect(JwtToken.isExpired(expired), isTrue);
    });

    test('a 401 on a still-valid token is NOT session-fatal', () {
      // This is the permissions case: the session is fine, the endpoint simply
      // refused this account. Signing the user out here would be the bug.
      final String live = _jwt(
        expiry: DateTime.now().add(const Duration(hours: 1)),
      );

      expect(JwtToken.isExpired(live), isFalse);
    });

    test('an absent or malformed token fails closed', () {
      expect(JwtToken.isExpired(null), isTrue);
      expect(JwtToken.isExpired(''), isTrue);
      expect(JwtToken.isExpired('not-a-jwt'), isTrue);
    });
  });

  group('AuthEvents', () {
    test('broadcasts expiry to a listener', () async {
      final AuthEvents events = AuthEvents();
      addTearDown(events.dispose);

      final Future<void> received = events.sessionExpired.first;
      events.notifySessionExpired();

      await expectLater(received, completes);
    });

    test('is a broadcast stream — several listeners each get the event', () async {
      final AuthEvents events = AuthEvents();
      addTearDown(events.dispose);

      final Future<void> a = events.sessionExpired.first;
      final Future<void> b = events.sessionExpired.first;
      events.notifySessionExpired();

      await expectLater(Future.wait(<Future<void>>[a, b]), completes);
    });

    test('notifying after dispose does not throw', () {
      final AuthEvents events = AuthEvents()..dispose();

      expect(events.notifySessionExpired, returnsNormally);
    });
  });
}
