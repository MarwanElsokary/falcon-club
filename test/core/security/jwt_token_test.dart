import 'dart:convert';

import 'package:falconclubapp/core/security/jwt_token.dart';
import 'package:flutter_test/flutter_test.dart';

/// Builds a JWT whose payload carries the given `exp` claim.
String tokenExpiringAt(DateTime? expiry) {
  final Map<String, dynamic> claims = <String, dynamic>{
    if (expiry != null)
      'exp': expiry.toUtc().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond,
  };
  final String payload = base64Url.encode(utf8.encode(jsonEncode(claims)));
  return 'header.$payload.signature';
}

void main() {
  final DateTime now = DateTime.utc(2026, 7, 12, 12);

  group('JwtToken.isExpired — fails closed', () {
    test('a live token is not expired', () {
      final String token = tokenExpiringAt(now.add(const Duration(hours: 1)));

      expect(JwtToken.isExpired(token, now: now), isFalse);
    });

    // The reported bug: a leftover token from an old build sent the user
    // straight into a role shell on launch, without ever signing in.
    test('an expired token is rejected', () {
      final String token = tokenExpiringAt(now.subtract(const Duration(days: 1)));

      expect(JwtToken.isExpired(token, now: now), isTrue);
    });

    test('a token expiring exactly now is rejected', () {
      expect(JwtToken.isExpired(tokenExpiringAt(now), now: now), isTrue);
    });

    test('a null or empty token is expired', () {
      expect(JwtToken.isExpired(null, now: now), isTrue);
      expect(JwtToken.isExpired('', now: now), isTrue);
    });

    test('a malformed token is treated as expired, not as valid', () {
      expect(JwtToken.isExpired('not-a-jwt', now: now), isTrue);
      expect(JwtToken.isExpired('only.two', now: now), isTrue);
      expect(JwtToken.isExpired('a.!!!not-base64!!!.c', now: now), isTrue);
    });

    test('a token with no exp claim is treated as expired', () {
      expect(JwtToken.isExpired(tokenExpiringAt(null), now: now), isTrue);
    });
  });

  group('JwtToken.expiryOf', () {
    test('reads the exp claim as UTC', () {
      final DateTime expiry = DateTime.utc(2026, 8, 1);

      expect(JwtToken.expiryOf(tokenExpiringAt(expiry)), expiry);
    });

    test('is null for a token with no readable expiry', () {
      expect(JwtToken.expiryOf('not-a-jwt'), isNull);
      expect(JwtToken.expiryOf(tokenExpiringAt(null)), isNull);
    });
  });
}
