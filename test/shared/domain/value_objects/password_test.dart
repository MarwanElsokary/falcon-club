import 'package:falconclubapp/core/error/failures.dart';
import 'package:falconclubapp/shared/domain/value_objects/email_address.dart';
import 'package:falconclubapp/shared/domain/value_objects/password.dart';
import 'package:falconclubapp/shared/domain/value_objects/phone_number.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('Password', () {
    const String validPassword = 'Str0ng!Pass';

    test('accepts a password satisfying every rule', () {
      final Either<ValidationFailure, Password> result = Password.create(
        validPassword,
      );

      expect(result.isRight(), isTrue);
      expect(result.getRight().toNullable()?.value, validPassword);
    });

    test('reports every unmet rule, driving the UI checklist', () {
      expect(Password.unmetRulesOf('abc'), <PasswordRule>[
        PasswordRule.minimumLength,
        PasswordRule.hasUppercase,
        PasswordRule.hasDigit,
        PasswordRule.hasSpecialCharacter,
      ]);
      expect(Password.unmetRulesOf(validPassword), isEmpty);
    });

    test('rejects a password missing a rule', () {
      expect(Password.create('alllowercase1!').isLeft(), isTrue);
      expect(Password.create('Sh0rt!').isLeft(), isTrue);
    });

    test('rejects a mismatched confirmation before checking strength', () {
      final Either<ValidationFailure, Password> result =
          Password.createConfirmed(
            password: validPassword,
            confirmation: 'something-else',
          );

      expect(result.isLeft(), isTrue);
    });

    test('never leaks the secret through toString', () {
      final Password password = Password.create(
        validPassword,
      ).getRight().toNullable()!;

      expect(password.toString(), isNot(contains(validPassword)));
    });
  });

  group('EmailAddress', () {
    test('accepts a well-formed address and trims surrounding space', () {
      final Either<ValidationFailure, EmailAddress> result =
          EmailAddress.create('  mmaasnnas@gmail.com  ');

      expect(result.getRight().toNullable()?.value, 'mmaasnnas@gmail.com');
    });

    test('rejects empty and malformed addresses', () {
      expect(EmailAddress.create('').isLeft(), isTrue);
      expect(EmailAddress.create('   ').isLeft(), isTrue);
      expect(EmailAddress.create('not-an-email').isLeft(), isTrue);
      expect(EmailAddress.create('missing@domain').isLeft(), isTrue);
      expect(EmailAddress.create('@nolocal.com').isLeft(), isTrue);
    });

    // The whole point of the type: it is NOT a PhoneNumber. A phone number can
    // never satisfy EmailAddress.create, so the club_sign_up_screen bug (B3),
    // where the email was handed to the OTP screen as the phone, cannot recur.
    test('rejects a phone number', () {
      expect(EmailAddress.create('500000005').isLeft(), isTrue);
    });
  });

  // Two rules for one type, on purpose. See the PhoneNumber class doc.
  group('PhoneNumber.permissive — SIGN-IN', () {
    test('preserves the input verbatim: no trimming, no reformatting', () {
      // The backend is fed a bare Saudi number today, and that is correct for
      // this product. The value object must not alter the wire value.
      expect(PhoneNumber.permissive('500000005').getRight().toNullable()?.value,
          '500000005');
      expect(PhoneNumber.permissive('05 000 0005').getRight().toNullable()?.value,
          '05 000 0005');
    });

    // Making login strict would lock out any account whose stored number does
    // not match today's Saudi pattern. At sign-in the server decides.
    test('accepts anything non-empty — no Saudi format check', () {
      expect(PhoneNumber.permissive('123').isRight(), isTrue);
      expect(PhoneNumber.permissive('+966500000005').isRight(), isTrue);
      expect(PhoneNumber.permissive('not-a-number').isRight(), isTrue);
    });

    test('rejects only a blank number', () {
      expect(PhoneNumber.permissive('').isLeft(), isTrue);
      expect(PhoneNumber.permissive('   ').isLeft(), isTrue);
    });
  });

  group('PhoneNumber.forSaudiRegistration — SIGNUP', () {
    test('accepts the two Saudi mobile formats', () {
      // 5XXXXXXXX (9) and 05XXXXXXXX (10) — mirrors AppRegex.isPhoneNumberValid,
      // the rule the signup screens already enforce.
      expect(PhoneNumber.forSaudiRegistration('500000005').isRight(), isTrue);
      expect(PhoneNumber.forSaudiRegistration('0500000005').isRight(), isTrue);
    });

    test('rejects a non-Saudi or malformed number', () {
      expect(PhoneNumber.forSaudiRegistration('123').isLeft(), isTrue);
      expect(PhoneNumber.forSaudiRegistration('400000005').isLeft(), isTrue);
      expect(PhoneNumber.forSaudiRegistration('50000000').isLeft(), isTrue);
      expect(PhoneNumber.forSaudiRegistration('5000000055').isLeft(), isTrue);
      expect(PhoneNumber.forSaudiRegistration('not-a-number').isLeft(), isTrue);
    });

    // A malformed signup number creates an account whose OTP can never arrive.
    test('rejects an E.164 number — the wire format is bare, by decision', () {
      expect(
        PhoneNumber.forSaudiRegistration('+966500000005').isLeft(),
        isTrue,
      );
    });

    test('rejects a blank number', () {
      expect(PhoneNumber.forSaudiRegistration('').isLeft(), isTrue);
    });

    // The asymmetry, stated as an executable fact.
    test('is strictly stronger than permissive', () {
      const String looseButNotSaudi = '123';

      expect(PhoneNumber.permissive(looseButNotSaudi).isRight(), isTrue);
      expect(
        PhoneNumber.forSaudiRegistration(looseButNotSaudi).isLeft(),
        isTrue,
      );
    });

    // The signup field caps input at saudiInputLength. If that limit and the
    // validation rule ever disagreed, the field would either block a valid
    // number or let an invalid one through — so pin them together.
    test('a number of exactly saudiInputLength digits is accepted', () {
      final String typed = '5${'0' * (PhoneNumber.saudiInputLength - 1)}';

      expect(typed.length, PhoneNumber.saudiInputLength);
      expect(PhoneNumber.forSaudiRegistration(typed).isRight(), isTrue);
    });

    test('the field limit matches the shortest valid Saudi number', () {
      expect(PhoneNumber.saudiInputLength, 9);
    });
  });
}
