import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/networking/api_service.dart';
import '../../../core/networking/api_error_handler.dart';

part 'scout_state.dart';

class ScoutCubit extends Cubit<ScoutState> {
  final ApiService _apiService;

  ScoutCubit(this._apiService) : super(ScoutInitial());

  // Bottom nav state
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<bool> show = ValueNotifier(true);

  // Cached profile data
  dynamic cachedProfile;

  Future<void> fetchProfile() async {
    emit(ScoutProfileLoading());
    try {
      final response = await _apiService.myProfile();
      cachedProfile = response;
      emit(ScoutProfileSuccess(response));
    } catch (error) {
      final failure = ErrorHandler.handle(error);
      log('❌ Scout profile error: ${failure.apiErrorModel.message}');
      emit(ScoutProfileError(failure.apiErrorModel.message ?? 'فشل تحميل الملف الشخصي'));
    }
  }

  @override
  Future<void> close() {
    currentIndex.dispose();
    show.dispose();
    return super.close();
  }
}
