import '../data/model/club_request_model.dart';
import '../data/model/player_request_model.dart';

abstract class RequestsState {
  const RequestsState();
}

// ─── Fetch States ────────────────────────────────────
class RequestsInitial extends RequestsState {
  const RequestsInitial();
}

class RequestsLoading extends RequestsState {
  const RequestsLoading();
}

class ClubRequestsSuccess extends RequestsState {
  final List<ClubRequestModel> data;
  const ClubRequestsSuccess(this.data);
}

class PlayerRequestsSuccess extends RequestsState {
  final List<PlayerRequestModel> data;
  const PlayerRequestsSuccess(this.data);
}

class RequestsError extends RequestsState {
  final String message;
  const RequestsError(this.message);
}

// ─── Action States ───────────────────────────────────
class RequestActionLoading extends RequestsState {
  const RequestActionLoading();
}

class RequestActionSuccess extends RequestsState {
  const RequestActionSuccess();
}

class RequestActionError extends RequestsState {
  final String message;
  const RequestActionError(this.message);
}