import 'package:equatable/equatable.dart';

import '../../domain/entities/digital_report.dart';
import '../../domain/entities/report_document.dart';

enum PlayerReportsStatus { initial, loading, success, failure }

/// One state object rather than a state per event.
///
/// Downloading or deleting a single row must not blank the list, which is what
/// a `Loading` state carrying no data would do. Instead the list stays put and
/// the row in flight is named by [busyReportId].
class PlayerReportsState extends Equatable {
  const PlayerReportsState({
    this.status = PlayerReportsStatus.initial,
    this.reports = const <DigitalReport>[],
    this.errorMessage,
    this.busyReportId,
    this.readyDocument,
    this.actionError,
  });

  final PlayerReportsStatus status;
  final List<DigitalReport> reports;

  /// Why the list itself could not load.
  final String? errorMessage;

  /// The report currently being downloaded or deleted, if any.
  final int? busyReportId;

  /// A freshly downloaded PDF waiting to be handed to the platform. One-shot:
  /// the UI saves it and calls `consumeDocument`.
  final ReportDocument? readyDocument;

  /// A failed download or delete. One-shot, cleared by `consumeActionError`.
  final String? actionError;

  bool get isEmpty =>
      status == PlayerReportsStatus.success && reports.isEmpty;

  bool isBusy(int reportId) => busyReportId == reportId;

  PlayerReportsState copyWith({
    PlayerReportsStatus? status,
    List<DigitalReport>? reports,
    String? errorMessage,
    int? busyReportId,
    ReportDocument? readyDocument,
    String? actionError,
  }) => PlayerReportsState(
    status: status ?? this.status,
    reports: reports ?? this.reports,
    // These four are deliberately not `?? this.x`: each is transient, and every
    // emit states them afresh so a stale spinner or a re-fired snackbar is not
    // possible.
    errorMessage: errorMessage,
    busyReportId: busyReportId,
    readyDocument: readyDocument,
    actionError: actionError,
  );

  @override
  List<Object?> get props => <Object?>[
    status,
    reports,
    errorMessage,
    busyReportId,
    readyDocument,
    actionError,
  ];
}
