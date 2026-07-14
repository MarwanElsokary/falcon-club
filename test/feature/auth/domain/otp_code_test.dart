import 'package:falconclubapp/feature/auth/domain/value_objects/otp_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OtpCode', () {
    // THE regression test for the leading-zero bug.
    //
    // The legacy path sends the code as an int: `int.parse("012345")` is 12345,
    // so a five-digit number goes to the server and the user's correct code is
    // silently rejected. Roughly one code in ten starts with a zero.
    test('preserves a leading zero — the code is a String, never an int', () {
      final OtpCode code = OtpCode.create('012345').getRight().toNullable()!;

      expect(code.value, '012345');
      expect(code.value.length, 6);
      // The old behaviour, for contrast:
      expect(int.parse('012345').toString(), '12345');
    });

    test('preserves a code of all zeros', () {
      expect(
        OtpCode.create('000000').getRight().toNullable()?.value,
        '000000',
      );
    });

    test('accepts a normal six-digit code', () {
      expect(OtpCode.create('123456').getRight().toNullable()?.value, '123456');
    });

    test('trims surrounding whitespace', () {
      expect(OtpCode.create(' 123456 ').getRight().toNullable()?.value,
          '123456');
    });

    test('rejects a code of the wrong length', () {
      expect(OtpCode.create('12345').isLeft(), isTrue);
      expect(OtpCode.create('1234567').isLeft(), isTrue);
    });

    test('rejects a blank code', () {
      expect(OtpCode.create('').isLeft(), isTrue);
      expect(OtpCode.create('   ').isLeft(), isTrue);
    });

    test('rejects non-numeric input', () {
      expect(OtpCode.create('12a456').isLeft(), isTrue);
      expect(OtpCode.create('-12345').isLeft(), isTrue);
    });

    test('the length matches what the input field renders', () {
      expect(OtpCode.length, 6);
    });
  });
}
