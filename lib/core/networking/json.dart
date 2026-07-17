import '../error/exceptions.dart';
import '../error/failure_messages.dart';

/// Defensive readers for untyped JSON bodies.
///
/// Several `ApiService` methods are declared as bare `Future`, so their bodies
/// arrive as `dynamic`. Every data source therefore has to coerce the same
/// shapes, the same way — and before this existed, three of them had grown their
/// own private copies of the same two helpers:
///
/// * `_asJsonObject` — duplicated verbatim in `auth_remote_data_source.dart` and
///   `otp_remote_data_source.dart`
/// * `_asBool` — duplicated in `login_response_model.dart` and
///   `registration_response_model.dart`, with a third inline copy in
///   `otp_response_models.dart`
///
/// One copy, one behaviour. A backend that starts sending `"true"` instead of
/// `true` is now handled everywhere at once, rather than in whichever model
/// someone remembered to update.
abstract final class Json {
  const Json._();

  /// The body as a JSON object.
  ///
  /// Throws [ServerException] if it is anything else — a non-object body is a
  /// contract violation, not something to guess at.
  static Map<String, dynamic> asObject(Object? body) {
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return Map<String, dynamic>.from(body);
    throw const ServerException(
      message: FailureMessages.unexpectedServerResponse,
    );
  }

  /// The value as a list of JSON objects.
  ///
  /// Throws [ServerException] if it is not a list at all — `"data": null` where
  /// an array was promised is a contract violation, and surfacing the server's
  /// error beats silently rendering an empty dropdown the user cannot get past.
  /// Individual rows that are *not* objects are skipped rather than thrown on:
  /// one malformed row must not take down the whole list.
  static List<Map<String, dynamic>> asObjectList(Object? value) {
    if (value is! List) {
      throw const ServerException(
        message: FailureMessages.unexpectedServerResponse,
      );
    }
    return value
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .toList(growable: false);
  }

  /// A boolean, tolerating the stringified forms some backends emit.
  ///
  /// `null` when the value is absent or unrecognised — callers decide the
  /// default, because "missing" and "false" are not always the same thing.
  static bool? asBool(Object? value) => switch (value) {
    bool boolean => boolean,
    'true' || 'True' => true,
    'false' || 'False' => false,
    _ => null,
  };

  /// An integer, tolerating the stringified and floating forms backends emit.
  ///
  /// `null` when absent or unparseable — callers pick the default, because a
  /// missing count and a zero count are not always the same thing.
  ///
  /// This exists because several fields in the exercise payloads are typed
  /// `dynamic` in the DTOs and we have no captured response to pin them down:
  /// `bookings` and `players[].age` may each arrive as `7`, `"7"` or `7.0`.
  /// Rather than guess one and crash on the others, all three are read.
  static int? asInt(Object? value) => switch (value) {
    int number => number,
    num number => number.toInt(),
    String text => int.tryParse(text) ?? double.tryParse(text)?.toInt(),
    _ => null,
  };

  /// A number, keeping any fractional part.
  ///
  /// Use this for scores. [asInt] would truncate `8.7` to `8`, quietly losing a
  /// point of a player's rating.
  static num? asNum(Object? value) => switch (value) {
    num number => number,
    String text => num.tryParse(text),
    _ => null,
  };

  /// A string, or `null` when absent. Never throws on an unexpected type.
  static String? asString(Object? value) {
    final String? text = value?.toString();
    return (text?.isEmpty ?? true) ? null : text;
  }

  /// [asString], falling back to [fallback] when the field is absent or blank.
  ///
  /// Replaces the `message?.isNotEmpty ?? false ? message! : _fallback` idiom
  /// that appeared six times across the response models.
  static String asMessage(Object? value, {required String fallback}) =>
      asString(value) ?? fallback;
}
