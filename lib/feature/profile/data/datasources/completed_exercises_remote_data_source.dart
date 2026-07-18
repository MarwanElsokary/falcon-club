import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';

/// Transport for the completed-exercises list. `Player/GetPlayerExercises`
/// returns the standard `{ message, data: [ … ] }` envelope, so this unwraps
/// `data` into a list of objects; mapping to entities lives in the repository.
abstract interface class CompletedExercisesRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchPlayerExercises(String playerId);
}

@LazySingleton(as: CompletedExercisesRemoteDataSource)
class RetrofitCompletedExercisesRemoteDataSource
    implements CompletedExercisesRemoteDataSource {
  const RetrofitCompletedExercisesRemoteDataSource(this._apiService);

  final ApiService _apiService;

  @override
  Future<List<Map<String, dynamic>>> fetchPlayerExercises(
    String playerId,
  ) async {
    // A blank id would ask for "exercises of nobody". Refuse before the wire.
    if (playerId.isEmpty) {
      throw const ServerException(message: FailureMessages.resourceNotFound);
    }
    final Map<String, dynamic> body = Json.asObject(
      await _apiService.getPlayerExercises(playerId),
    );
    return Json.asObjectList(body['data']);
  }
}
