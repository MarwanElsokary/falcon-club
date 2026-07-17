import 'package:flutter/material.dart';

import 'thems.dart';

/// Turns the backend's `colorCode` into a [Color].
///
/// Every exercise carries one (`GetAllExercises`, `GetTrial`), as a bare hex
/// string with no leading `#` — `"0C5147"`, `"5E18EB"`.
///
/// ## What this replaces
///
/// `all_training_at_experiance_widget.dart:24` hard-codes a three-colour palette
/// and cycles it **by list index**:
///
/// ```dart
/// List catColor = [Color(0xFF451376), blueClr, Color(0xFF0C4F45)];
/// color: catColor[index % catColor.length]
/// ```
///
/// So an exercise's colour depended on *where it happened to sit in the list* —
/// reorder the response and every card changes colour. The backend has always
/// known each exercise's real colour; the client just ignored it. (The hard-coded
/// values are near-identical to the real ones — `#0C4F45` vs the live `0C5147` —
/// which is why nobody noticed.)
///
/// ## The skill tag needs no colour maths
///
/// The tag on those cards is `offWhiteClr.withOpacity(0.15)` with an
/// `offWhiteClr.withOpacity(0.2)` border — a **translucent** overlay, which
/// Flutter alpha-composites over whatever the parent card is painted. It is
/// therefore *already* "a lighter shade of the card colour", and stays exactly
/// that for any hex the backend sends. Swapping the card colour is the whole
/// change; the relationship between card and tag is preserved by construction
/// rather than recomputed.
abstract final class ColorCode {
  const ColorCode._();

  /// The palette the old card cycled through, kept **only** as a fallback for an
  /// exercise whose `colorCode` is missing or unparseable — so a bad value
  /// degrades to today's appearance instead of a blank or black card.
  static const List<Color> fallbackPalette = <Color>[
    Color(0xFF451376),
    blueClr,
    Color(0xFF0C4F45),
  ];

  /// Parses `"0C5147"` / `"#0C5147"` / `"FF0C5147"`. Returns `null` on anything
  /// else — callers choose the fallback rather than being handed a wrong colour.
  static Color? parse(String? code) {
    if (code == null) return null;

    final String hex = code.trim().replaceFirst('#', '');
    if (hex.length != 6 && hex.length != 8) return null;

    final int? value = int.tryParse(hex, radix: 16);
    if (value == null) return null;

    // A 6-digit code carries no alpha; make it fully opaque.
    return Color(hex.length == 6 ? 0xFF000000 | value : value);
  }

  /// The card colour for an exercise, falling back to the old index-cycled
  /// palette when the backend sends nothing usable.
  static Color cardColor(String? code, {required int fallbackIndex}) =>
      parse(code) ??
      fallbackPalette[fallbackIndex.abs() % fallbackPalette.length];
}
