import 'package:falconclubapp/feature/experiments/data/model/all_trials_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the hardening of `AllTrialsModel.fromJson`: an absent/null/non-list
/// `data` used to throw `NoSuchMethodError` on `.map` and fail the whole
/// experiments screen. It must now degrade to an empty list (→ empty state).
void main() {
  test('parses a normal {message, data:[...]} envelope', () {
    final AllTrialsModel model = AllTrialsModel.fromJson(<String, dynamic>{
      'message': 'ok',
      'data': <dynamic>[
        <String, dynamic>{'id': 1, 'title': 'تجربة'},
      ],
    });

    expect(model.data, hasLength(1));
    expect(model.data.single.title, 'تجربة');
  });

  test('{data: null} degrades to empty, not a crash', () {
    final AllTrialsModel model =
        AllTrialsModel.fromJson(<String, dynamic>{'data': null});

    expect(model.data, isEmpty);
  });

  test('a missing data key is empty, not a crash', () {
    final AllTrialsModel model =
        AllTrialsModel.fromJson(<String, dynamic>{'message': 'x'});

    expect(model.data, isEmpty);
  });

  test('a non-list data is empty, not a crash', () {
    final AllTrialsModel model =
        AllTrialsModel.fromJson(<String, dynamic>{'data': 'nonsense'});

    expect(model.data, isEmpty);
  });

  test('non-object rows are skipped, not thrown on', () {
    final AllTrialsModel model = AllTrialsModel.fromJson(<String, dynamic>{
      'data': <dynamic>[
        'garbage',
        <String, dynamic>{'id': 2, 'title': 'valid'},
      ],
    });

    expect(model.data, hasLength(1));
    expect(model.data.single.title, 'valid');
  });
}
