/// The pitch section a position belongs to.
///
/// OCP: squad grouping is driven by this enum, not by string comparison on a
/// localized label. `ClubTeamCubit._getSectionKey` currently groups players by
/// matching *Arabic display text* (`'حارس'`, `'مدافع'`, `'ظهير'`) — so the team
/// screen silently breaks the moment the app is translated, or the backend
/// changes a label's wording.
enum PitchSection {
  goalkeeper(order: 0),
  defence(order: 1),
  midfield(order: 2),
  attack(order: 3);

  const PitchSection({required this.order});

  /// Display order of the sections on the team screen. Owned by the domain so
  /// the widget no longer hard-codes a `_sectionOrder` list.
  final int order;
}

/// A player's position, mapped to the section it is grouped under.
///
/// `apiValues` lists every spelling the backend is known to send for the same
/// position. Matching happens here, once, instead of in a cubit.
enum PlayerPosition {
  goalkeeper(section: PitchSection.goalkeeper, apiValues: ['حارس', 'حارس مرمى', 'Goalkeeper', 'GK']),
  centreBack(section: PitchSection.defence, apiValues: ['مدافع', 'قلب دفاع', 'Defender', 'CB']),
  fullBack(section: PitchSection.defence, apiValues: ['ظهير', 'ظهير أيمن', 'ظهير أيسر', 'RB', 'LB']),
  defensiveMidfielder(section: PitchSection.midfield, apiValues: ['محور', 'ارتكاز', 'CDM']),
  centralMidfielder(section: PitchSection.midfield, apiValues: ['وسط', 'لاعب وسط', 'Midfielder', 'CM']),
  attackingMidfielder(section: PitchSection.midfield, apiValues: ['صانع ألعاب', 'CAM']),
  winger(section: PitchSection.attack, apiValues: ['جناح', 'جناح أيمن', 'جناح أيسر', 'Winger', 'RW', 'LW']),
  striker(section: PitchSection.attack, apiValues: ['مهاجم', 'رأس حربة', 'Striker', 'ST']),
  unknown(section: PitchSection.midfield, apiValues: []);

  const PlayerPosition({required this.section, required this.apiValues});

  final PitchSection section;
  final List<String> apiValues;

  /// Case-insensitive lookup. Unrecognised positions degrade to
  /// [PlayerPosition.unknown] rather than throwing — a new backend label must
  /// not crash the team screen.
  static PlayerPosition fromApiValue(String? value) {
    if (value == null || value.isEmpty) return PlayerPosition.unknown;
    final String candidate = value.trim().toLowerCase();
    return PlayerPosition.values.firstWhere(
      (PlayerPosition position) => position.apiValues.any(
        (String known) => known.toLowerCase() == candidate,
      ),
      orElse: () => PlayerPosition.unknown,
    );
  }
}
