import 'package:falconclubapp/shared/domain/entities/player.dart';
import 'package:falconclubapp/shared/domain/entities/player_position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Player playerAt(PlayerPosition position, {String name = 'Test Player'}) =>
      Player(id: position.name, fullName: name, position: position);

  group('PlayerPosition.fromApiValue', () {
    test('maps the Arabic labels the backend sends', () {
      expect(PlayerPosition.fromApiValue('حارس'), PlayerPosition.goalkeeper);
      expect(PlayerPosition.fromApiValue('مدافع'), PlayerPosition.centreBack);
      expect(PlayerPosition.fromApiValue('ظهير'), PlayerPosition.fullBack);
      expect(PlayerPosition.fromApiValue('مهاجم'), PlayerPosition.striker);
    });

    test('maps English labels and abbreviations case-insensitively', () {
      expect(PlayerPosition.fromApiValue('gk'), PlayerPosition.goalkeeper);
      expect(PlayerPosition.fromApiValue('Striker'), PlayerPosition.striker);
    });

    // ClubTeamCubit._getSectionKey drops any position it does not recognise.
    test('degrades unknown positions instead of dropping or throwing', () {
      expect(PlayerPosition.fromApiValue('Sweeper'), PlayerPosition.unknown);
      expect(PlayerPosition.fromApiValue(null), PlayerPosition.unknown);
      expect(PlayerPosition.fromApiValue(''), PlayerPosition.unknown);
    });
  });

  group('SquadGrouping.groupedBySection', () {
    test('buckets players by section, in pitch order', () {
      final List<Player> squad = <Player>[
        playerAt(PlayerPosition.striker),
        playerAt(PlayerPosition.goalkeeper),
        playerAt(PlayerPosition.centralMidfielder),
        playerAt(PlayerPosition.centreBack),
        playerAt(PlayerPosition.fullBack),
      ];

      final Map<PitchSection, List<Player>> grouped = squad.groupedBySection();

      expect(grouped.keys, <PitchSection>[
        PitchSection.goalkeeper,
        PitchSection.defence,
        PitchSection.midfield,
        PitchSection.attack,
      ]);
      expect(grouped[PitchSection.defence], hasLength(2));
    });

    test('omits sections with no players', () {
      final Map<PitchSection, List<Player>> grouped = <Player>[
        playerAt(PlayerPosition.goalkeeper),
      ].groupedBySection();

      expect(grouped.keys, <PitchSection>[PitchSection.goalkeeper]);
    });

    test('is empty for an empty squad', () {
      expect(const <Player>[].groupedBySection(), isEmpty);
    });
  });

  group('Player', () {
    test('derives an avatar initial, guarding a blank name', () {
      expect(playerAt(PlayerPosition.striker, name: 'omar').initial, 'O');
      expect(playerAt(PlayerPosition.striker, name: '   ').initial, '?');
    });

    test('toggleFavorite returns a new instance rather than mutating', () {
      final Player original = playerAt(PlayerPosition.striker);
      final Player favorited = original.toggleFavorite();

      expect(original.isFavorite, isFalse);
      expect(favorited.isFavorite, isTrue);
    });
  });
}
