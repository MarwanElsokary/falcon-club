import 'package:bloc/bloc.dart';
import '../data/model/digitalReportModel.dart';
import '../data/repo/digitalReportRepo.dart';

// ── State ─────────────────────────────────────────────────────────────────────
abstract class DigitalReportState {}

class DigitalReportInitial extends DigitalReportState {}

// GET states
class DigitalReportListLoading extends DigitalReportState {}

class DigitalReportListSuccess extends DigitalReportState {
  final List<DigitalReportSummary> reports;

  DigitalReportListSuccess(this.reports);
}

class DigitalReportListError extends DigitalReportState {
  final String error;

  DigitalReportListError(this.error);
}

// POST states
class DigitalReportSubmitting extends DigitalReportState {}

class DigitalReportSubmitSuccess extends DigitalReportState {}

class DigitalReportSubmitError extends DigitalReportState {
  final String error;

  DigitalReportSubmitError(this.error);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────
class DigitalReportCubit extends Cubit<DigitalReportState> {
  final DigitalReportRepo _repo;

  DigitalReportCubit(this._repo) : super(DigitalReportInitial());

  // Cache per playerId
  final Map<String, List<DigitalReportSummary>> _cache = {};

  Future<void> fetchReports(String playerId) async {
    if (_cache.containsKey(playerId)) {
      emit(DigitalReportListSuccess(_cache[playerId]!));
      return;
    }
    emit(DigitalReportListLoading());
    final result = await _repo.getReports(playerId);
    result.when(
      success: (reports) {
        _cache[playerId] = reports;
        emit(DigitalReportListSuccess(reports));
      },
      failure: (err) =>
          emit(DigitalReportListError(err.apiErrorModel.message ?? 'خطأ')),
    );
  }

  Future<void> submitReport(CreateDigitalReportRequest request) async {
    emit(DigitalReportSubmitting());
    final result = await _repo.addReport(request);
    result.when(
      success: (_) {
        // امسح الكاش عشان يتحدث
        _cache.remove(request.playerId);
        emit(DigitalReportSubmitSuccess());
      },
      failure: (err) =>
          emit(DigitalReportSubmitError(err.apiErrorModel.message ?? 'خطأ')),
    );
  }
}
