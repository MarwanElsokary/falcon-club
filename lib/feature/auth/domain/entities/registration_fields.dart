import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../shared/domain/entities/gender.dart';
import '../../../../shared/domain/value_objects/email_address.dart';
import '../../../../shared/domain/value_objects/password.dart';
import '../../../../shared/domain/value_objects/phone_number.dart';

/// The fields every registration shares, once validated.
///
/// Composition over inheritance: rather than a sealed base class carrying seven
/// fields that both subclasses re-declare, the common data is *one object* that
/// each [RegistrationDetails] variant holds. Club registration is then simply
/// "these fields **plus** a club".
///
/// An instance cannot exist in an invalid state — [create] is the only way in,
/// and it returns a [ValidationFailure] rather than a half-built object. Note
/// [email] is an [EmailAddress] and [phone] is a [PhoneNumber]: on the
/// registration endpoints these really are two different things, and giving them
/// two different types is what stops the B3/B4 confusion from recurring.
final class RegistrationFields extends Equatable {
  const RegistrationFields._({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
    this.photoPath,
  });

  final String firstName;
  final String lastName;
  final EmailAddress email;
  final PhoneNumber phone;
  final Password password;
  final Gender gender;

  /// Local file path of the profile photo. Optional per the contract.
  final String? photoPath;

  static const String _firstNameRequired = 'الاسم الأول مطلوب';
  static const String _lastNameRequired = 'الاسم الأخير مطلوب';
  static const String _genderRequired = 'يرجى اختيار الجنس';

  /// Validates raw form input in one place, for both Club and Scout.
  ///
  /// [gender] is nullable here purely so the "user did not choose" case can be
  /// *rejected* — see [Gender]. It is non-null on the resulting object.
  static Either<ValidationFailure, RegistrationFields> create({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required Gender? gender,
    String? photoPath,
  }) {
    final ValidationFailure? plainFieldError = _validatePlainFields(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
    );
    if (plainFieldError != null) return Left(plainFieldError);

    return _validateValueObjects(
      email: email,
      phone: phone,
      password: password,
    ).map(
      (_ValidatedCredentials credentials) => RegistrationFields._(
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: credentials.email,
        phone: credentials.phone,
        password: credentials.password,
        gender: gender!,
        photoPath: photoPath,
      ),
    );
  }

  /// The fields with no value object of their own.
  static ValidationFailure? _validatePlainFields({
    required String firstName,
    required String lastName,
    required Gender? gender,
  }) {
    if (firstName.trim().isEmpty) {
      return const ValidationFailure(message: _firstNameRequired);
    }
    if (lastName.trim().isEmpty) {
      return const ValidationFailure(message: _lastNameRequired);
    }
    if (gender == null) {
      return const ValidationFailure(message: _genderRequired);
    }
    return null;
  }

  /// Registration is **strict** on all three.
  ///
  /// [PhoneNumber.forSaudiRegistration], not `permissive`: the account is being
  /// *created*, so a malformed number produces an account whose OTP can never
  /// arrive. Sign-in is deliberately lenient — see the [PhoneNumber] doc for why
  /// the two rules differ.
  static Either<ValidationFailure, _ValidatedCredentials> _validateValueObjects({
    required String email,
    required String phone,
    required String password,
  }) => EmailAddress.create(email).flatMap(
    (EmailAddress address) => PhoneNumber.forSaudiRegistration(phone).flatMap(
      (PhoneNumber number) => Password.create(password).map(
        (Password secret) => _ValidatedCredentials(
          email: address,
          phone: number,
          password: secret,
        ),
      ),
    ),
  );

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    password,
    gender,
    photoPath,
  ];
}

/// The three value-object fields, once each has validated itself.
///
/// A private carrier so [RegistrationFields.create] can validate them as a group
/// and still assemble the entity in one place, without a four-level nested
/// `flatMap` doing both jobs at once.
final class _ValidatedCredentials {
  const _ValidatedCredentials({
    required this.email,
    required this.phone,
    required this.password,
  });

  final EmailAddress email;
  final PhoneNumber phone;
  final Password password;
}
