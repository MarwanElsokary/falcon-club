import 'package:bloc/bloc.dart';
import 'package:falcon/feature/training_details/cubit/training_details_state.dart';
import 'package:video_compress/video_compress.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../data/repo/training_details_repo.dart';

class TrainingDetailsCubit extends Cubit<TrainingDetailsState> {
  final TrainingDetailsRepo _repo;
  TrainingDetailsCubit(this._repo) : super(TrainingDetailsState.initial());
  String videoPath = '';

  // MARK: - exerciseDetails
  void emitexerciseDetails({required String exerciseId}) async {
    emit(const TrainingDetailsState.exerciseDetailsLoading());
    final response = await _repo.exerciseDetails(exerciseId: exerciseId);
    response.when(
      success: (exerciseDetailsResponse) async {
        emit(
          TrainingDetailsState.exerciseDetailssuccess(exerciseDetailsResponse),
        );
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

  // MARK: -emitAddAttemptStates
  void emitAddAttemptStates({required String curexerciseId}) async {
    emit(const TrainingDetailsState.addAttemptLoading());

    try {
      final formData = FormData.fromMap({
        if (videoPath.isNotEmpty) 'Video': await createVideoFromFile(videoPath),
      });

      final response = await _repo.addAttempt(
        exerciseId: curexerciseId,
        addAttemptBody: formData,
        onSendProgress: (sent, total) {
          if (total != 0) {
            final progress = ((sent / total) * 100).toInt();
            emit(TrainingDetailsState.addAttemptProgress(progress));
          }
        },
      );

      response.when(
        success: (data) {
          emit(TrainingDetailsState.addAttemptsuccess());
        },
        failure: (error) {
          final errorMessage =
              error.apiErrorModel.message ?? 'حدث خطأ غير معروف';
          emit(TrainingDetailsState.addAttempterror(error: errorMessage));
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

  // MARK: -createVideoFromFile
  Future<MultipartFile> createVideoFromFile(String videoPath) async {
    final file = File(videoPath);
    if (!await file.exists()) {
      throw Exception('File does not exist at $videoPath');
    }

    try {
      // ضغط الفيديو
      final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false, // false للحفاظ على الفيديو الأصلي
      );

      File uploadFile;

      if (compressedVideo != null && compressedVideo.file != null) {
        uploadFile = compressedVideo.file!;
      } else {
        // لو الضغط فشل، استخدم الفيديو الأصلي
        uploadFile = file;
      }

      // قص اسم الملف لو أكبر من 100 حرف لتجنب رفض السيرفر
      String filename = uploadFile.uri.pathSegments.last;
      if (filename.length > 100) {
        filename = filename.substring(filename.length - 100);
      }

      return await MultipartFile.fromFile(uploadFile.path, filename: filename);
    } catch (e) {
      throw Exception('Error creating video from file: $e');
    }
  }
}
