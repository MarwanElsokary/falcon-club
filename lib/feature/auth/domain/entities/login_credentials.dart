import 'package:equatable/equatable.dart';

import '../../../../shared/domain/value_objects/password.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';

/// What a user signs in with.
///
/// The type is [PhoneNumber], not [EmailAddress] — because on the wire the
/// `LoginClub` field is *named* `Email` but actually **carries the phone
/// number** (a confirmed backend naming quirk). The domain speaks the truth;
/// the data layer knows the wire's misnomer and nothing else does.
///
/// This is why B4 cannot recur: the login screen can only ever build a
/// [PhoneNumber] here, and the registration screens can only ever build an
/// [EmailAddress] for their own `Email` field. The shared, ambiguous
/// `LoginControllers.email` string — which meant a phone on one screen and an
/// email on another — has no equivalent here.
final class LoginCredentials extends Equatable {
  const LoginCredentials({required this.phone, required this.password});

  final PhoneNumber phone;
  final Password password;

  @override
  List<Object?> get props => [phone, password];
}
