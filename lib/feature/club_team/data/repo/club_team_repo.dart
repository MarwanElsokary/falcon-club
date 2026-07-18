import 'package:falconclubapp/core/networking/api_result.dart';
import 'package:falconclubapp/core/networking/api_error_handler.dart';
import 'package:falconclubapp/core/networking/api_service.dart';

import '../model/player_report_model.dart';

class ClubTeamRepo {
  final ApiService _apiService;

  ClubTeamRepo(this._apiService);

  //clubGetPlayers
  Future<ApiResult> clubGetPlayers() async {
    try {
      final response = await _apiService.clubGetPlayers();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // ── أضف الدالتين دول جوه ClubTeamRepo ───────────────────────────────────────

  Future<ApiResult> getClubTrainees() async {
    try {
      final response = await _apiService.getClubTrainees();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult> deleteTrainee(String playerId) async {
    try {
      final response = await _apiService.deleteTrainee(playerId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //clubGetProfile
  Future<ApiResult> clubGetProfile() async {
    try {
      final response = await _apiService.clubGetProfile();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //getReelsByPlayerId — returns list of thumbnail/video URLs
  Future<ApiResult<List<String>>> getReelsByPlayerId(String playerId) async {
    try {
      final response = await _apiService.getReelsByPlayerId();
      final urls = <String>[];
      if (response is Map<String, dynamic>) {
        final data = response['data'];
        if (data is List) {
          for (final item in data) {
            if (item is Map<String, dynamic>) {
              final url =
                  item['thumbnailUrl'] ??
                  item['videoUrl'] ??
                  item['video'] ??
                  item['photoPath'];
              if (url != null && url.toString().isNotEmpty) {
                urls.add(url.toString());
              }
            } else if (item is String && item.isNotEmpty) {
              urls.add(item);
            }
          }
        }
      }
      return ApiResult.success(urls);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  // endpoint: GET /api/reports/player/{playerId}  ← عدّل حسب الـ API بتاعك

  Future<ApiResult<List<PlayerReport>>> getPlayerReports(
    String playerId,
  ) async {
    try {
      final response = await _apiService.getPlayerReports(playerId);
      final reports = <PlayerReport>[];
      if (response is Map<String, dynamic>) {
        final data = response['data'];
        final list = data is List ? data : [];
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            reports.add(PlayerReport.fromJson(item));
          }
        }
      }
      return ApiResult.success(reports);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
