// // forget_password_cubit.dart
// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../data/repo/forget_password_repo.dart';
//
// import '../../../core/cache/cach_Helper.dart';
//
// part 'forget_password_state.dart';
//
// class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
//   final ForgetPasswordRepo _repo;
//
//   ForgetPasswordCubit(this._repo) : super(ForgetPasswordInitial());
//
//   // Controllers
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//
//   // States
//   bool isNewPasswordVisible = false;
//   bool isConfirmPasswordVisible = false;
//   bool isVerifyButtonEnabled = false;
//   bool isResetButtonEnabled = false;
//   String? resetToken;
//   String? userPhone;
//
//   // 1. إرسال OTP
//   Future<void> sendOtp() async {
//     if (phoneController.text.isEmpty || phoneController.text.length != 9) {
//       emit(ForgetPasswordError('من فضلك أدخل رقم هاتف صحيح'));
//       return;
//     }
//
//     emit(ForgetPasswordLoading('جاري إرسال الرمز...'));
//
//     final result = await _repo.sendOtpToPhone(
//       phoneNumber: phoneController.text,
//     );
//
//     result.fold(
//           (failure) => emit(ForgetPasswordError(failure.message)),
//           (response) {
//         userPhone = phoneController.text;
//         emit(OtpSentSuccessfully(
//           phone: phoneController.text,
//           expiresIn: response.data?.expiresIn ?? 60,
//         ));
//       },
//     );
//   }
//
//   // 2. التحقق من OTP
//   Future<void> verifyOtp() async {
//     if (otpController.text.length != 6) {
//       emit(ForgetPasswordError('الرمز يجب أن يكون 6 أرقام'));
//       return;
//     }
//
//     emit(ForgetPasswordLoading('جاري التحقق...'));
//
//     final result = await _repo.verifyOtp(
//       phoneNumber: userPhone ?? phoneController.text,
//       otp: otpController.text,
//     );
//
//     result.fold(
//           (failure) => emit(ForgetPasswordError(failure.message)),
//           (response) {
//         resetToken = response.data?.token;
//         await CacheHelper.saveData(key: 'resetToken', value: resetToken);
//         emit(OtpVerifiedSuccessfully(token: resetToken!));
//       },
//     );
//   }
//
//   // 3. إعادة تعيين كلمة المرور
//   Future<void> resetPassword() async {
//     if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
//       emit(ForgetPasswordError('من فضلك أدخل كلمة المرور'));
//       return;
//     }
//
//     if (newPasswordController.text != confirmPasswordController.text) {
//       emit(ForgetPasswordError('كلمة المرور غير متطابقة'));
//       return;
//     }
//
//     if (newPasswordController.text.length < 8) {
//       emit(ForgetPasswordError('كلمة المرور يجب أن تكون 8 أحرف على الأقل'));
//       return;
//     }
//
//     if (resetToken == null) {
//       final token = await CacheHelper.getData(key: 'resetToken');
//       if (token == null) {
//         emit(ForgetPasswordError('انتهت صلاحية الجلسة'));
//         return;
//       }
//       resetToken = token;
//     }
//
//     emit(ForgetPasswordLoading('جاري تغيير كلمة المرور...'));
//
//     final result = await _repo.resetPassword(
//       token: resetToken!,
//       password: newPasswordController.text,
//       confirmPassword: confirmPasswordController.text,
//     );
//
//     result.fold(
//           (failure) => emit(ForgetPasswordError(failure.message)),
//           (response) {
//         // تنظيف البيانات
//         phoneController.clear();
//         otpController.clear();
//         newPasswordController.clear();
//         confirmPasswordController.clear();
//         resetToken = null;
//         CacheHelper.removeData(key: 'resetToken');
//
//         emit(ResetPasswordSuccess());
//       },
//     );
//   }
//
//   // 4. إعادة إرسال OTP
//   Future<void> resendOtp() async {
//     emit(ForgetPasswordLoading('جاري إعادة الإرسال...'));
//
//     final result = await _repo.resendOtp(
//       phoneNumber: userPhone ?? phoneController.text,
//     );
//
//     result.fold(
//           (failure) => emit(ForgetPasswordError(failure.message)),
//           (response) {
//         emit(OtpResentSuccessfully(
//           expiresIn: response.data?.expiresIn ?? 60,
//         ));
//       },
//     );
//   }
//
//   // 5. تحديث حالة الأزرار
//   void updateVerifyButtonStatus(int otpLength) {
//     isVerifyButtonEnabled = otpLength == 6;
//     emit(ForgetPasswordInitial());
//   }
//
//   void updateResetButtonStatus() {
//     isResetButtonEnabled = newPasswordController.text.isNotEmpty &&
//         confirmPasswordController.text.isNotEmpty;
//     emit(ForgetPasswordInitial());
//   }
//
//   // 6. تبديل رؤية كلمة المرور
//   void toggleNewPasswordVisibility() {
//     isNewPasswordVisible = !isNewPasswordVisible;
//     emit(ForgetPasswordInitial());
//   }
//
//   void toggleConfirmPasswordVisibility() {
//     isConfirmPasswordVisible = !isConfirmPasswordVisible;
//     emit(ForgetPasswordInitial());
//   }
//
//   // 7. تنظيف البيانات
//   void clearData() {
//     phoneController.clear();
//     otpController.clear();
//     newPasswordController.clear();
//     confirmPasswordController.clear();
//     isNewPasswordVisible = false;
//     isConfirmPasswordVisible = false;
//     isVerifyButtonEnabled = false;
//     isResetButtonEnabled = false;
//     resetToken = null;
//     userPhone = null;
//     emit(ForgetPasswordInitial());
//   }
//
//   @override
//   Future<void> close() {
//     phoneController.dispose();
//     otpController.dispose();
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     return super.close();
//   }
// }