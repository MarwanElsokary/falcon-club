import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/digital_report.dart';
import '../../domain/entities/report_document.dart';
import '../../domain/repositories/digital_reports_repository.dart';
import '../datasources/digital_reports_remote_data_source.dart';
import '../models/digital_report_model.dart';

@LazySingleton(as: DigitalReportsRepository)
class DigitalReportsRepositoryImpl implements DigitalReportsRepository {
  const DigitalReportsRepositoryImpl(this._remoteDataSource, this._errorMapper);

  final DigitalReportsRemoteDataSource _remoteDataSource;
  final ErrorMapper _errorMapper;

  @override
  ResultFuture<List<DigitalReport>> getReports(String playerId) async {
    try {
      final List<Map<String, dynamic>> raw = await _remoteDataSource
          .fetchReports(playerId);

      final List<DigitalReport> reports = raw
          .map(DigitalReportModel.fromJson)
          .toList();
      // Newest first. Rows whose date would not parse keep their server order
      // at the end rather than being dropped or sorted arbitrarily.
      reports.sort((DigitalReport a, DigitalReport b) {
        final DateTime? left = a.date;
        final DateTime? right = b.date;
        if (left == null && right == null) return 0;
        if (left == null) return 1;
        if (right == null) return -1;
        return right.compareTo(left);
      });

      return Right<Failure, List<DigitalReport>>(
        List<DigitalReport>.unmodifiable(reports),
      );
    } catch (error) {
      return Left<Failure, List<DigitalReport>>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<ReportDocument> downloadReportPdf(DigitalReport report) async {
    try {
      final PdfPayload payload = await _remoteDataSource.fetchReportPdf(
        report.id,
      );

      return Right<Failure, ReportDocument>(
        ReportDocument(
          fileName: payload.fileName ?? _fallbackName(report),
          bytes: payload.bytes,
        ),
      );
    } catch (error) {
      return Left<Failure, ReportDocument>(_errorMapper.map(error));
    }
  }

  @override
  ResultFuture<Unit> deleteReport(int reportId) async {
    try {
      await _remoteDataSource.deleteReport(reportId);
      return const Right<Failure, Unit>(unit);
    } catch (error) {
      return Left<Failure, Unit>(_errorMapper.map(error));
    }
  }

  /// Used when the server sends no `content-disposition`. Mirrors the server's
  /// own naming (`PlayerDigitalReport_<id>`) and appends the player so a folder
  /// full of these is still readable.
  static String _fallbackName(DigitalReport report) {
    final String player = report.playerName
        .trim()
        .replaceAll(RegExp(r'[^\w؀-ۿ]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    final String suffix = player.isEmpty ? '' : '_$player';
    return 'PlayerDigitalReport_${report.id}$suffix.pdf';
  }
}
