import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:falconclubapp/core/cache/cach_Helper.dart';
import 'package:falconclubapp/feature/main_screen/data/model/my_profile_model.dart';
import 'package:flutter/material.dart';

import '../../../core/networking/json.dart';
import '../../main_club/data/model/club_trainee_model.dart';
import '../data/model/club_player_model.dart';
import '../data/repo/club_team_repo.dart';
import 'club_team_state.dart';

class ClubTeamCubit extends Cubit<ClubTeamState> {
  final ClubTeamRepo _repo;

  ClubTeamCubit(this._repo) : super(const ClubTeamState.initial());

  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<bool> show = ValueNotifier(true);
  final GlobalKey<ScaffoldState> sliderDrawerKey = GlobalKey<ScaffoldState>();

  // The self-profile edit form moved to ProfileEditCubit in the profile feature
  // (Phase 3). This cubit no longer owns edit state.

  // grouped players — محتاجينه بس عشان _buildContent يقراه
  Map<String, List<ClubPlayer>> groupedPlayers = {};

  // ============================================================================
  // MY PROFILE
  // ============================================================================
  MyProfileModel? cachedProfile;

  void emitMyProfile() async {
    if (cachedProfile != null) {
      emit(ClubTeamState.myProfilesuccess(cachedProfile!));
      return;
    }
    emit(const ClubTeamState.myProfileloading());
    final response = await _repo.clubGetProfile();
    response.when(
      success: (data) async {
        try {
          MyProfileModel profile;
          if (data is MyProfileModel) {
            profile = data;
          } else if (data is Map<String, dynamic>) {
            profile = MyProfileModel.fromJson(data);
          } else {
            emit(
              const ClubTeamState.myProfileerror(
                error: 'خطأ في تحميل الملف الشخصي',
              ),
            );
            return;
          }
          cachedProfile = profile;
          await CacheHelper.savemyProfile(profile);
          emit(ClubTeamState.myProfilesuccess(profile));
        } catch (e) {
          log('Error parsing club profile: $e');
          emit(
            const ClubTeamState.myProfileerror(
              error: 'خطأ في تحميل الملف الشخصي',
            ),
          );
        }
      },
      failure: (error) {
        emit(
          ClubTeamState.myProfileerror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  // ── أضف جوه ClubTeamCubit ────────────────────────────────────────────────────

  List<ClubTrainee> cachedTrainees = [];

  Future<void> fetchClubTrainees() async {
    emit(const ClubTeamState.clubTraineesLoading());
    final response = await _repo.getClubTrainees();
    response.when(
      success: (data) {
        try {
          final trainees = <ClubTrainee>[];
          List rawList = [];

          if (data is List) {
            rawList = data;
          } else if (data is Map<String, dynamic>) {
            final d = data['data'];
            rawList = d is List ? d : [];
          }

          for (final item in rawList) {
            if (item is Map<String, dynamic>) {
              trainees.add(ClubTrainee.fromJson(item));
            }
          }

          cachedTrainees = trainees;
          emit(ClubTeamState.clubTraineesSuccess(trainees));
        } catch (e) {
          emit(
            const ClubTeamState.clubTraineesError(
              error: 'خطأ في تحميل المدربين',
            ),
          );
        }
      },
      failure: (error) {
        emit(
          ClubTeamState.clubTraineesError(
            error: error.apiErrorModel.message ?? 'فشل جلب المدربين',
          ),
        );
      },
    );
  }

  Future<void> deleteTrainee(String traineeId) async {
    emit(const ClubTeamState.deleteTraineeLoading());
    final response = await _repo.deleteTrainee(traineeId);
    response.when(
      success: (data) {
        cachedTrainees.removeWhere((t) => t.id == traineeId);
        emit(ClubTeamState.deleteTraineeSuccess(message: _messageFrom(data)));
        // نعيد عرض اللستة المحدثة
        emit(ClubTeamState.clubTraineesSuccess(List.from(cachedTrainees)));
      },
      failure: (error) {
        emit(
          ClubTeamState.deleteTraineeError(
            error: error.apiErrorModel.message ?? _deleteFallbackError,
          ),
        );
      },
    );
  }

  /// A connection error carries no response body, so `_serverMessageOr` has
  /// nothing to parse and the message arrives null. The old fallback said
  /// 'فشل حذف المدرب' — but `Club/DeletePlayer` serves both the player roster
  /// and the coaches list, so hardcoding either role is wrong half the time.
  static const String _deleteFallbackError =
      'تعذر تنفيذ العملية، تحقق من الاتصال';

  /// Neutral for the same reason: only used when the server sent no text.
  static const String _deleteFallbackSuccess = 'تمت العملية بنجاح';

  /// The backend's `{"message": "..."}` confirmation, when it sent one.
  static String _messageFrom(dynamic body) {
    if (body is Map) {
      final String? text = Json.asString(body['message']);
      if (text != null) return text;
    }
    return _deleteFallbackSuccess;
  }

  Future<void> deletePlayerFromTeam(String playerId) async {
    emit(const ClubTeamState.deleteTraineeLoading());
    final response = await _repo.deleteTrainee(playerId);
    response.when(
      success: (data) {
        groupedPlayers.forEach((_, list) {
          list.removeWhere((p) => p.id == playerId);
        });
        groupedPlayers.removeWhere((_, list) => list.isEmpty);

        emit(ClubTeamState.deleteTraineeSuccess(message: _messageFrom(data)));
        emit(ClubTeamState.clubPlayerssuccess(Map.from(groupedPlayers)));
      },
      failure: (error) {
        emit(
          ClubTeamState.deleteTraineeError(
            error: error.apiErrorModel.message ?? _deleteFallbackError,
          ),
        );
      },
    );
  }


  // ============================================================================
  // CLUB PLAYERS — fetch every time, no cache
  // ============================================================================
  Future<void> fetchClubPlayers() async {
    log('🔥 fetchClubPlayers called');

    emit(const ClubTeamState.clubPlayersloading());
    await Future.microtask(() {}); // ← ده بيخلي الـ loading يتبني الأول
    final response = await _repo.clubGetPlayers();
    response.when(
      success: (data) {
        try {
          groupedPlayers = _parseAndGroup(data);
          emit(ClubTeamState.clubPlayerssuccess(groupedPlayers));
        } catch (e) {
          log('Error parsing players: $e');
          emit(
            const ClubTeamState.clubPlayerserror(
              error: 'خطأ في تحميل اللاعبين',
            ),
          );
        }
      },
      failure: (error) {
        emit(
          ClubTeamState.clubPlayerserror(
            error: error.apiErrorModel.message ?? 'فشل جلب اللاعبين',
          ),
        );
      },
    );
  }

  Map<String, List<ClubPlayer>> _parseAndGroup(dynamic rawResponse) {
    final allPlayers = <ClubPlayer>[];

    if (rawResponse is Map<String, dynamic>) {
      final dataField = rawResponse['data'];

      if (dataField is Map<String, dynamic>) {
        final byPosition = dataField['playersByPosition'] as List? ?? [];
        for (final group in byPosition) {
          if (group is Map<String, dynamic>) {
            final players = group['players'] as List? ?? [];
            for (final p in players) {
              if (p is Map<String, dynamic>) {
                allPlayers.add(ClubPlayer.fromJson(p));
              }
            }
          }
        }
        final without = dataField['withoutPosition'] as List? ?? [];
        for (final p in without) {
          if (p is Map<String, dynamic>) {
            allPlayers.add(ClubPlayer.fromJson(p));
          }
        }
      } else if (dataField is List) {
        for (final p in dataField) {
          if (p is Map<String, dynamic>) {
            allPlayers.add(ClubPlayer.fromJson(p));
          }
        }
      }
    }

    return _groupBySection(allPlayers);
  }

  Map<String, List<ClubPlayer>> _groupBySection(List<ClubPlayer> players) {
    final result = <String, List<ClubPlayer>>{};
    for (final player in players) {
      final key = _getSectionKey(player.position);
      result.putIfAbsent(key, () => []).add(player);
    }
    return result;
  }

  String _getSectionKey(String position) {
    if (position.contains('حارس')) return 'الحارس';
    if (position.contains('وسط')) return 'خط الوسط';
    if (position.contains('مدافع') || position.contains('ظهير')) {
      return 'الدفاع';
    }
    if (position.contains('هجوم') ||
        position.contains('راس حربة') ||
        position.contains('مهاجم') ||
        position.contains('جناح')) {
      return 'الهجوم';
    }
    return 'أخرى';
  }

  // ============================================================================
  // PLAYER REPORTS — fetch every time, no cache
  // ============================================================================
  Future<void> fetchPlayerReports(String playerId) async {
    emit(const ClubTeamState.playerReportsLoading());
    final result = await _repo.getPlayerReports(playerId);
    result.when(
      success: (reports) {
        emit(ClubTeamState.playerReportsSuccess(reports));
      },
      failure: (error) {
        emit(
          ClubTeamState.playerReportsError(
            error: error.apiErrorModel.message ?? 'فشل تحميل التقارير',
          ),
        );
      },
    );
  }

  // Favourites moved to the dedicated favorites feature (Phase 6). The
  // GetFavPlayers read + ToggleFavPlayer write live on FavoritesCubit over the
  // domain; ClubTeamCubit no longer holds favourites state.

  // ============================================================================
  // DISPOSE
  // ============================================================================
  @override
  Future<void> close() {
    currentIndex.dispose();
    show.dispose();
    return super.close();
  }
}
