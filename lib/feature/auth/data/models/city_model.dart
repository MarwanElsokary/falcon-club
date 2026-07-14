import '../../domain/entities/city.dart';

/// DTO ↔ entity boundary for a city.
///
/// SRP: it knows the wire shape. [City] knows nothing about JSON — that is the
/// point of having both. Today the raw API DTO *is* the domain type across
/// 52 UI files; this is where that stops.
///
/// It parses the raw response body directly. Until Phase 7 it mapped from
/// `CountiesList`, the DTO `ApiService.countries()` used to return — which meant
/// `feature/auth` imported `feature/login`, and `core/networking` did too. Both
/// dependencies pointed the wrong way and kept a deleted feature on life support.
final class CityModel {
  const CityModel({required this.id, required this.name});

  final String id;
  final String name;

  /// Both fields are stringified verbatim rather than parsed: the id is passed
  /// straight back to the backend as the `CountryId` query param, so re-typing
  /// it could change the request. A missing id or name degrades to `''` rather
  /// than throwing — a malformed row must not take down the whole dropdown.
  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
    id: json['id']?.toString() ?? '',
    name: json['name']?.toString() ?? '',
  );

  City toEntity() => City(id: id, name: name);
}
