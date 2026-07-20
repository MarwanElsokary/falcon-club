import 'package:fpdart/fpdart.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/digital_report.dart';
import '../entities/report_document.dart';

/// A player's digital reports: list them, download one, delete one.
///
/// Three different controllers back these (`Club/`, `Pdf/`, `Dashboard/`) —
/// that spread is the backend's, and this interface is where it stops being
/// the caller's problem.
abstract interface class DigitalReportsRepository {
  ResultFuture<List<DigitalReport>> getReports(String playerId);

  ResultFuture<ReportDocument> downloadReportPdf(DigitalReport report);

  ResultFuture<Unit> deleteReport(int reportId);
}
