/// The exact multipart field names the auth endpoints expect.
///
/// This is the **only** place the backend's naming quirks are spelled out. Above
/// the data layer, the domain speaks in `PhoneNumber`, `EmailAddress`, and
/// `ClubOption`; nothing else needs to know that the wire calls a phone number
/// "Email".
abstract final class AuthRequestFields {
  const AuthRequestFields._();

  /// ⚠️ Backend misnomer: on `LoginClub` this field is named `Email` but it
  /// carries the **phone number**. Confirmed against the live contract. Do not
  /// "fix" this by sending an email — logins would stop working.
  static const String loginPhone = 'Email';

  /// On `RegisterClub` / `RegisterScout`, `Email` really is an email address.
  static const String registrationEmail = 'Email';

  static const String password = 'Password';
  static const String phoneNumber = 'PhoneNumber';
  static const String firstName = 'FirstName';
  static const String lastName = 'LastName';
  static const String gender = 'Gender';
  static const String photo = 'Photo';

  /// The GUID of the club being joined. Required by `RegisterClub`.
  ///
  /// The app currently validates that the user picked a club and then never
  /// sends it (bug B1). Wired up in Phase 4.
  static const String clubId = 'ClubId';

  /// ⚠️ Backend misnomer: this field is named `PlayerId` but is the **FCM push
  /// token** slot. It is not a player identifier.
  static const String fcmToken = 'PlayerId';

  /// Placeholder sent until Firebase Cloud Messaging is integrated.
  ///
  /// Replace with the real device token once FCM is wired up. This is the
  /// single constant referenced by every auth request — it replaces the three
  /// different junk values the app sends today (`"ClubId"` on club register,
  /// `"1"` on scout register, and `"<phone>Id"` on login), which was finding B2.
  static const String unlinkedFcmToken = 'fcm-token-not-linked';
}
