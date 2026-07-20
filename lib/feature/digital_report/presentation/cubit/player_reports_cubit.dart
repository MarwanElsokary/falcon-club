import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/digital_report.dart';
import '../../domain/entities/report_document.dart';
import '../../domain/usecases/delete_digital_report.dart';
import '../../domain/usecases/download_report_pdf.dart';
import '../../domain/usecases/get_player_reports.dart';
import 'player_reports_state.dart';

/// Drives the player's digital-report history.
///
/// Deliberately holds no cache: the previous implementation returned early on a
/// cached playerId, so a report added or deleted in the same session showed a
/// stale list. The sheet is opened on demand and the list is small.
@injectable
class PlayerReportsCubit extends Cubit<PlayerReportsState> {
  PlayerReportsCubit(
    this._getPlayerReports,
    this._downloadReportPdf,
    this._deleteDigitalReport,
  ) : super(const PlayerReportsState());

  final GetPlayerReports _getPlayerReports;
  final DownloadReportPdf _downloadReportPdf;
  final DeleteDigitalReport _deleteDigitalReport;

  String _playerId = '';

  Future<void> load(String playerId) async {
    _playerId = playerId;
    emit(state.copyWith(status: PlayerReportsStatus.loading));

    final Either<Failure, List<DigitalReport>> result = await _getPlayerReports(
      playerId,
    );

    if (isClosed) return;
    emit(
      result.fold(
        (Failure failure) => state.copyWith(
          status: PlayerReportsStatus.failure,
          errorMessage: failure.message,
        ),
        (List<DigitalReport> reports) => state.copyWith(
          status: PlayerReportsStatus.success,
          reports: reports,
        ),
      ),
    );
  }

  Future<void> download(DigitalReport report) async {
    if (state.busyReportId != null) return;
    emit(state.copyWith(busyReportId: report.id));

    final Either<Failure, ReportDocument> result = await _downloadReportPdf(
      report,
    );

    if (isClosed) return;
    emit(
      result.fold(
        (Failure failure) => state.copyWith(actionError: failure.message),
        (ReportDocument document) => state.copyWith(readyDocument: document),
      ),
    );
  }

  Future<void> delete(DigitalReport report) async {
    if (state.busyReportId != null) return;
    emit(state.copyWith(busyReportId: report.id));

    final Either<Failure, Unit> result = await _deleteDigitalReport(report.id);

    if (isClosed) return;

    await result.fold(
      (Failure failure) async {
        emit(state.copyWith(actionError: failure.message));
      },
      (_) async {
        // Drop the row immediately so the list cannot show a report that is
        // already gone, then re-read the server as the source of truth.
        emit(
          state.copyWith(
            reports: state.reports
                .where((DigitalReport r) => r.id != report.id)
                .toList(growable: false),
          ),
        );
        await load(_playerId);
      },
    );
  }

  /// Clears the one-shot document once the UI has saved it. The list's own
  /// error is carried over — only the transient fields are meant to drop.
  void consumeDocument() =>
      emit(state.copyWith(errorMessage: state.errorMessage));

  /// Clears the one-shot error once the UI has shown it.
  void consumeActionError() =>
      emit(state.copyWith(errorMessage: state.errorMessage));
}
