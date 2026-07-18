import '../../../../core/networking/json.dart';
import '../../../../shared/domain/entities/gender.dart';
import '../../domain/entities/player_profile.dart';

/// Parses `Player/GetProfileById` (a viewed player) into [PlayerProfile].
///
/// ## ✅ Verified against a live capture
///
/// `data = { userId, accountNumber, firstName, lastName, email, phoneNumber,
/// birthDate: "04/02/2016", direction: "يمين", height: 120, weight: 40,
/// photo: url, gender: "ذكر", clubId, clubName: "العلا", clubImage: url,
/// positionName: "راس حربة", tps: 19.4, bioArmLength: null, bioShoulderWidth:
/// null, bioAvgLegAngle: null, bioHeight: null, bioImage: null, isCompleted }`
///
/// * **bio\*** measurements arrive `null` in the sample (no scan has run) — read
///   as nullable doubles.
/// * **birthDate** is a preformatted label, carried through verbatim (no age
///   derived — deferred).
/// * **id** reads `userId`, falling back to `id`, matching the two shapes this
///   endpoint is known to use.
/// * **gender** / **direction** are Arabic labels; gender → [Gender.fromArabic],
///   direction kept raw (display-only).
abstract final class PlayerProfileModel {
  const PlayerProfileModel._();

  static PlayerProfile fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Json.asObject(json['data']);

    return PlayerProfile(
      id: Json.asString(data['userId']) ?? Json.asString(data['id']) ?? '',
      firstName: Json.asString(data['firstName']) ?? '',
      lastName: Json.asString(data['lastName']) ?? '',
      photoUrl: Json.asString(data['photo']),
      gender: Gender.fromArabic(Json.asString(data['gender'])),
      preferredFoot: Json.asString(data['direction']),
      positionName: Json.asString(data['positionName']),
      birthDateLabel: Json.asString(data['birthDate']),
      height: Json.asInt(data['height']),
      weight: Json.asInt(data['weight']),
      measurements: BodyMeasurements(
        height: Json.asNum(data['bioHeight'])?.toDouble(),
        shoulderWidth: Json.asNum(data['bioShoulderWidth'])?.toDouble(),
        armLength: Json.asNum(data['bioArmLength'])?.toDouble(),
        avgLegAngle: Json.asNum(data['bioAvgLegAngle'])?.toDouble(),
      ),
      measurementsImageUrl: Json.asString(data['bioImage']),
      clubName: Json.asString(data['clubName']),
      clubImageUrl: Json.asString(data['clubImage']),
      tps: Json.asNum(data['tps'])?.toDouble(),
      isProfileCompleted: Json.asBool(data['isCompleted']) ?? false,
    );
  }
}
