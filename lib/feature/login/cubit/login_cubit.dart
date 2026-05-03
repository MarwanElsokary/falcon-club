import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/cache/cach_Helper.dart';
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

  // UI State
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
        final status = data['status']?.toString() ?? '';
        final role = data['role']?.toString() ?? '';
        final message = data['message']?.toString() ?? 'حدث خطأ';

        // لو status مش Accepted: وقّف وورّي الرسالة
        if (status != 'Accepted') {
          emit(LoginState.error(error: message));
          return;
        }

        // Player: مش مسموح بالتطبيق ده
        if (role == 'Player') {
          emit(
            const LoginState.error(
              error:
                  'هذا التطبيق مخصص للأندية والكشافين فقط.\nإذا كنت لاعباً، يرجى استخدام تطبيق اللاعبين.',
            ),
          );
          return;
        }

        // Club | MainClub | Scout + status Accepted
        await _saveAuthData(data);
        emit(LoginState.success(data));
      },
      failure: (error) {
        emit(
          LoginState.error(
            error: error.apiErrorModel.message ?? 'فشل تسجيل الدخول',
          ),
        );
      },
    );
  }

  // Old method name for backward compatibility
  void emitloginStates() => login();

  // ============================================================================
  // REGISTRATION
  // ============================================================================

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
        if (imagePath.isNotEmpty)
          'Photo': await _createMultipartFile(imagePath),
      }),
    );

    response.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(LoginState.registersuccess(data));
      },
      failure: (error) {
        emit(
          LoginState.registererror(
            error: error.apiErrorModel.message ?? 'فشل التسجيل',
          ),
        );
      },
    );
  }

  void emitregisterStates() => register();

  // ============================================================================
  // CLUB REGISTRATION
  // ============================================================================

  Future<void> registerClub() async {
    if (!formKey.currentState!.validate()) return;

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
        if (imagePath.isNotEmpty)
          'Photo': await _createMultipartFile(imagePath),
      }),
    );

    response.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(LoginState.registersuccess(data));
      },
      failure: (error) {
        emit(
          LoginState.registererror(
            error: error.apiErrorModel.message ?? 'فشل تسجيل النادي',
          ),
        );
      },
    );
  }

  // ── تسجيل الكشاف ─────────────────────────────────────────────────────────
  Future<void> registerScout() async {
    if (!formKey.currentState!.validate()) return;
    emit(const LoginState.registerloading());

    final response = await _loginRepo.registerScout(
      FormData.fromMap({
        'PlayerId': '1',
        'FirstName': controller.name.text,
        'LastName': controller.lastName.text,
        'Email': controller.email.text,
        'PhoneNumber': controller.phone.text,
        'Gender': gender == -1 ? 0 : gender,
        'Password': controller.password.text,
        if (imagePath.isNotEmpty)
          'Photo': await _createMultipartFile(imagePath),
      }),
    );

    response.when(
      success: (data) async {
        await _saveAuthData(data);
        emit(LoginState.registersuccess(data));
      },
      failure: (error) {
        emit(
          LoginState.registererror(
            error: error.apiErrorModel.message ?? 'فشل تسجيل الكشاف',
          ),
        );
      },
    );
  }

  // ============================================================================
  // OTP
  // ============================================================================

  Future<void> verifyOtp() async {
    final code = controller.verifyCode.text.trim();
    if (code.isEmpty) {
      emit(
        const LoginState.verificationCodeerror(error: 'يجب إدخال كود التحقق'),
      );
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
        emit(const LoginState.verificationCodesuccess('success'));
      },
      failure: (error) {
        emit(
          LoginState.verificationCodeerror(
            error: error.apiErrorModel.message ?? 'كود التحقق غير صحيح',
          ),
        );
      },
    );
  }

  // Old method name for backward compatibility
  void emitverifyCodeStates() => verifyOtp();

  // ============================================================================
  // COMPLETE REGISTRATION
  // ============================================================================

  Future<void> completeRegistration() async {
    final validationError = _validateProfileData();
    if (validationError != null) {
      emit(LoginState.profileCompleteerror(error: validationError));
      return;
    }

    emit(const LoginState.profileCompleteloading());

    final response = await _loginRepo.completeRegistration(
      FormData.fromMap({
        "Height": controller.height.text,
        "Weight": controller.weight.text,
        "Gender": gender == -1 ? 0 : gender,
        "Direction": direction,
        "BirthDate": birthDate,
        "PositionId": positionID.value,
        if (selectedCollegesId != null) "ClubId": selectedCollegesId.toString(),
        if (selectedUniversityId != null)
          "UniversityId": selectedUniversityId.toString(),
        if (imagePath.isNotEmpty)
          'Photo': await _createMultipartFile(imagePath),
      }),
    );

    response.when(
      success: (data) => emit(LoginState.profileCompletesuccess(data)),
      failure: (error) => emit(
        LoginState.profileCompleteerror(
          error: error.apiErrorModel.message ?? 'فشل إكمال التسجيل',
        ),
      ),
    );
  }

  // ============================================================================
  // UPDATE PROFILE
  // ============================================================================

  Future<void> updateProfile() async {
    emit(const LoginState.updateProfileLoading());

    final response = await _loginRepo.updateProfile(
      FormData.fromMap({
        "Height": controller.height.text,
        "Weight": controller.weight.text,
        "Gender": gender == -1 ? 0 : gender,
        "Direction": direction,
        "BirthDate": birthDate,
        "PositionId": positionID.value,
        if (selectedCollegesId != null) "ClubId": selectedCollegesId.toString(),
        if (selectedUniversityId != null)
          "UniversityId": selectedUniversityId.toString(),
        if (imagePath.isNotEmpty)
          'Photo': await _createMultipartFile(imagePath),
      }),
    );

    response.when(
      success: (data) => emit(LoginState.updateProfilesuccess(data)),
      failure: (error) => emit(
        LoginState.updateProfileerror(
          error: error.apiErrorModel.message ?? 'فشل تحديث الملف الشخصي',
        ),
      ),
    );
  }

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
        emit(
          LoginState.universityerror(
            error: error.apiErrorModel.message ?? 'فشل تحميل المدن',
          ),
        );
      },
    );
  }

  void emitcountries() => loadCountries();

  Future<void> loadClubsByCountry(String countryId) async {
    emit(const LoginState.collegesloading());
    final response = await _loginRepo.clubsByCountry(countryId: countryId);
    response.when(
      success: (data) {
        collegesList = data.data;
        if (collegesList.isEmpty) {
          emit(
            const LoginState.collegeserror(
              error: 'لا توجد أندية متاحة في هذه المدينة حالياً',
            ),
          );
        } else {
          emit(const LoginState.collegessuccess());
        }
      },
      failure: (error) {
        emit(
          LoginState.collegeserror(
            error: error.apiErrorModel.message ?? 'فشل تحميل الأندية',
          ),
        );
      },
    );
  }

  void emitclubsByCountry({required String countryId}) =>
      loadClubsByCountry(countryId);

  // ============================================================================
  // TERMS
  // ============================================================================

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
        log('Failed to load terms and policies: $error');
      },
    );
  }

  // ============================================================================
  // SAVE AUTH DATA
  // ============================================================================

  Future<void> _saveAuthData(Map<String, dynamic> response) async {
    // ✅ امسح الـ cache القديم عشان ميرجعش profile غلط لـ يوزر جديد
    await CacheHelper.clearShared();

    final role = response['role']?.toString() ?? '';
    if (role.isNotEmpty) {
      await SharedPrefHelper.setSecuredString(SharedPrefKeys.userType, role);
      log('✅ Role saved: $role');
    }

    final token = response['token']?.toString();

    if (token == null || token.isEmpty) {
      log('⚠️ No token in response — role only saved: $role');
      return;
    }

    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
    DioFactory.setTokenIntoHeaderAfterLogin(token);

    String? userId = response['userId']?.toString();
    userId ??= _extractUserIdFromToken(token);
    if (userId != null) {
      await SharedPrefHelper.setSecuredString(SharedPrefKeys.userId, userId);
    }

    log('✅ Auth data saved — role: $role, userId: $userId');
  }

  // ============================================================================
  // HELPERS
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
    String? userId = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userId,
    );
    if (userId != null && userId.isNotEmpty && _isValidGuid(userId)) {
      return userId;
    }

    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );
    if (token != null && token.isNotEmpty) {
      userId = _extractUserIdFromToken(token);
      if (userId != null && _isValidGuid(userId)) {
        await SharedPrefHelper.setSecuredString(SharedPrefKeys.userId, userId);
        return userId;
      }
    }

    final response = await _loginRepo.getCurrentUser();
    String? apiUserId;
    response.when(
      success: (data) {
        apiUserId =
            data['userId']?.toString() ??
            data['id']?.toString() ??
            data['uid']?.toString();
      },
      failure: (error) =>
          log('❌ Error fetching current user: ${error.apiErrorModel.message}'),
    );

    if (apiUserId != null && _isValidGuid(apiUserId!)) {
      await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userId,
        apiUserId!,
      );
      return apiUserId;
    }
    return null;
  }

  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payloadJson = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
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
    return value.contains('-') || !RegExp(r'^[0-9]+$').hasMatch(value);
  }

  Future<MultipartFile> _createMultipartFile(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) throw Exception('File does not exist');
    final compressedBytes = await _compressImage(file);
    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
      '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
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
    if (result == null) throw Exception('Error compressing image');
    return result;
  }

  Future<MultipartFile> createImageFromFile(String imagePath) =>
      _createMultipartFile(imagePath);

  void updatePhoneAvailability() {
    isAvailable = controller.phone.text.length == maxLength;
    emit(const LoginState.changeAvailableButtonSuccess());
  }

  void changeButtonStatus() => updatePhoneAvailability();

  void updateVerifyCodeAvailability(int length) {
    isAvailable = length == 6;
    emit(const LoginState.changeAvailableButtonSuccess());
  }

  void changeVerifyButtonStatus(int length) =>
      updateVerifyCodeAvailability(length);

  @override
  Future<void> close() {
    controller.dispose();
    showPassword.dispose();
    positionID.dispose();
    positionName.dispose();
    return super.close();
  }
}
