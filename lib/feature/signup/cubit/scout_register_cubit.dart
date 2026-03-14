import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/helpers/app_regex.dart';
import '../../login/data/repos/login_repo.dart';

part 'scout_register_state.dart';

class ScoutRegisterCubit extends Cubit<ScoutRegisterState> {
  final LoginRepo _repo;

  ScoutRegisterCubit(this._repo) : super(ScoutRegisterInitial());

  // ── Form ──────────────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();

  ValueNotifier<bool> showPassword = ValueNotifier(true);
  ValueNotifier<bool> isPhoneAvailable = ValueNotifier(false);

  int gender = -1;
  String imagePath = '';

  final int maxLength = 9;
  final String codeCountry = '+966';

  // ── Validation helpers ───────────────────────────────────────────────────
  bool get isFormValid {
    return firstName.text.trim().isNotEmpty &&
        lastName.text.trim().isNotEmpty &&
        AppRegex.isEmailValid(email.text.trim()) &&
        phone.text.trim().length == maxLength &&
        AppRegex.isPhoneNumberValid(phone.text.trim()) &&
        AppRegex.isPasswordValid(password.text);
  }

  void updatePhoneAvailability() {
    isPhoneAvailable.value = phone.text.length == maxLength;
    emit(ScoutRegisterInitial());
  }

  // ── Register ─────────────────────────────────────────────────────────────
  Future<void> registerScout() async {
    if (!formKey.currentState!.validate()) return;

    emit(ScoutRegisterLoading());

    try {
      final formData = FormData.fromMap({
        'FirstName': firstName.text.trim(),
        'LastName': lastName.text.trim(),
        'Email': email.text.trim(),
        'PhoneNumber': phone.text.trim(),
        'Gender': gender == -1 ? 0 : gender,
        'Password': password.text,
        if (imagePath.isNotEmpty)
          'Photo': await _createMultipartFile(imagePath),
      });

      final response = await _repo.registerScout(formData);

      response.when(
        success: (data) {
          log('✅ Scout registration success');
          emit(ScoutRegisterSuccess(data));
        },
        failure: (error) {
          log('❌ Scout registration error: ${error.apiErrorModel.message}');
          emit(ScoutRegisterError(
            error: error.apiErrorModel.message ?? 'فشل تسجيل الكشاف',
          ));
        },
      );
    } catch (e) {
      log('❌ Scout registration exception: $e');
      emit(ScoutRegisterError(error: 'حدث خطأ غير متوقع'));
    }
  }

  // ── Image helper ─────────────────────────────────────────────────────────
  Future<MultipartFile> _createMultipartFile(String path) async {
    final file = File(path);
    if (!await file.exists()) throw Exception('File not found: $path');

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 800,
      minHeight: 600,
      quality: 80,
    );
    if (compressedBytes == null) throw Exception('Image compression failed');

    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
      '${tempDir.path}/scout_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await tempFile.writeAsBytes(compressedBytes);

    return MultipartFile.fromFile(
      tempFile.path,
      filename: 'scout_photo_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
  }

  @override
  Future<void> close() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    showPassword.dispose();
    isPhoneAvailable.dispose();
    return super.close();
  }
}
