import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState<T> with _$LoginState<T> {
  const factory LoginState.initial() = _Initial;

  //login
  const factory LoginState.loading() = Loading;

  const factory LoginState.success(T data) = Success<T>;

  const factory LoginState.error({required String error}) = Error;

  //register
  const factory LoginState.registerloading() = registerLoading;

  const factory LoginState.registersuccess(T data) = registerSuccess<T>;

  const factory LoginState.registererror({required String error}) =
      registerError;

  //update profile
  const factory LoginState.updateProfileloading() = updateProfileLoading;

  const factory LoginState.updateProfilesuccess(T data) =
      updateProfileSuccess<T>;

  const factory LoginState.updateProfileerror({required String error}) =
      updateProfileError;

  //sendVerificationCode
  const factory LoginState.sendVerificationCodeloading() =
      SendVerificationCodeLoading;

  const factory LoginState.sendVerificationCodesuccess(T data) =
      SendVerificationCodeSuccess<T>;

  const factory LoginState.sendVerificationCodeerror({required String error}) =
      SendVerificationCodeError;

  //verificationCode
  const factory LoginState.verificationCodeloading() = VerificationCodeLoading;

  const factory LoginState.verificationCodesuccess(verifyResponse) =
      VerificationCodeSuccess;

  const factory LoginState.verificationCodeerror({required String error}) =
      VerificationCodeError;

  //

  //profile Complete
  const factory LoginState.profileCompleteloading() = ProfileCompleteLoading;

  const factory LoginState.profileCompletesuccess(T data) =
      ProfileCompleteSuccess<T>;

  const factory LoginState.profileCompleteerror({required String error}) =
      ProfileCompleteError;

  const factory LoginState.changeCountryLoading() = ChangeCountryLoading;

  const factory LoginState.changeCountrySuccess() = ChangeCountrySuccess;

  const factory LoginState.changeAvailableButtonLoading() =
      ChangeAvailableButtonLoading;

  const factory LoginState.changeAvailableButtonSuccess() =
      ChangeAvailableButtonSuccess;

  //uni
  const factory LoginState.universityloading() = universityLoading;

  const factory LoginState.universitysuccess() = universitySuccess;

  const factory LoginState.universityerror({required String error}) =
      universityError;

  //colleges
  const factory LoginState.collegesloading() = collegesLoading;

  const factory LoginState.collegessuccess() = collegesSuccess;

  const factory LoginState.collegeserror({required String error}) =
      collegesError;

  //departments
  const factory LoginState.departmentsloading() = departmentsLoading;

  const factory LoginState.departmentssuccess() = departmentsSuccess;

  const factory LoginState.departmentserror({required String error}) =
      departmentsError;
}
