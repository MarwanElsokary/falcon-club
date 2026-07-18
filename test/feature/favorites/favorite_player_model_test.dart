import 'package:falconclubapp/feature/favorites/data/models/favorite_player_model.dart';
import 'package:falconclubapp/feature/favorites/domain/entities/favorite_player.dart';
import 'package:falconclubapp/shared/domain/entities/gender.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pinned to one element of the live `Club/GetFavPlayers` **bare array**. The
/// array-unwrapping is the data source's job (Json.asObjectList); this asserts a
/// single element maps correctly.
void main() {
  Map<String, dynamic> element() => <String, dynamic>{
    'id': '487265b8-2369-4918-b3b8-79e91698faad',
    'accountNumber': '35734349',
    'photoPath': 'https://files.fteet.ai/Images/Users/x.jpg',
    'name': 'أدم عزام الشويكي',
    'age': 10,
    'gender': 'ذكر',
    'position': 'ظهير ايسر',
    'direction': 0,
    'foot': 'يمين',
    'tps': 23.52,
  };

  test('parses a live favourite-player element', () {
    final FavoritePlayer p = FavoritePlayerModel.fromJson(element());

    expect(p.id, '487265b8-2369-4918-b3b8-79e91698faad');
    expect(p.name, 'أدم عزام الشويكي');
    expect(p.photoUrl, startsWith('https://'));
    expect(p.position, 'ظهير ايسر');
    expect(p.foot, 'يمين');
    expect(p.tps, closeTo(23.52, 0.001));
    expect(p.age, 10);
    expect(p.gender, Gender.male);
    expect(p.hasPhoto, isTrue);
  });

  test('a missing/empty element degrades to empty/null, never throws', () {
    final FavoritePlayer p = FavoritePlayerModel.fromJson(<String, dynamic>{});

    expect(p.id, '');
    expect(p.name, '');
    expect(p.photoUrl, isNull);
    expect(p.hasPhoto, isFalse);
    expect(p.tps, isNull);
    expect(p.gender, isNull);
  });

  test('stringified tps still parses (tolerant)', () {
    final Map<String, dynamic> json = element();
    json['tps'] = '23.52';

    final FavoritePlayer p = FavoritePlayerModel.fromJson(json);

    expect(p.tps, closeTo(23.52, 0.001));
  });
}
