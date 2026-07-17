import 'package:falconclubapp/core/thems/color_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parse', () {
    // The two codes the live API actually returns.
    test('reads the real backend codes', () {
      expect(ColorCode.parse('0C5147'), const Color(0xFF0C5147));
      expect(ColorCode.parse('5E18EB'), const Color(0xFF5E18EB));
    });

    test('a 6-digit code is opaque', () {
      expect(ColorCode.parse('0C5147')!.a, 1.0);
    });

    test('tolerates a leading hash and surrounding space', () {
      expect(ColorCode.parse(' #0C5147 '), const Color(0xFF0C5147));
    });

    test('accepts an 8-digit code with its own alpha', () {
      expect(ColorCode.parse('800C5147'), const Color(0x800C5147));
    });

    test('refuses anything else rather than inventing a colour', () {
      expect(ColorCode.parse(null), isNull);
      expect(ColorCode.parse(''), isNull);
      expect(ColorCode.parse('nope'), isNull);
      expect(ColorCode.parse('0C51'), isNull, reason: 'wrong length');
      expect(ColorCode.parse('ZZZZZZ'), isNull, reason: 'not hex');
    });
  });

  group('cardColor', () {
    test('uses the backend colour when there is one', () {
      expect(
        ColorCode.cardColor('0C5147', fallbackIndex: 0),
        const Color(0xFF0C5147),
      );
    });

    // A missing or malformed code degrades to the palette the card used to
    // cycle, so a bad value looks like today rather than like a black rectangle.
    test('falls back to the old index-cycled palette', () {
      expect(
        ColorCode.cardColor(null, fallbackIndex: 0),
        ColorCode.fallbackPalette[0],
      );
      expect(
        ColorCode.cardColor('garbage', fallbackIndex: 1),
        ColorCode.fallbackPalette[1],
      );
    });

    test('the fallback wraps, and never throws on a large index', () {
      expect(
        ColorCode.cardColor(null, fallbackIndex: 7),
        ColorCode.fallbackPalette[7 % ColorCode.fallbackPalette.length],
      );
    });
  });
}
