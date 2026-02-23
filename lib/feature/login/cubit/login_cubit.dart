import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/networking/dio_factory.dart';
import '../controller/login_controllers.dart';
import '../data/model/country_model.dart';
import '../data/repos/login_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  final LoginControllers controller = LoginControllers();

  LoginCubit(this._loginRepo) : super(const LoginState.initial());

  // Form keys
  final formKey = GlobalKey<FormState>();
  final loginformKey = GlobalKey<FormState>();

  // UI State (kept for backward compatibility with existing widgets)
  ValueNotifier<bool> showPassword = ValueNotifier(true);
  ValueNotifier<int> positionID = ValueNotifier(-1);
  ValueNotifier<String> positionName = ValueNotifier('');

  // Auth state
  int maxLength = 9;
  String codeCountry = '+966';
  bool isAvailable = false;
  List<String> termsAndPolicies = [];


  // Profile data
  int direction = 0;
  String? selectedDirection;
  int gender = -1;
  String birthDate = '';
  String imagePath = '';

  // Location data
  List<CountiesList> universityList = [];
  List<CountiesList> collegesList = [];
  List<CountiesList> departmentsList = [];

  String? selectedUniversity;
  int? selectedUniversityId;
  String? selectedColleges;
  int? selectedCollegesId;
  String? selectedDepartments;
  int? selectedDepartmentsId;

  // ============================================================================
  // AUTH METHODS
  // ============================================================================

  // New method name
  Future<void> login() async {
    if (!loginformKey.currentState!.validate()) return;
    emit(const LoginState.loading());

    final response = await _loginRepo.login(
      FormData.fromMap({
        "PlayerId": '${controller.email.text}Id',
        "Email": controller.email.text,
        "Password": controller.password.text,
      }),
    );

    response.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(LoginState.success(data));
      },
      failure: (error) {
        emit(LoginState.error(error: error.apiErrorModel.message ?? 'فشل تسجيل الدخول'));
      },
    );
  }

  // Old method name for backward compatibility
  void emitloginStates() => login();

  // New method name
  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    emit(const LoginState.registerloading());

    final response = await _loginRepo.register(
      FormData.fromMap({
        "PlayerId": "PlayerId",
        "FirstName": controller.name.text,
        "LastName": controller.lastName.text,
        "PhoneNumber": controller.phone.text,
        "Email": controller.email.text,
        "CodePhoneNumber": codeCountry,
        "Password": controller.password.text,
        if (imagePath.isNotEmpty) 'Photo': await _createMultipartFile(imagePath),
      }),
    );

    response.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(LoginState.registersuccess(data));
      },
      failure: (error) {
        emit(LoginState.registererror(error: error.apiErrorModel.message ?? 'فشل التسجيل'));
      },
    );
  }

  // Old method name for backward compatibility
  void emitregisterStates() => register();

  // ============================================================================
  // CLUB REGISTRATION
  // ============================================================================

  Future<void> registerClub() async {
    if (!formKey.currentState!.validate()) return;

    // Validate club-specific fields
    if (selectedUniversityId == null) {
      emit(const LoginState.registererror(error: 'يرجى اختيار المدينة'));
      return;
    }
    if (selectedCollegesId == null) {
      emit(const LoginState.registererror(error: 'يرجى اختيار النادي'));
      return;
    }

    emit(const LoginState.registerloading());

    final response = await _loginRepo.registerClub(
      FormData.fromMap({
        "PlayerId": "ClubId",
        "FirstName": controller.name.text,
        "LastName": controller.lastName.text,
        "Email": controller.email.text,
        "PhoneNumber": controller.phone.text,
        "Gender": gender == -1 ? 0 : gender,
        "Password": controller.password.text,
        if (imagePath.isNotEmpty) 'Photo': await _createMultipartFile(imagePath),
      }),
    );

    response.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(LoginState.registersuccess(data));
      },
      failure: (error) {
        emit(LoginState.registererror(
          error: error.apiErrorModel.message ?? 'فشل تسجيل النادي',
        ));
      },
    );
  }

  // New method name
  Future<void> verifyOtp() async {
    final code = controller.verifyCode.text.trim();
    if (code.isEmpty) {
      emit(const LoginState.verificationCodeerror(error: 'يجب إدخال كود التحقق'));
      return;
    }

    if (code.length != 6) {
      emit(const LoginState.verificationCodeerror(error: 'يجب إدخال 6 أرقام'));
      return;
    }

    emit(const LoginState.verificationCodeloading());

    final response = await _loginRepo.otp(int.parse(code));

    response.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(LoginState.verificationCodesuccess(data));
      },
      failure: (error) {
        emit(LoginState.verificationCodeerror(
          error: error.apiErrorModel.message ?? 'كود التحقق غير صحيح',
        ));
      },
    );
  }

  // أضف هذه الدالة
  Future<void> getTermsAndPolicies() async {
    final result = await _loginRepo.getTermsAndPolicies();
    result.when(
      success: (data) {
        if (data is List) {
          termsAndPolicies = List<String>.from(data);
        } else if (data is String) {
          termsAndPolicies = [data];
        }
      },
      failure: (error) {
        print('Failed to load terms and policies: $error');
      },
    );
  }
  // Old method name for backward compatibility
  Future<void> emitverifyCodeStates() async => await verifyOtp();

  // ============================================================================
  // COMPLETE REGISTRATION (Step 2)
  // ============================================================================

  Future<void> completeRegistration() async {
    // Validation
    final validationError = _validateProfileData();
    if (validationError != null) {
      emit(LoginState.updateProfileerror(error: validationError));
      return;
    }

    emit(const LoginState.updateProfileLoading());

    // Get userId
    final userId = await _getUserId();
    if (userId == null) {
      emit(const LoginState.updateProfileerror(
        error: 'لم يتم العثور على معرف المستخدم. يرجى إعادة تسجيل الدخول',
      ));
      return;
    }

    final formData = FormData.fromMap({
      'UserId': userId,
      'Height': double.tryParse(controller.height.text) ?? 0.0,
      'Weight': double.tryParse(controller.weight.text) ?? 0.0,
      'PositionId': positionID.value,
      'Direction': direction,
      'BirthDate': birthDate,
      'Gender': gender,
      'BranchId': selectedUniversityId ?? 0,
      'ClubId': selectedCollegesId ?? 0,
      'ClubJoin': DateTime.now().toIso8601String(),
      if (imagePath.isNotEmpty) 'Photo': await _createMultipartFile(imagePath),
    });

    log('📤 Complete Registration - UserId: $userId');

    final response = await _loginRepo.completeRegistration(formData);

    response.when(
      success: (data) async {
        await SharedPrefHelper.setBool(SharedPrefKeys.isCompleted, true);
        log('✅ Complete Registration Success');
        emit(LoginState.updateProfilesuccess(data));
      },
      failure: (error) {
        log('❌ Complete Registration Error: ${error.apiErrorModel.message}');
        emit(LoginState.updateProfileerror(
          error: error.apiErrorModel.message ?? 'خطأ في إكمال التسجيل',
        ));
      },
    );
  }

  // Old method name for backward compatibility
  void emitCompleteRegistration() => completeRegistration();

  // ============================================================================
  // PROFILE UPDATE (Existing users)
  // ============================================================================

  Future<void> updateProfile() async {
    emit(const LoginState.updateProfileLoading());

    final response = await _loginRepo.updateProfile(
      FormData.fromMap({
        if (controller.height.text.isNotEmpty) "Height": controller.height.text,
        if (controller.weight.text.isNotEmpty) "Weight": controller.weight.text,
        "PositionId": positionID.value.toString(),
        "Direction": direction.toString(),
        "BirthDate": birthDate,
        if (gender != -1) "Gender": gender.toString(),
        if (selectedCollegesId != null) "ClubId": selectedCollegesId.toString(),
        if (selectedUniversityId != null) "UniversityId": selectedUniversityId.toString(),
        if (imagePath.isNotEmpty) 'Photo': await _createMultipartFile(imagePath),
      }),
    );

    response.when(
      success: (data) => emit(LoginState.updateProfilesuccess(data)),
      failure: (error) => emit(LoginState.updateProfileerror(
        error: error.apiErrorModel.message ?? 'فشل تحديث الملف الشخصي',
      )),
    );
  }

  // Old method name for backward compatibility
  void emitupdateProfileStates() => updateProfile();

  // ============================================================================
  // LOCATION DATA
  // ============================================================================

  Future<void> loadCountries() async {
    emit(const LoginState.universityloading());

    final response = await _loginRepo.countries();

    response.when(
      success: (data) {
        universityList = data.data;
        emit(const LoginState.universitysuccess());
      },
      failure: (error) {
        emit(LoginState.universityerror(
          error: error.apiErrorModel.message ?? 'فشل تحميل المدن',
        ));
      },
    );
  }

  // Old method name for backward compatibility
  void emitcountries() => loadCountries();

  Future<void> loadClubsByCountry(String countryId) async {
    emit(const LoginState.collegesloading());

    final response = await _loginRepo.clubsByCountry(countryId: countryId);

    response.when(
      success: (data) {
        collegesList = data.data;

        // إذا كانت القائمة فارغة، اعرض رسالة للمستخدم
        if (collegesList.isEmpty) {
          log('⚠️ No clubs found for country: $countryId');
          emit(const LoginState.collegeserror(
            error: 'لا توجد أندية متاحة في هذه المدينة حالياً',
          ));
        } else {
          emit(const LoginState.collegessuccess());
        }
      },
      failure: (error) {
        emit(LoginState.collegeserror(
          error: error.apiErrorModel.message ?? 'فشل تحميل الأندية',
        ));
      },
    );
  }

  // Old method name for backward compatibility
  void emitclubsByCountry({required String countryId}) => loadClubsByCountry(countryId);

  // ============================================================================
  // VALIDATION & HELPER METHODS
  // ============================================================================

  String? _validateProfileData() {
    if (controller.height.text.isEmpty) return 'يرجى إدخال الطول';
    if (controller.weight.text.isEmpty) return 'يرجى إدخال الوزن';
    if (positionID.value == -1) return 'يرجى اختيار المركز';
    if (direction == 2 || direction == -1) return 'يرجى اختيار القدم المفضلة';
    if (birthDate.isEmpty) return 'يرجى اختيار تاريخ الميلاد';
    if (gender == -1) return 'يرجى اختيار الجنس';
    if (selectedUniversityId == null) return 'يرجى اختيار المدينة';
    if (selectedCollegesId == null) return 'يرجى اختيار النادي';
    return null;
  }

  Future<String?> _getUserId() async {
    // Try from SharedPreferences first
    String? userId = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userId);

    if (userId != null && userId.isNotEmpty && _isValidGuid(userId)) {
      return userId;
    }

    // Try from token
    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    if (token != null && token.isNotEmpty) {
      userId = _extractUserIdFromToken(token);
      if (userId != null && _isValidGuid(userId)) {
        await SharedPrefHelper.setSecuredString(SharedPrefKeys.userId, userId);
        return userId;
      }
    }

    // Last resort: fetch from API
    final response = await _loginRepo.getCurrentUser();
    String? apiUserId;

    response.when(
      success: (data) {
        apiUserId = data['userId']?.toString() ??
            data['id']?.toString() ??
            data['uid']?.toString();
      },
      failure: (error) => log('❌ Error fetching current user: ${error.apiErrorModel.message}'),
    );

    if (apiUserId != null && _isValidGuid(apiUserId!)) {
      await SharedPrefHelper.setSecuredString(SharedPrefKeys.userId, apiUserId!);
      return apiUserId;
    }

    return null;
  }

  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payloadJson = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payload = json.decode(payloadJson);

      return payload['uid']?.toString() ??
          payload['userId']?.toString() ??
          payload['id']?.toString() ??
          payload['sub']?.toString();
    } catch (e) {
      log('❌ Error extracting userId from token: $e');
      return null;
    }
  }

  bool _isValidGuid(String value) {
    // Check if it's a GUID format (not a phone number)
    return value.contains('-') || !RegExp(r'^[0-9]+$').hasMatch(value);
  }

  Future<void> _saveAuthData(Map<String, dynamic> response) async {
    final token = response['token']?.toString();
    if (token == null || token.isEmpty) return;

    await SharedPrefHelper.setSecuredString(
      SharedPrefKeys.userToken,
      token,
    );
    DioFactory.setTokenIntoHeaderAfterLogin(token);

    // ===== userId =====
    String? userId = response['userId']?.toString();
    userId ??= _extractUserIdFromToken(token);

    if (userId != null) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userId,
        userId,
      );
    }

    // ===== IsCompleted =====
    final isCompleted =
        response['isCompleted'] ??
            response['user']?['isCompleted'] ??
            false;

    await SharedPrefHelper.setBool(
      SharedPrefKeys.isCompleted,
      isCompleted,
    );

    log('✅ IsCompleted saved: $isCompleted');
  }

  Future<MultipartFile> _createMultipartFile(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw Exception('File does not exist at $imagePath');
    }

    final compressedBytes = await _compressImage(file);
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(compressedBytes);

    return MultipartFile.fromFile(
      tempFile.path,
      filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
  }

  Future<List<int>> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 800,
      minHeight: 600,
      quality: 80,
    );

    if (result == null) {
      throw Exception('Error compressing image');
    }

    return result;
  }

  // Old method name for backward compatibility
  Future<MultipartFile> createImageFromFile(String imagePath) => _createMultipartFile(imagePath);

  // ============================================================================
  // UI STATE HELPERS
  // ============================================================================

  void updatePhoneAvailability() {
    isAvailable = controller.phone.text.length == maxLength;
    emit(const LoginState.changeAvailableButtonSuccess());
  }

  // Old method name for backward compatibility
  void changeButtonStatus() => updatePhoneAvailability();

  void updateVerifyCodeAvailability(int length) {
    isAvailable = length == 6;
    emit(const LoginState.changeAvailableButtonSuccess());
  }

  // Old method name for backward compatibility
  void changeVerifyButtonStatus(int length) => updateVerifyCodeAvailability(length);

  @override
  Future<void> close() {
    controller.dispose();
    showPassword.dispose();
    positionID.dispose();
    positionName.dispose();
    return super.close();
  }
}