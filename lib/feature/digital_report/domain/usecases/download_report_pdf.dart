import 'package:injectable/injectable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/digital_report.dart';
import '../entities/report_document.dart';
import '../repositories/digital_reports_repository.dart';

/// Fetches one report as a PDF (`Pdf/GetDigitalReportPlayerPdf`).
///
/// Takes the whole report rather than just its id so the repository can name
/// the file after the player when the server sends no `content-disposition`.
@injectable
class DownloadReportPdf implements UseCase<ReportDocument, DigitalReport> {
  const DownloadReportPdf(this._repository);

  final DigitalReportsRepository _repository;

  @override
  ResultFuture<ReportDocument> call(DigitalReport report) =>
      _repository.downloadReportPdf(report);
}
