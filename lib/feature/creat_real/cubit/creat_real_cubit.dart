import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';

import '../data/repo/creat_real_repo.dart';
import 'creat_real_state.dart';

class CreatRealCubit extends Cubit<CreatRealState> {
  final CreatRealRepo _repo;
  CreatRealCubit(this._repo) : super(CreatRealState.initial());

  String videoPath = '';
  TextEditingController controller = TextEditingController();

  // متغيرات إضافية لتتبع التقدم
  int _uploadProgress = 0;
  int _compressionProgress = 0;
  // ignore: unused_field
  bool _isCompressing = false;

  // MARK: - Upload Video with Progress
  Future<void> emitcreatRealStates() async {
    emit(const CreatRealState.creatRealLoading());

    try {
      // إنشاء الـ FormData مع الفيديو المضغوط
      final formData = FormData.fromMap({
        if (videoPath.isNotEmpty) 'Video': await createVideoFromFile(videoPath),
      });

      final response = await _repo.addReel(
        addReelBody: formData,
        description: controller.text,
        onSendProgress: (sent, total) {
          if (total > 0) {
            _uploadProgress = ((sent / total) * 100).toInt();
            // إرسال التقدم للـ UI
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
        success: (data) {
          _resetProgress();
          emit(const CreatRealState.creatRealsuccess());
        },
        failure: (error) {
          _resetProgress();
          final errorMessage =
              error.apiErrorModel.message ?? 'حدث خطأ غير معروف';
          emit(CreatRealState.creatRealerror(error: errorMessage));
        },
      );
    } catch (e) {
      _resetProgress();
      emit(
        CreatRealState.creatRealerror(error: 'حدث خطأ أثناء رفع الفيديو: $e'),
      );
    }
  }

  // MARK: - Compress and Create Video File
  Future<MultipartFile> createVideoFromFile(String videoPath) async {
    final file = File(videoPath);

    if (!await file.exists()) {
      throw Exception('الملف غير موجود في: $videoPath');
    }

    try {
      // إرسال حالة الضغط
      emit(
        CreatRealState.creatRealProgress(
          uploadProgress: 0,
          isCompressing: true,
          uploadedBytes: 0,
          totalBytes: 0,
        ),
      );

      // الاشتراك في تقدم الضغط
      final subscription = VideoCompress.compressProgress$.subscribe((
        progress,
      ) {
        _compressionProgress = progress.toInt();
        emit(
          CreatRealState.creatRealProgress(
            uploadProgress: _compressionProgress,
            isCompressing: true,
            uploadedBytes: 0,
            totalBytes: 0,
          ),
        );
      });

      // ضغط الفيديو
      final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        videoPath,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );

      // إلغاء الاشتراك
      subscription.unsubscribe();

      File uploadFile;

      if (compressedVideo != null && compressedVideo.file != null) {
        uploadFile = compressedVideo.file!;
      } else {
        // استخدام الفيديو الأصلي إذا فشل الضغط
        uploadFile = file;
      }

      // تنظيف اسم الملف
      String filename = uploadFile.uri.pathSegments.last;
      if (filename.length > 100) {
        final extension = filename.split('.').last;
        filename = '${filename.substring(0, 95)}.$extension';
      }

      return await MultipartFile.fromFile(uploadFile.path, filename: filename);
    } catch (e) {
      throw Exception('خطأ في معالجة الفيديو: $e');
    }
  }

  // إعادة تعيين التقدم
  void _resetProgress() {
    _uploadProgress = 0;
    _compressionProgress = 0;
    _isCompressing = false;
  }

  // إلغاء الضغط
  Future<void> cancelCompression() async {
    await VideoCompress.cancelCompression();
    _resetProgress();
    emit(const CreatRealState.initial());
  }

  @override
  Future<void> close() {
    controller.dispose();
    VideoCompress.dispose();
    return super.close();
  }
}
