import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/repo/creat_real_repo.dart';
import 'creat_real_state.dart';

class CreatRealCubit extends Cubit<CreatRealState> {
  final CreatRealRepo _repo;
  CreatRealCubit(this._repo) : super(CreatRealState.initial());

  String videoPath = '';
  TextEditingController controller = TextEditingController();

  int _uploadProgress = 0;

  Future<void> emitcreatRealStates() async {
    emit(const CreatRealState.creatRealLoading());

    try {
      final formData = FormData.fromMap({
        if (videoPath.isNotEmpty)
          'Video': await MultipartFile.fromFile(
            videoPath,
            filename: videoPath.split('/').last,
          ),
      });

      final response = await _repo.addReel(
        addReelBody: formData,
        description: controller.text,
        onSendProgress: (sent, total) {
          if (total > 0) {
            _uploadProgress = ((sent / total) * 100).toInt();
            emit(
              CreatRealState.creatRealProgress(
                uploadProgress: _uploadProgress,
                isCompressing: false,
                uploadedBytes: sent,
                totalBytes: total,
              ),
            );
          }
        },
      );

      response.when(
        success: (_) {
          emit(const CreatRealState.creatRealsuccess());
        },
        failure: (error) {
          emit(
            CreatRealState.creatRealerror(
              error: error.apiErrorModel.message ?? 'Upload failed',
            ),
          );
        },
      );
    } catch (e) {
      emit(
        CreatRealState.creatRealerror(
          error: 'خطأ أثناء رفع الفيديو: $e',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}
