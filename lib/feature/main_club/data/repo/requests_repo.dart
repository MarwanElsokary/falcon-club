import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../model/club_request_model.dart';
import '../model/player_request_model.dart';

class RequestsRepo {
  final ApiService _apiService;

  RequestsRepo(this._apiService);

  // ─── Club ───────────────────────────────────────────
  Future<ApiResult<List<ClubRequestModel>>> getClubRequests() async {
    try {
      final response = await _apiService.getClubRequests();
      final list = (response as List)
          .map((e) => ClubRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> acceptClub(String clubId) async {
    try {
      await _apiService.acceptClub(clubId);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> rejectClub(String clubId) async {
    try {
      await _apiService.rejectClub(clubId);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> deleteClub(String clubId) async {
    try {
      await _apiService.deleteClub(clubId);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  // ─── Player ─────────────────────────────────────────
  Future<ApiResult<List<PlayerRequestModel>>> getPlayerRequests() async {
    try {
      final response = await _apiService.getPlayerRequests();
      final list = (response as List)
          .map((e) => PlayerRequestModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> acceptPlayer(String playerId) async {
    try {
      await _apiService.acceptPlayer(playerId);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> rejectPlayer(String playerId) async {
    try {
      await _apiService.rejectPlayer(playerId);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> deletePlayer(String playerId) async {
    try {
      await _apiService.deletePlayer(playerId);
      return const ApiResult.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}