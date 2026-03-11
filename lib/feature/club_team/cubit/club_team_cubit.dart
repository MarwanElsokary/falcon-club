import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:falcon/core/cache/cach_Helper.dart';
import 'package:falcon/feature/main_screen/data/model/my_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

import '../data/model/club_player_model.dart';
import '../data/model/player_report_model.dart';
import '../data/repo/club_team_repo.dart';
import 'club_team_state.dart';

class ClubTeamCubit extends Cubit<ClubTeamState> {
  final ClubTeamRepo _repo;

  ClubTeamCubit(this._repo) : super(const ClubTeamState.initial());

  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<bool> show = ValueNotifier(true);
  final GlobalKey<ScaffoldState> sliderDrawerKey = GlobalKey<ScaffoldState>();

  // profile form
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  int gender = -1;
  String imagePath = '';

  // cached profile
  MyProfileModel? cachedProfile;

  // Grouped players: sectionKey → list of players
  // Keys follow fixed order: 'الحارس', 'الدفاع', 'خط الوسط', 'الهجوم', 'أخرى'
  Map<String, List<ClubPlayer>> cachedGroupedPlayers = {};
  bool _playersFetched = false;
  // أضف في ClubTeamCubit

  // Reports cache: playerId → list of reports
  final Map<String, List<PlayerReport>> _reportsCache = {};

  Future<void> fetchPlayerReports(String playerId) async {
    if (_reportsCache.containsKey(playerId)) {
      emit(ClubTeamState.playerReportsSuccess(_reportsCache[playerId]!));
      return;
    }
    emit(const ClubTeamState.playerReportsLoading());
    final result = await _repo.getPlayerReports(playerId);
    result.when(
      success: (reports) {
        _reportsCache[playerId] = reports;
        emit(ClubTeamState.playerReportsSuccess(reports));
      },
      failure: (error) {
        emit(ClubTeamState.playerReportsError(
          error: error.apiErrorModel.message ?? 'فشل تحميل التقارير',
        ));
      },
    );
  }

  /// Force re-fetch and re-group players (clears cache)
  void invalidatePlayersCache() {
    _playersFetched = false;
    cachedGroupedPlayers = {};
  }

  // Reels cache: playerId → list of thumbnail/video URLs
  final Map<String, List<String>> _reelsCache = {};

