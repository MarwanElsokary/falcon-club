import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/gender.dart';
import '../../domain/entities/favorite_player.dart';

/// Parses one element of the `Club/GetFavPlayers` **bare array** into a
/// [FavoritePlayer].
///
/// The endpoint returns a top-level `[ {...}, {...} ]` — not `{message, data}`.
/// The data source is what unwraps the array (via `Json.asObjectList`); this
/// maps a single already-unwrapped object. Every field is read tolerantly, so a
/// missing key degrades to null rather than throwing.
abstract final class FavoritePlayerModel {
  const FavoritePlayerModel._();

  static FavoritePlayer fromJson(Map<String, dynamic> json) {
    return FavoritePlayer(
      id: Json.asString(json['id']) ?? '',
      name: Json.asString(json['name']) ?? '',
      photoUrl: Json.asString(json['photoPath']),
      position: Json.asString(json['position']),
      // Arabic label ("يمين"/"يسار"), display-only.
      foot: Json.asString(json['foot']),
      tps: Json.asNum(json['tps'])?.toDouble(),
      age: Json.asInt(json['age']),
      gender: Gender.fromArabic(Json.asString(json['gender'])),
    );
  }
}
