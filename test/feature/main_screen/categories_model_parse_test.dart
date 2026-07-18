import 'package:falconclubapp/feature/main_screen/data/model/categories_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards two things at once:
/// * the hardened `CategoriesModel.fromJson` (null/non-list `data` → empty
///   filter bar, not a thrown `.map`), and
/// * the newly-typed `CategoriesList` fields (`String?`, tolerantly coerced),
///   which the exercise category filter now depends on.
void main() {
  group('CategoriesModel.fromJson hardening', () {
    test('parses a normal envelope', () {
      final CategoriesModel model = CategoriesModel.fromJson(<String, dynamic>{
        'message': 'ok',
        'data': <dynamic>[
          <String, dynamic>{'id': 1, 'name': 'تسديد', 'icon': 'https://x/i.svg'},
        ],
      });

      expect(model.data, hasLength(1));
    });

    test('{data: null} degrades to an empty list', () {
      final CategoriesModel model =
          CategoriesModel.fromJson(<String, dynamic>{'data': null});

      expect(model.data, isEmpty);
    });

    test('a missing / non-list data is empty, not a crash', () {
      expect(CategoriesModel.fromJson(<String, dynamic>{}).data, isEmpty);
      expect(
        CategoriesModel.fromJson(<String, dynamic>{'data': 5}).data,
        isEmpty,
      );
    });

    test('non-object rows are skipped', () {
      final CategoriesModel model = CategoriesModel.fromJson(<String, dynamic>{
        'data': <dynamic>[
          'garbage',
          <String, dynamic>{'id': '3', 'name': 'حراسة', 'icon': null},
        ],
      });

      expect(model.data, hasLength(1));
    });
  });

  group('CategoriesList typed, tolerant fields', () {
    test('coerces a numeric id to String', () {
      final CategoriesList row = CategoriesList.fromJson(<String, dynamic>{
        'id': 7,
        'name': 'تمرير',
        'icon': 'https://x/pass.svg',
      });

      expect(row.id, '7');
      expect(row.name, 'تمرير');
      expect(row.icon, 'https://x/pass.svg');
    });

    test('a missing field becomes null, never a thrown cast', () {
      final CategoriesList row = CategoriesList.fromJson(<String, dynamic>{});

      expect(row.id, isNull);
      expect(row.name, isNull);
      expect(row.icon, isNull);
    });
  });
}