  // ============================================================================
  // MY PROFILE
  // ============================================================================
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
            emit(const ClubTeamState.myProfileerror(
                error: 'خطأ في تحميل الملف الشخصي'));
            return;
          }
          cachedProfile = profile;
          await CacheHelper.savemyProfile(profile);
          emit(ClubTeamState.myProfilesuccess(profile));
        } catch (e) {
          log('Error parsing club profile: $e');
          emit(const ClubTeamState.myProfileerror(
              error: 'خطأ في تحميل الملف الشخصي'));
        }
      },
      failure: (error) {
        emit(ClubTeamState.myProfileerror(
          error: error.apiErrorModel.message ?? '',
        ));
      },
    );
  }

  void initProfileForm() {
    final profile = cachedProfile ?? CacheHelper.getmyProfile();
    if (profile != null) {
      firstNameController.text = profile.data.firstName ?? '';
      lastNameController.text = profile.data.lastName ?? '';
      phoneController.text = profile.data.phoneNumber ?? '';
      gender = profile.data.gender is int ? profile.data.gender : -1;
    }
  }

  // ============================================================================
  // UPDATE PROFILE
  // ============================================================================
  Future<void> emitUpdateProfile() async {
    if (!formKey.currentState!.validate()) return;

    emit(const ClubTeamState.updateProfileloading());

    final Map<String, dynamic> formMap = {
      "FirstName": firstNameController.text,
      "LastName": lastNameController.text,
      "PhoneNumber": phoneController.text,
      "Gender": gender == -1 ? 0 : gender,
    };

    if (imagePath.isNotEmpty) {
      formMap['Photo'] = await MultipartFile.fromFile(
        imagePath,
        filename: 'photo.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
    }

    final response = await _repo.clubUpdateProfile(FormData.fromMap(formMap));
    response.when(
      success: (data) {
        cachedProfile = null;
        emit(ClubTeamState.updateProfilesuccess(data));
        emitMyProfile();
      },
      failure: (error) {
        emit(ClubTeamState.updateProfileerror(
          error: error.apiErrorModel.message ?? 'فشل تحديث الملف الشخصي',
        ));
      },
    );
  }

  // ============================================================================
  // CLUB PLAYERS — fetch once, group by position section, cache
  // ============================================================================
  Future<void> fetchClubPlayers() async {
    if (_playersFetched) {
      emit(ClubTeamState.clubPlayerssuccess(cachedGroupedPlayers));
      return;
    }
    emit(const ClubTeamState.clubPlayersloading());
    final response = await _repo.clubGetPlayers();
    response.when(
      success: (data) {
        try {
          cachedGroupedPlayers = _parseAndGroup(data);
          _playersFetched = true;
          emit(ClubTeamState.clubPlayerssuccess(cachedGroupedPlayers));
        } catch (e) {
          log('Error parsing players: $e');
          emit(const ClubTeamState.clubPlayerserror(
              error: 'خطأ في تحميل اللاعبين'));
        }
      },
      failure: (error) {
        emit(ClubTeamState.clubPlayerserror(
          error: error.apiErrorModel.message ?? 'فشل جلب اللاعبين',
        ));
      },
    );
  }

  Map<String, List<ClubPlayer>> _parseAndGroup(dynamic rawResponse) {
    final allPlayers = <ClubPlayer>[];

    if (rawResponse is Map<String, dynamic>) {
      final dataField = rawResponse['data'];

      if (dataField is Map<String, dynamic>) {
        // New API: { data: { playersByPosition: [...], withoutPosition: [] } }
        final byPosition =
            dataField['playersByPosition'] as List? ?? [];
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
        // Also include withoutPosition players
        final without = dataField['withoutPosition'] as List? ?? [];
        for (final p in without) {
          if (p is Map<String, dynamic>) {
            allPlayers.add(ClubPlayer.fromJson(p));
          }
        }
      } else if (dataField is List) {
        // Fallback: old flat list format
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
    // وسط must be checked BEFORE مدافع so that "وسط مدافع" → خط الوسط, not الدفاع
    if (position.contains('وسط')) return 'خط الوسط';
    if (position.contains('مدافع') || position.contains('ظهير')) {
      return 'الدفاع';
    }
    if (position.contains('هجوم') ||
        position.contains('راس حربة') ||
        position.contains('مهاجم') ||
        position.contains('جناح')) return 'الهجوم';
    return 'أخرى';
  }

  // ============================================================================
  // FAVORITES — fetch list, toggle (add/remove), local Set cache
  // ============================================================================
  Set<String> favoritedPlayerIds = {};
  List<ClubPlayer> cachedFavPlayers = [];

  bool isFavorited(String playerId) => favoritedPlayerIds.contains(playerId);

  Future<void> fetchFavorites() async {
    emit(const ClubTeamState.favloading());
    final response = await _repo.getFav();
    response.when(
      success: (data) {
        try {
          final players = <ClubPlayer>[];
          if (data is Map<String, dynamic>) {
            final raw = data['data'];
            final list = raw is List ? raw : (raw is Map ? [raw] : []);
            for (final p in list) {
              if (p is Map<String, dynamic>) players.add(ClubPlayer.fromJson(p));
            }
          } else if (data is List) {
            for (final p in data) {
              if (p is Map<String, dynamic>) players.add(ClubPlayer.fromJson(p));
            }
          }
          cachedFavPlayers = players;
          favoritedPlayerIds = players.map((p) => p.id).toSet();
          emit(ClubTeamState.favsuccess(players));
        } catch (e) {
          log('Error parsing favorites: $e');
          emit(const ClubTeamState.faverror(error: 'خطأ في تحميل المفضلة'));
        }
      },
      failure: (error) {
        emit(ClubTeamState.faverror(
          error: error.apiErrorModel.message ?? 'فشل جلب المفضلة',
        ));
      },
    );
  }

  Future<void> toggleFavorite(String playerId) async {
    if (isFavorited(playerId)) {
      // Remove
      favoritedPlayerIds.remove(playerId);
      cachedFavPlayers.removeWhere((p) => p.id == playerId);
      final response = await _repo.removeFromFav(playerId);
      response.when(
        success: (_) => emit(const ClubTeamState.removeFavsuccess()),
        failure: (error) {
          // Revert optimistic update on failure
          favoritedPlayerIds.add(playerId);
          emit(ClubTeamState.removeFaverror(
            error: error.apiErrorModel.message ?? 'فشل إزالة اللاعب من المفضلة',
          ));
        },
      );
    } else {
      // Add
      favoritedPlayerIds.add(playerId);
      final response = await _repo.addToFav(playerId);
      response.when(
        success: (_) => emit(const ClubTeamState.addFavsuccess()),
        failure: (error) {
          // Revert optimistic update on failure
          favoritedPlayerIds.remove(playerId);
          emit(ClubTeamState.addFaverror(
            error: error.apiErrorModel.message ?? 'فشل إضافة اللاعب للمفضلة',
          ));
        },
      );
    }
  }

  // ============================================================================
  // REELS PER PLAYER — cached per playerId
  // ============================================================================
  Future<List<String>> getReelsForPlayer(String playerId) async {
    if (_reelsCache.containsKey(playerId)) return _reelsCache[playerId]!;
    final result = await _repo.getReelsByPlayerId(playerId);
    return result.when(
      success: (urls) {
        _reelsCache[playerId] = urls;
        return urls;
      },
      failure: (_) {
        _reelsCache[playerId] = [];
        return <String>[];
      },
    );
  }

  @override
  Future<void> close() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    currentIndex.dispose();
    show.dispose();
    return super.close();
  }
}
