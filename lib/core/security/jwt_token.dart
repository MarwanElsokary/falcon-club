import 'dart:convert';

/// Reads the standard claims out of a JWT, without verifying its signature.
///
/// Signature verification is the *server's* job — the client cannot do it
/// safely (it has no secret). What the client can and must do is refuse to act
/// on a token it can already see is expired, rather than sending it and being
/// bounced with a 401 on every request.
///
/// SRP: it parses a token. It does not store one, fetch one, or decide what to
/// do about one.
///
/// This replaces `LoginCubit._extractUserIdFromToken` (hand-rolled base64
/// decoding inside a presentation cubit) and its companion `_isValidGuid`, which
/// "validated" a GUID by checking that it contained a `-` or was not all digits.
abstract final class JwtToken {
  const JwtToken._();

  static const String _expiryClaim = 'exp';
  static const int _segmentCount = 3;

  /// `true` when [token] is absent, malformed, or past its `exp` claim.
  ///
  /// **Fails closed**: anything we cannot confidently read as a live token is
  /// treated as unusable. A token we cannot parse is not a token we should be
  /// letting someone into the app with.
  static bool isExpired(String? token, {DateTime? now}) {
    final DateTime? expiry = expiryOf(token);
    if (expiry == null) return true;
    return !expiry.isAfter(now ?? DateTime.now().toUtc());
  }

  /// The token's expiry, or `null` if it has none or cannot be parsed.
  static DateTime? expiryOf(String? token) {
    final Map<String, dynamic>? claims = _claimsOf(token);
    final Object? expiry = claims?[_expiryClaim];
    if (expiry is! int) return null;
    return DateTime.fromMillisecondsSinceEpoch(
      expiry * Duration.millisecondsPerSecond,
      isUtc: true,
    );
  }

  static Map<String, dynamic>? _claimsOf(String? token) {
    if (token == null || token.isEmpty) return null;
    final List<String> segments = token.split('.');
    if (segments.length != _segmentCount) return null;
    try {
      final String payload = utf8.decode(
        base64Url.decode(base64Url.normalize(segments[1])),
      );
      final Object? decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }
}
