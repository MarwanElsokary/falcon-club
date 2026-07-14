import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';
import '../models/city_model.dart';
import '../models/club_option_model.dart';

/// Talks to the network for the city → club cascade.
///
/// DIP: declared as an interface so the repository can be tested against a fake
/// with no HTTP client in sight.
abstract interface class ClubDirectoryRemoteDataSource {
  Future<List<CityModel>> fetchCities();

  Future<List<ClubOptionModel>> fetchClubsInCity(String cityId);
}

/// Retrofit-backed implementation.
///
/// It goes through the shared, injected [ApiService] — which means it inherits
/// `DioFactory`'s interceptors, base URL, and timeouts. That is the whole point:
/// nine legacy repositories build their own bare `Dio()` and hand-attach an
/// `Authorization` header, bypassing all of it. None of that happens here.
///
/// Error policy: transport errors (`DioException`) are allowed to propagate and
/// are translated once, centrally, by `ErrorMapper` in the repository. This
/// class throws [AppException] only for *semantic* problems the transport layer
/// cannot see — such as a 200 response with no payload.
@LazySingleton(as: ClubDirectoryRemoteDataSource)
class RetrofitClubDirectoryRemoteDataSource
    implements ClubDirectoryRemoteDataSource {
  const RetrofitClubDirectoryRemoteDataSource(this._apiService);

  final ApiService _apiService;

  /// Both endpoints answer with `{"message": ..., "data": [{"id", "name"}]}`.
  static const String _rowsField = 'data';

  @override
  Future<List<CityModel>> fetchCities() async {
    final List<Map<String, dynamic>> rows = _rowsOf(
      await _apiService.countries(),
    );
    return rows.map(CityModel.fromJson).toList(growable: false);
  }

  @override
  Future<List<ClubOptionModel>> fetchClubsInCity(String cityId) async {
    if (cityId.isEmpty) {
      throw const ServerException(message: FailureMessages.resourceNotFound);
    }
    final List<Map<String, dynamic>> rows = _rowsOf(
      await _apiService.clubsByCountry(cityId),
    );
    return rows.map(ClubOptionModel.fromJson).toList(growable: false);
  }

  List<Map<String, dynamic>> _rowsOf(Object? body) =>
      Json.asObjectList(Json.asObject(body)[_rowsField]);
}
