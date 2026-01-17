import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../data/repo/MeasurementRepo.dart';
import 'measurement_state.dart';

class MeasurementCubit extends Cubit<MeasurementState> {
  final MeasurementRepo _repo;

  MeasurementCubit(this._repo) : super(const MeasurementInitial());

  String imagePath = '';

  // Upload measurement image
  Future<void> uploadMeasurementImage() async {
    if (imagePath.isEmpty) {
      emit(const UploadError('يرجى اختيار صورة أولاً'));
      return;
    }

    emit(const UploadLoading());

    try {
      // Get userId
      final userId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);
      if (userId == null || userId.isEmpty) {
        emit(const UploadError('لم يتم العثور على معرف المستخدم'));
        return;
      }

      // Create form data
      final formData = FormData.fromMap({
        'image': await _createMultipartFile(imagePath),
      });

      // Upload with progress
      final response = await _repo.uploadMeasurementImage(
        formData: formData,
        userId: userId,
        onSendProgress: (sent, total) {
          if (total != 0) {
            final progress = ((sent / total) * 100).toInt();
            emit(UploadProgress(progress));
          }
        },
      );

      response.when(
        success: (measurement) {
          // Check if any critical field is null
          if (measurement.image == null ||
              measurement.heightCm == null ||
              measurement.shoulderWidthCm == null ||
              measurement.avgLegAngle == null) {
            log('⚠️ Warning: Some measurement data is null');
            emit(const UploadError(
              'حدثت مشكلة في تحليل الصورة. يرجى التأكد من:\n'
                  '• وضوح الصورة وجودتها\n'
                  '• وقوف اللاعب بشكل مستقيم\n'
                  '• عدم وجود أشياء أخرى في الصورة',
            ));
            return;
          }

          log('✅ Measurement uploaded successfully');
          emit(UploadSuccess(measurement));
        },
        failure: (error) {
          log('❌ Upload error: ${error.apiErrorModel.message}');
          emit(UploadError(
            error.apiErrorModel.message ?? 'فشل رفع الصورة',
          ));
        },
      );
    } catch (e) {
      log('❌ Exception in uploadMeasurementImage: $e');
      emit(UploadError('حدث خطأ أثناء رفع الصورة: $e'));
    }
  }

  Future<MultipartFile> _createMultipartFile(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw Exception('File does not exist at $imagePath');
    }

    try {
      // Compress image
      final compressedBytes = await _compressImage(file);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/measurement_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await tempFile.writeAsBytes(compressedBytes);

      return MultipartFile.fromFile(
        tempFile.path,
        filename: 'measurement_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
    } catch (e) {
      throw Exception('Error creating image from file: $e');
    }
  }

  Future<List<int>> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 1024,
      minHeight: 1024,
      quality: 85,
    );

    if (result == null) {
      throw Exception('Error compressing image');
    }

    return result;
  }

  void setImagePath(String path) {
    imagePath = path;
    emit(const MeasurementInitial());
  }

  void clearImage() {
    imagePath = '';
    emit(const MeasurementInitial());
  }
}