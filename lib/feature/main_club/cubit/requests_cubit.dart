import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repo/requests_repo.dart';
import 'requests_state.dart';

enum RequestsTab { club, player }

class RequestsCubit extends Cubit<RequestsState> {
  final RequestsRepo _repo;

  RequestsCubit(this._repo) : super(const RequestsInitial());

  RequestsTab activeTab = RequestsTab.club;

  // ─── Fetch ───────────────────────────────────────────
  void switchTab(RequestsTab tab) {
    activeTab = tab;
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    emit(const RequestsLoading());

    if (activeTab == RequestsTab.club) {
      final result = await _repo.getClubRequests();
      result.when(
        success: (data) => emit(ClubRequestsSuccess(data)),
        failure: (error) => emit(
          RequestsError(error.apiErrorModel.message ?? 'فشل تحميل الطلبات'),
        ),
      );
    } else {
      final result = await _repo.getPlayerRequests();
      result.when(
        success: (data) => emit(PlayerRequestsSuccess(data)),
        failure: (error) => emit(
          RequestsError(error.apiErrorModel.message ?? 'فشل تحميل الطلبات'),
        ),
      );
    }
  }

  // ─── Club Actions ────────────────────────────────────
  Future<void> acceptClub(String clubId) async {
    emit(const RequestActionLoading());
    final result = await _repo.acceptClub(clubId);
    result.when(
      success: (_) {
        emit(const RequestActionSuccess());
        fetchRequests(); // refresh الليست
      },
      failure: (error) => emit(
        RequestActionError(error.apiErrorModel.message ?? 'فشل قبول النادي'),
      ),
    );
  }

  Future<void> rejectClub(String clubId) async {
    emit(const RequestActionLoading());
    final result = await _repo.rejectClub(clubId);
    result.when(
      success: (_) {
        emit(const RequestActionSuccess());
        fetchRequests();
      },
      failure: (error) => emit(
        RequestActionError(error.apiErrorModel.message ?? 'فشل رفض النادي'),
      ),
    );
  }

  Future<void> deleteClub(String clubId) async {
    emit(const RequestActionLoading());
    final result = await _repo.deleteClub(clubId);
    result.when(
      success: (_) {
        emit(const RequestActionSuccess());
        fetchRequests();
      },
      failure: (error) => emit(
        RequestActionError(error.apiErrorModel.message ?? 'فشل حذف النادي'),
      ),
    );
  }

  // ─── Player Actions ──────────────────────────────────
  Future<void> acceptPlayer(String playerId) async {
    emit(const RequestActionLoading());
    final result = await _repo.acceptPlayer(playerId);
    result.when(
      success: (_) {
        emit(const RequestActionSuccess());
        fetchRequests();
      },
      failure: (error) => emit(
        RequestActionError(error.apiErrorModel.message ?? 'فشل قبول اللاعب'),
      ),
    );
  }

  Future<void> rejectPlayer(String playerId) async {
    emit(const RequestActionLoading());
    final result = await _repo.rejectPlayer(playerId);
    result.when(
      success: (_) {
        emit(const RequestActionSuccess());
        fetchRequests();
      },
      failure: (error) => emit(
        RequestActionError(error.apiErrorModel.message ?? 'فشل رفض اللاعب'),
      ),
    );
  }

  Future<void> deletePlayer(String playerId) async {
    emit(const RequestActionLoading());
    final result = await _repo.deletePlayer(playerId);
    result.when(
      success: (_) {
        emit(const RequestActionSuccess());
        fetchRequests();
      },
      failure: (error) => emit(
        RequestActionError(error.apiErrorModel.message ?? 'فشل حذف اللاعب'),
      ),
    );
  }
}