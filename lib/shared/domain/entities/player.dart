import 'package:equatable/equatable.dart';

import 'player_position.dart';

/// A player as *viewed* by a Club, Scout, or Main Club user.
///
/// Per the domain: a Player is data, not a role. There is no player session,
/// no player login, and no player-specific shell — this entity is read by every
/// role through read-only use cases (squad lists, profiles, attempts, rankings).
///
/// OOP: immutable, with no `fromJson`. Deserialisation belongs to a `PlayerModel`
/// DTO in the data layer, which maps *into* this. That is what stops raw API
/// DTOs from becoming the app's de-facto domain type — currently 52 UI files
/// import a `data/model` directly.
final class Player extends Equatable {
  const Player({
    required this.id,
    required this.fullName,
    required this.position,
    this.photoUrl,
    this.jerseyNumber,
    this.talentScore,
    this.isFavorite = false,
  });

  final String id;
  final String fullName;
  final PlayerPosition position;
  final String? photoUrl;
  final int? jerseyNumber;

  /// The "TPS" score shown on cards and the ranking board.
  final double? talentScore;

  final bool isFavorite;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Fallback avatar letter. Four widgets currently re-derive this inline, each
  /// with its own empty-name guard (or, in two cases, without one).
  String get initial =>
      fullName.trim().isEmpty ? '?' : fullName.trim()[0].toUpperCase();

  /// Favouriting is a state transition on the entity, so callers get a new
  /// [Player] rather than mutating a public field.
  Player toggleFavorite() => copyWith(isFavorite: !isFavorite);

  Player copyWith({bool? isFavorite}) => Player(
    id: id,
    fullName: fullName,
    position: position,
    photoUrl: photoUrl,
    jerseyNumber: jerseyNumber,
    talentScore: talentScore,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  @override
  List<Object?> get props => [
    id,
    fullName,
    position,
    photoUrl,
    jerseyNumber,
    talentScore,
    isFavorite,
  ];
}

/// Squad grouping, lifted out of `ClubTeamCubit` (431 lines, 9 responsibilities)
/// and out of `club_my_team_screen.dart`, which reads the cubit's *public
/// mutable* `groupedPlayers` field and re-filters it inside `build()`.
///
/// SRP: grouping a squad is a domain rule, not a cubit's job and not a widget's.
extension SquadGrouping on List<Player> {
  /// Players bucketed by pitch section, in display order, omitting empty
  /// sections.
  Map<PitchSection, List<Player>> groupedBySection() {
    final Map<PitchSection, List<Player>> squad =
        <PitchSection, List<Player>>{};
    for (final Player player in this) {
      squad.putIfAbsent(player.position.section, () => <Player>[]).add(player);
    }
    final List<PitchSection> ordered = squad.keys.toList()
      ..sort((PitchSection a, PitchSection b) => a.order.compareTo(b.order));
    return <PitchSection, List<Player>>{
      for (final PitchSection section in ordered) section: squad[section]!,
    };
  }
}
