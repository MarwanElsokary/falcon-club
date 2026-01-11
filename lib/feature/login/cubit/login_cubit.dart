import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helpers/constants.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/networking/dio_factory.dart';
import '../controller/login_controllers.dart';

import '../data/model/country_model.dart';
import '../data/repos/login_repo.dart';
import 'login_state.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bloc/bloc.dart';

import 'dart:io';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(const LoginState.initial());
  LoginControllers controller = LoginControllers();
  final formKey = GlobalKey<FormState>();
  final loginformKey = GlobalKey<FormState>();

  ValueNotifier<bool> showPassword = ValueNotifier(true);
  ValueNotifier<int> positionID = ValueNotifier(-1);

  ValueNotifier<String> positionName = ValueNotifier('');

  int maxLength = 11;
  String codeCountry = '+2';
  bool isAvailable = false;
  int direction = 0;
  String? selectedDirection;
  int gender = -1;
  String birthDate = '';
  String imagePath = '';

  List<CountiesList> universityList = [];
  List<CountiesList> collegesList = [];
  List<CountiesList> departmentsList = [];

  String? selectedUniversity;
  int? selectedUniversityId;
  String? selectedColleges;
  int? selectedCollegesId;
  String? selectedDepartments;
  int? selectedDepartmentsId;

  // // MARK: - Login method

  void emitloginStates() async {
    emit(const LoginState.loading());
    final response = await _loginRepo.login(
      FormData.fromMap({
        "PlayerId": '${controller.email.text}Id',
        "Email": controller.email.text,
        "Password": controller.password.text,
      }),
    );
    response.when(
      success: (loginResponse) async {
        //sabajid131@dropeso.com
        // ignore: prefer_interpolation_to_compose_strings
        await saveUserToken(token: loginResponse['token']);

        emit(LoginState.success(loginResponse));
      },
      failure: (error) {
        emit(LoginState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }

  // MARK: - Register method

  void emitregisterStates() async {
    emit(const LoginState.registerloading());
    final response = await _loginRepo.register(
      FormData.fromMap({
        "PlayerId": "PlayerId",
        "FirstName": controller.name.text,
        "LastName": controller.lastName.text,
        "PhoneNumber": controller.phone.text,
        "Email": controller.email.text,
        "CodePhoneNumber": "+2",

        "Password": controller.password.text,
        if (imagePath.isNotEmpty) 'Photo': await createImageFromFile(imagePath),
      }),
    );
    response.when(
      success: (loginResponse) async {
        //
        // ignore: prefer_interpolation_to_compose_strings
        await saveUserToken(token: loginResponse['token']);

        emit(LoginState.registersuccess(loginResponse));
      },
      failure: (error) {
        emit(
          LoginState.registererror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  void emitupdateProfileStates() async {
    emit(const LoginState.updateProfileloading());
    final response = await _loginRepo.updateProfile(
      FormData.fromMap({
        "FirstName": controller.name.text,
        "LastName": controller.lastName.text,
        "PhoneNumber": codeCountry + controller.phone.text,
        "Email": controller.email.text,
        if (controller.height.text.isNotEmpty) "Height": controller.height.text,
        if (controller.weight.text.isNotEmpty) "Weight": controller.weight.text,
        "PositionId": '${positionID.value}',
        "Direction": "$direction",
        "BirthDate": birthDate,
        if (gender != -1) "Gender": gender.toString(),
        if (selectedCollegesId != null) "ClubId": selectedCollegesId.toString(),
        if (imagePath.isNotEmpty) 'Photo': await createImageFromFile(imagePath),
      }),
    );
    response.when(
      success: (loginResponse) async {
        emit(LoginState.updateProfilesuccess(loginResponse));
      },
      failure: (error) {
        emit(
          LoginState.updateProfileerror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  // MARK: - verificationCode
  void emitverifyCodeStates() async {
    emit(const LoginState.verificationCodeloading());
    final response = await _loginRepo.otp(
      int.parse(controller.verifyCode.text.toString()),
    );
    response.when(
      success: (loginResponse) async {
        emit(LoginState.verificationCodesuccess(loginResponse));
      },
      failure: (error) {
        emit(
          LoginState.verificationCodeerror(
            error: error.apiErrorModel.message ?? '',
          ),
        );
      },
    );
  }

  Future<void> saveUserToken({required String token}) async {
    DioFactory.setTokenIntoHeaderAfterLogin(token);
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
  }

  // // MARK: -change Button Status
  changeButtonStatus() {
    emit(const LoginState.changeAvailableButtonLoading());
    if (controller.phone.text.length == maxLength) {
      isAvailable = true;
    } else {
      isAvailable = false;
    }
    // CacheHelper.savecodeCountry(codeCountry);
    emit(const LoginState.changeAvailableButtonSuccess());
  }

  changeVerifyButtonStatus(int leangth) {
    emit(const LoginState.changeAvailableButtonLoading());
    if (leangth == 6) {
      isAvailable = true;
    } else {
      isAvailable = false;
    }
    // CacheHelper.savecodeCountry(codeCountry);
    emit(const LoginState.changeAvailableButtonSuccess());
  }

  // MARK: -countries
  void emitcountries() async {
    emit(const LoginState.universityloading());
    final response = await _loginRepo.countries();
    response.when(
      success: (countriesResponse) async {
        universityList.clear();
        universityList.addAll(countriesResponse.data);

        emit(LoginState.universitysuccess());
      },
      failure: (error) {
        emit(
          LoginState.universityerror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  // MARK: -clubsByCountry
  void emitclubsByCountry({required String countryId}) async {
    emit(const LoginState.collegesloading());
    final response = await _loginRepo.clubsByCountry(countryId: countryId);
    response.when(
      success: (collegesResponse) async {
        collegesList.clear();
        collegesList.addAll(collegesResponse.data);

        emit(LoginState.collegessuccess());
      },
      failure: (error) {
        emit(
          LoginState.collegeserror(error: error.apiErrorModel.message ?? ''),
        );
      },
    );
  }

  // MARK: -create Image
  Future<MultipartFile> createImageFromFile(String imagePath) async {
    // Ensure the file exists at the specified path
    final file = File(imagePath);
    if (!await file.exists()) {
      throw Exception('File does not exist at $imagePath');
    }

    try {
      // Compress the image
      final compressedImage = await _compressImage(file);

      // Get the directory to store the compressed image
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/compressed_image.jpg');

      // Save the compressed image to the temp directory
      await tempFile.writeAsBytes(compressedImage);

      // Return the MultipartFile for the compressed image
      return await MultipartFile.fromFile(
        tempFile.path,
        filename: file.uri.pathSegments.last,
      );
    } catch (e) {
      throw Exception('Error creating image from file: $e');
    }
  }

  Future<List<int>> _compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 800, // Optional: Set the desired width after compression
      minHeight: 600, // Optional: Set the desired height after compression
      quality: 80, // Optional: Set the compression quality (0-100)
      rotate: 0, // Optional: Set image rotation (if needed)
    );

    if (result == null) {
      throw Exception('Error compressing image');
    }

    return result;
  }
}
