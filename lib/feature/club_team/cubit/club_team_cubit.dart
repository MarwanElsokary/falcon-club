import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:falcon/core/cache/cach_Helper.dart';
import 'package:falcon/feature/main_screen/data/model/my_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

import '../data/model/club_player_model.dart';
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

  // cached data
  MyProfileModel? cachedProfile;
  List<ClubPlayer> cachedPlayers = [];

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
            emit(const ClubTeamState.myProfileerror(error: 'خطأ في تحميل الملف الشخصي'));
            return;
          }
          cachedProfile = profile;
          await CacheHelper.savemyProfile(profile);
          emit(ClubTeamState.myProfilesuccess(profile));
        } catch (e) {
          log('Error parsing club profile: $e');
          emit(const ClubTeamState.myProfileerror(error: 'خطأ في تحميل الملف الشخصي'));
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
  // CLUB PLAYERS
  // ============================================================================
  void emitClubPlayers() async {
    if (cachedPlayers.isNotEmpty) {
      emit(ClubTeamState.clubPlayerssuccess(cachedPlayers));
      return;
    }
    emit(const ClubTeamState.clubPlayersloading());
    final response = await _repo.clubGetPlayers();
    response.when(
      success: (data) {
        try {
          if (data is Map<String, dynamic>) {
            final playersList = data['data'] as List? ?? [];
            cachedPlayers = playersList
                .map((e) => ClubPlayer.fromJson(e as Map<String, dynamic>))
                .toList();
          } else if (data is List) {
            cachedPlayers = data
                .map((e) => ClubPlayer.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        } catch (e) {
          log('Error parsing players: $e');
          cachedPlayers = [];
        }
        emit(ClubTeamState.clubPlayerssuccess(cachedPlayers));
      },
      failure: (error) {
        emit(ClubTeamState.clubPlayerserror(
          error: error.apiErrorModel.message ?? 'فشل جلب اللاعبين',
        ));
      },
    );
  }

  List<ClubPlayer> getPlayersByPosition(String position) {
    return cachedPlayers
        .where((p) => (p.positionName ?? '').toString().contains(position))
        .toList();
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
