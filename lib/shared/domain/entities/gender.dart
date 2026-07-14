/// A user's gender, as the registration endpoints encode it.
///
/// Modelled as an enum with an explicit [apiValue] rather than a raw `int`,
/// which is what closes finding B5: `LoginCubit` holds `int gender = -1` for
/// "not chosen" and then submits `gender == -1 ? 0 : gender` — silently
/// registering anyone who skipped the field as [male]. Here, "not chosen" is
/// `null`, and `null` cannot be put into a [RegistrationFields]; the user is
/// asked to choose instead of being assigned a default.
enum Gender {
  male(apiValue: 0),
  female(apiValue: 1);

  const Gender({required this.apiValue});

  final int apiValue;
}
