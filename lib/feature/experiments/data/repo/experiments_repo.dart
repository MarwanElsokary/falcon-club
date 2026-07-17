import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:falconclubapp/core/networking/api_result.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_service.dart';
import '../model/all_trials_model.dart';

class ExperimentsRepo {
  final ApiService _apiService;

  ExperimentsRepo(this._apiService);

  Future<ApiResult<AllTrialsModel>> allTrials({
    required String categoryId,
    required String popular,
  }) async {
    try {
      log('🌐 AllTrials FROM API');
      final response = await _apiService.allTrials(categoryId, popular);
      return ApiResult.success(response);
    } on DioException catch (error) {
      // The backend signals "no trials" with HTTP 400 and a body of
      // {"message": "No Trials Found"} — an EMPTY collection, not a failure.
      //
      // Treated as an error, it fell through to the screen's `orElse`, which is
      // the loading spinner — so an empty result looked like a screen stuck
      // loading forever. Surface it as an empty list so the UI can show a proper
      // empty state instead.
      if (_isEmptyCollectionResponse(error)) {
        log('ℹ️ AllTrials EMPTY (400 “No … Found”) — treated as empty list');
        return ApiResult.success(
          AllTrialsModel(message: _serverMessage(error), data: const []),
        );
      }
      log('❌ AllTrials ERROR: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    } catch (error) {
      log('❌ AllTrials ERROR: $error');
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  /// The backend's convention for "this collection is empty" is a **400** whose
  /// body message reads `"No <Something> Found"`. That is distinct from a genuine
  /// bad request (validation, malformed args), which does not match the pattern,
  /// so a real 400 still surfaces as a failure.
  static bool _isEmptyCollectionResponse(DioException error) {
    if (error.response?.statusCode != 400) return false;
    return RegExp(
      r'no\s+.+\s+found',
      caseSensitive: false,
    ).hasMatch(_serverMessage(error));
  }

  static String _serverMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    return '';
  }
}
