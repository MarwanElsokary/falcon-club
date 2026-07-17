import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../core/storage/key_value_store.dart';
import '../domain/entities/subscription.dart';
import '../domain/subscription_reader.dart';

/// Reads entitlement from the cached profile.
///
/// ## Why the profile, and not the login response
///
/// The login response carries `isSubscribed`, and it is tempting to treat it as
/// *the* source since it comes straight from the server at sign-in. But it is a
/// **snapshot**: a Scout who buys a package mid-session would stay locked out of
/// everything they just paid for until they signed out and back in.
///
/// `GET myProfile` re-fetches, and `CacheHelper` rewrites this blob every time it
/// does — including right after a purchase. So the profile cache is the *same*
/// figure, kept current. The login flag seeds it; this keeps it true.
///
/// ## It fails closed
///
/// A missing, corrupt, or unexpectedly-shaped profile yields [Subscription.none].
/// Paid content stays shut. Entitlement is never granted by a storage failure.
@LazySingleton(as: SubscriptionReader)
class CachedSubscriptionReader implements SubscriptionReader {
  const CachedSubscriptionReader(this._store);

  final KeyValueStore _store;

  /// `CacheHelper` stores `{"time": …, "data": <MyProfileModel>}`, and
  /// `MyProfileModel` is itself `{"message": …, "data": {…fields}}` — so the
  /// fields sit two levels down.
  static const String _profileKey = 'myProfile';
  static const String _dataField = 'data';
  static const String _isSubscribedField = 'isSubscribed';
  static const String _remainingDaysField = 'remainingSubscriptionDays';

  @override
  Subscription current() {
    final Map<String, dynamic>? profile = _cachedProfile();
    if (profile == null) return Subscription.none;

    return Subscription(
      isPurchased: profile[_isSubscribedField] == true,
      remainingDays: _asInt(profile[_remainingDaysField]),
    );
  }

  Map<String, dynamic>? _cachedProfile() {
    final String? raw = _store.readString(_profileKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final Object? envelope = jsonDecode(raw);
      if (envelope is! Map) return null;

      final Object? model = envelope[_dataField];
      if (model is! Map) return null;

      final Object? fields = model[_dataField];
      return fields is Map ? Map<String, dynamic>.from(fields) : null;
    } catch (_) {
      // A corrupt blob cannot prove a subscription. Assume none.
      return null;
    }
  }

  static int? _asInt(Object? value) => switch (value) {
    int number => number,
    num number => number.toInt(),
    String text => int.tryParse(text),
    _ => null,
  };
}
