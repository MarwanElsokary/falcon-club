import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/networking/api_constants.dart';
import '../../../../core/networking/api_service.dart';
import '../../../../core/networking/json.dart';

/// A PDF exactly as the server sent it: the bytes, plus whatever name the
/// `content-disposition` header carried (null when it carried none).
class PdfPayload {
  const PdfPayload({required this.bytes, this.fileName});

  final List<int> bytes;
  final String? fileName;
}

/// The one place the digital-reports feature talks to the network.
abstract interface class DigitalReportsRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchReports(String playerId);

  Future<PdfPayload> fetchReportPdf(int reportId);

  Future<void> deleteReport(int reportId);
}

/// The list and the delete go through the shared retrofit [ApiService]; the PDF
/// does not, because it is binary and needs `ResponseType.bytes` plus access to
/// the response headers. It uses the same injected [Dio] the service is built
/// on, so it inherits the auth interceptor rather than re-attaching the token
/// by hand the way the old repository did.
///
/// That shared [Dio] carries **no `baseUrl`**: retrofit holds the base in its
/// own `@RestApi` annotation and combines it per call, so the instance itself
/// never needs one. Anything bypassing retrofit — this PDF request — must
/// therefore pass an absolute URL, or Dio sends a hostless path and fails with
/// a bare `DioExceptionType.unknown`.
@LazySingleton(as: DigitalReportsRemoteDataSource)
class RetrofitDigitalReportsRemoteDataSource
    implements DigitalReportsRemoteDataSource {
  const RetrofitDigitalReportsRemoteDataSource(this._apiService, this._dio);

  final ApiService _apiService;
  final Dio _dio;

  @override
  Future<List<Map<String, dynamic>>> fetchReports(String playerId) async {
    if (playerId.isEmpty) {
      throw const ServerException(message: FailureMessages.resourceNotFound);
    }
    // A bare array, like GetFavPlayers. `asObjectList` throws on anything else
    // rather than returning empty — the old repository swallowed unexpected
    // shapes into `success([])`, which read as "this player has no reports".
    return Json.asObjectList(
      await _apiService.getPlayerDigitalReports(playerId),
    );
  }

  /// Absolute, for the reason given on the class. Exposed so a test can assert
  /// it still carries a host.
  static String get pdfUrl =>
      '${ApiConstants.apiBaseUrl}${ApiConstants.digitalReportPdf}';

  @override
  Future<PdfPayload> fetchReportPdf(int reportId) async {
    final Response<List<int>> response = await _dio.get<List<int>>(
      pdfUrl,
      queryParameters: <String, dynamic>{'id': reportId},
      options: Options(
        responseType: ResponseType.bytes,
        // The endpoint answers with a PDF, not JSON; asking for JSON back has
        // servers 406 the request.
        headers: <String, dynamic>{'Accept': 'application/pdf'},
      ),
    );

    final List<int>? bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw const ServerException(
        message: FailureMessages.unexpectedServerResponse,
      );
    }

    return PdfPayload(
      bytes: bytes,
      fileName: _fileNameFrom(response.headers.value('content-disposition')),
    );
  }

  @override
  Future<void> deleteReport(int reportId) async {
    // Success is a 200 with an empty body — nothing to read back.
    await _apiService.deleteDigitalReport(reportId);
  }

  /// Pulls the filename out of a `content-disposition` header.
  ///
  /// Handles both `filename="x.pdf"` and RFC 5987's `filename*=UTF-8''x.pdf`,
  /// preferring the latter when both are present since it is the encoded one.
  static String? _fileNameFrom(String? header) {
    if (header == null || header.isEmpty) return null;

    final RegExpMatch? extended = RegExp(
      r"filename\*\s*=\s*[^']*''([^;]+)",
      caseSensitive: false,
    ).firstMatch(header);
    if (extended != null) {
      final String? value = extended.group(1);
      if (value != null && value.trim().isNotEmpty) {
        return Uri.decodeComponent(value.trim());
      }
    }

    final RegExpMatch? plain = RegExp(
      r'filename\s*=\s*"?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(header);
    final String? value = plain?.group(1)?.trim();
    return (value == null || value.isEmpty) ? null : value;
  }
}
