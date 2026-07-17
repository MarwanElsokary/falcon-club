import 'package:falconclubapp/feature/rank/data/model/rank_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// The live `GetRankingExercise` response is a **bare array**. The old
/// envelope-only parser threw on it, and the whole rank screen (and the Home
/// top-3) showed a network error. `RankModel.fromResponse` must accept the array
/// — and degrade every "empty" shape to an empty list rather than throwing, so
/// the empty state shows instead of an error.
void main() {
  List<dynamic> players() => <dynamic>[
    <String, dynamic>{
      'id': 'p1',
      'name': 'أحمد',
      'photoPath': 'https://x/a.jpg',
      'tps': 12.5,
      'age': 15,
    },
    <String, dynamic>{
      'id': 'p2',
      'name': 'خالد',
      'photoPath': null,
      'tps': 9,
      'age': 14,
    },
  ];

  group('the real shape — a bare array', () {
    test('parses a non-empty array', () {
      final RankModel model = RankModel.fromResponse(players());

      expect(model.data, hasLength(2));
      expect(model.data.first.name, 'أحمد');
      expect(model.data.first.tps, 12.5);
      expect(model.data.last.tps, 9.0);
    });

    test('an empty array is an empty ranking, not an error', () {
      final RankModel model = RankModel.fromResponse(<dynamic>[]);

      expect(model.data, isEmpty);
    });
  });

  group('also accepts the envelope shape', () {
    test('{message, data:[...]}', () {
      final RankModel model = RankModel.fromResponse(<String, dynamic>{
        'message': 'Success',
        'data': players(),
      });

      expect(model.data, hasLength(2));
      expect(model.message, 'Success');
    });

    test('{data: []} is empty, not an error', () {
      final model = RankModel.fromResponse(<String, dynamic>{'data': <dynamic>[]});

      expect(model.data, isEmpty);
    });

    test('{data: null} degrades to empty, not a crash', () {
      final model = RankModel.fromResponse(<String, dynamic>{'data': null});

      expect(model.data, isEmpty);
    });
  });

  // tps used to be `json["tps"]?.toDouble()`, which throws on a string.
  test('a stringified tps is read, not thrown on', () {
    final RankModel model = RankModel.fromResponse(<dynamic>[
      <String, dynamic>{'id': 'p1', 'name': 'x', 'tps': '8.7'},
    ]);

    expect(model.data.single.tps, 8.7);
  });

  test('an unexpected body type is empty, never a throw', () {
    expect(RankModel.fromResponse(null).data, isEmpty);
    expect(RankModel.fromResponse('nonsense').data, isEmpty);
  });
}
