import 'package:falconclubapp/feature/reals/data/model/real_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the hardening of `RealModel.fromJson`:
/// * a null/non-list top-level `data` degrades to an empty feed, and
/// * a reel that arrives **without** a `comments` array must still render —
///   an absent `comments` used to throw and take down the entire feed parse.
void main() {
  Map<String, dynamic> reel({Object? comments}) => <String, dynamic>{
    'id': 1,
    'playerId': 2,
    'video': 'https://x/v.mp4',
    'playerName': 'لاعب',
    if (comments != null) 'comments': comments,
  };

  test('parses a normal feed with comments', () {
    final RealModel model = RealModel.fromJson(<String, dynamic>{
      'data': <dynamic>[
        reel(
          comments: <dynamic>[
            <String, dynamic>{'id': 10, 'description': 'جميل'},
          ],
        ),
      ],
    });

    expect(model.data, hasLength(1));
    expect(model.data.single.comments, hasLength(1));
  });

  test('a reel with no comments array still renders (empty comments)', () {
    final RealModel model = RealModel.fromJson(<String, dynamic>{
      'data': <dynamic>[reel()],
    });

    expect(model.data, hasLength(1));
    expect(model.data.single.comments, isEmpty);
  });

  test('a null comments degrades to empty, not a crash', () {
    final RealModel model = RealModel.fromJson(<String, dynamic>{
      'data': <dynamic>[reel(comments: null)],
    });

    expect(model.data.single.comments, isEmpty);
  });

  test('a null/non-list top-level data is an empty feed', () {
    expect(
      RealModel.fromJson(<String, dynamic>{'data': null}).data,
      isEmpty,
    );
    expect(RealModel.fromJson(<String, dynamic>{}).data, isEmpty);
  });

  test('non-object reels are skipped', () {
    final RealModel model = RealModel.fromJson(<String, dynamic>{
      'data': <dynamic>['garbage', reel()],
    });

    expect(model.data, hasLength(1));
  });
}
