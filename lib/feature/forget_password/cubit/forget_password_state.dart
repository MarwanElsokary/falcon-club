// // forget_password_state.dart
// part of 'forget_password_cubit.dart';
//
// @freezed
// class ForgetPasswordState with _$ForgetPasswordState {
//   const factory ForgetPasswordState.initial() = ForgetPasswordInitial;
//   const factory ForgetPasswordState.loading(String message) = ForgetPasswordLoading;
//   const factory ForgetPasswordState.error(String message) = ForgetPasswordError;
//   const factory ForgetPasswordState.otpSent({
//     required String phone,
//     required int expiresIn,
//   }) = OtpSentSuccessfully;
//   const factory ForgetPasswordState.otpVerified({
//     required String token,
//   }) = OtpVerifiedSuccessfully;
//   const factory ForgetPasswordState.otpResent({
//     required int expiresIn,
//   }) = OtpResentSuccessfully;
//   const factory ForgetPasswordState.resetPasswordSuccess() = ResetPasswordSuccess;
// }