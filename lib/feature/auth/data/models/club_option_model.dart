import '../../domain/entities/club_option.dart';

/// DTO ↔ entity boundary for a selectable club.
///
/// The [id] carried here is the GUID that `RegisterClub` needs as `ClubId` —
/// the value the app used to collect and then discard (bug B1).
///
/// The endpoint returns the same `{id, name}` rows as the city list, so the
/// parsing mirrors [CityModel]'s exactly.
final class ClubOptionModel {
  const ClubOptionModel({required this.id, required this.name});

  final String id;
  final String name;

  /// Stringified verbatim: the backend keys clubs by GUID, and this value is
  /// sent straight back as `ClubId`. Any re-typing risks corrupting it.
  factory ClubOptionModel.fromJson(Map<String, dynamic> json) => ClubOptionModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
  );

  ClubOption toEntity() => ClubOption(id: id, name: name);
}
