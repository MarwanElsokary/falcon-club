import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../data/repo/training_details_repo.dart';
import 'training_details_state.dart';

class TrainingDetailsCubit extends Cubit<TrainingDetailsState> {
  final TrainingDetailsRepo _repo;
  TrainingDetailsCubit(this._repo) : super(TrainingDetailsState.initial());

  String videoPath = '';

  // ── الـ exerciseId الحالي — بيستخدمه ClubTrainingDetailsScreen ─
  String? currentExerciseId;

  // MARK: - exerciseDetails
  void emitexerciseDetails({required String exerciseId}) async {
    currentExerciseId = exerciseId;
    emit(const TrainingDetailsState.exerciseDetailsLoading());
    final response = await _repo.exerciseDetails(exerciseId: exerciseId);
    response.when(
      success: (data) {
        emit(TrainingDetailsState.exerciseDetailssuccess(data));
      },
      failure: (error) {
        emit(
          TrainingDetailsState.exerciseDetailserror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  // MARK: - emitAddAttemptStates
  void emitAddAttemptStates({required String curexerciseId}) async {
    emit(const TrainingDetailsState.addAttemptLoading());

    try {
      final formData = FormData.fromMap({
        if (videoPath.isNotEmpty)
          'Video': await MultipartFile.fromFile(
            videoPath,
            filename: videoPath.split('/').last,
          ),
      });

      final response = await _repo.addAttempt(
        exerciseId: curexerciseId,
        addAttemptBody: formData,
        onSendProgress: (sent, total) {
          if (total > 0) {
            final progress = ((sent / total) * 100).toInt();
            emit(TrainingDetailsState.addAttemptProgress(progress));
          }
        },
      );

      response.when(
        success: (_) {
          emit(TrainingDetailsState.addAttemptsuccess());
        },
        failure: (error) {
          emit(
            TrainingDetailsState.addAttempterror(
              error: error.apiErrorModel.message ?? 'حدث خطأ غير معروف',
            ),
          );
        },
      );
    } catch (e) {
      emit(
        TrainingDetailsState.addAttempterror(
          error: 'حدث خطأ أثناء رفع الفيديو: $e',
        ),
      );
    }
  }
}