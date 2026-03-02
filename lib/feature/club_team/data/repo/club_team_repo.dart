import 'package:dio/dio.dart';
import 'package:falcon/core/networking/api_result.dart';
import 'package:falcon/core/networking/api_error_handler.dart';
import 'package:falcon/core/networking/api_service.dart';

class ClubTeamRepo {
  final ApiService _apiService;

  ClubTeamRepo(this._apiService);

  //clubUpdateProfile
  Future<ApiResult> clubUpdateProfile(FormData body) async {
    try {
      final response = await _apiService.clubUpdateProfile(body);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //clubGetPlayers
  Future<ApiResult> clubGetPlayers() async {
    try {
      final response = await _apiService.clubGetPlayers();
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

  //addToFav
  Future<ApiResult> addToFav(String playerId) async {
    try {
      final response = await _apiService.addToFav(playerId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //removeFromFav
  Future<ApiResult> removeFromFav(String playerId) async {
    try {
      final response = await _apiService.removeFromFav(playerId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //getFav — returns raw response; cubit will parse players
  Future<ApiResult> getFav() async {
    try {
      final response = await _apiService.getFav();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  //getReelsByPlayerId — returns list of thumbnail/video URLs
  Future<ApiResult<List<String>>> getReelsByPlayerId(String playerId) async {
    try {
      final response = await _apiService.getReelsByPlayerId(playerId);
      final urls = <String>[];
      if (response is Map<String, dynamic>) {
        final data = response['data'];
        if (data is List) {
          for (final item in data) {
            if (item is Map<String, dynamic>) {
              final url = item['thumbnailUrl'] ??
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
}
