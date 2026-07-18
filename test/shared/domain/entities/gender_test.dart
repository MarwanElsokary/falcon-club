import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';

/// Gender is encoded two ways: an int at registration, an Arabic label at the
/// profile endpoints. The load-bearing rule is that an unrecognised value maps
/// to null ("unknown"), never silently to male — the bug this closes.
void main() {
  test('maps the Arabic labels the profile endpoints send', () {
    expect(Gender.fromArabic('ذكر'), Gender.male);
    expect(Gender.fromArabic('أنثى'), Gender.female);
  });

  test('null/empty/whitespace → null (unknown), never male', () {
    expect(Gender.fromArabic(null), isNull);
    expect(Gender.fromArabic(''), isNull);
    expect(Gender.fromArabic('   '), isNull);
  });

  test('an unrecognised label → null, never male', () {
    expect(Gender.fromArabic('مجهول'), isNull);
    // The registration int shape is not an Arabic label — must not match.
    expect(Gender.fromArabic('0'), isNull);
    expect(Gender.fromArabic('male'), isNull);
  });

  test('surrounding whitespace is tolerated', () {
    expect(Gender.fromArabic(' ذكر '), Gender.male);
  });

  test('the registration int apiValue is preserved', () {
    expect(Gender.male.apiValue, 0);
    expect(Gender.female.apiValue, 1);
    expect(Gender.male.arabicLabel, 'ذكر');
    expect(Gender.female.arabicLabel, 'أنثى');
  });
}
