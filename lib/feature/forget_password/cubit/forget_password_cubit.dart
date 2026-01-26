import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/repo/forget_password_repo.dart';

part 'forget_password_state.dart';

part 'forget_password_cubit.freezed.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepo _repo;
  Timer? _timer;
  int _remainingSeconds = 60;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  ForgetPasswordCubit(this._repo) : super(const ForgetPasswordState.initial());

  // 1. Send OTP
  Future<void> sendOtp() async {
    if (phoneController.text.isEmpty) {
      emit(const ForgetPasswordState.error('يرجى إدخال رقم الجوال'));
      return;
    }

    emit(const ForgetPasswordState.loading());

    final result = await _repo.sendOtp(phoneController.text);

    result.when(
      success: (response) {
        startTimer();
        emit(ForgetPasswordState.otpSent(response.message));
      },
      failure: (error) {
        emit(
          ForgetPasswordState.error(
            error.apiErrorModel.message ?? 'فشل إرسال الرمز',
          ),
        );
      },
    );
  }

  // أضف هذه ValueNotifiers في بداية الـ Cubit class:
  ValueNotifier<bool> showPassword = ValueNotifier(true);
  ValueNotifier<bool> showConfirmPassword = ValueNotifier(true);

  // أضف هذه الدالة في الـ Cubit:
  void updatePasswordValidation(String password) {
    // يمكنك إضافة منطق للتحقق من قوة كلمة المرور هنا
    // وإرسال state إذا أردت
  }

  // تأكد من تعطيل الـ controllers في dispose:

  // 2. Verify OTP
  // MARK: - Verify OTP
  Future<void> verifyOtp() async {
    // التحقق من أن الحقول غير فارغة
    if (otpController.text.isEmpty) {
      emit(ForgetPasswordState.error('من فضلك أدخل الرمز'));
      return;
    }

    if (phoneController.text.isEmpty) {
      emit(ForgetPasswordState.error('رقم الجوال غير متوفر'));
      return;
    }

    emit(const ForgetPasswordState.verifying());

    final result = await _repo.verifyOtp(
      otp: otpController.text.trim(),
      phoneNumber: phoneController.text.trim(),
    );

    result.when(
      success: (response) {
        log('OTP verified successfully, token: ${response.resetToken}');
        emit(ForgetPasswordState.otpVerified(response.resetToken));
      },
      failure: (error) {
        log('OTP verification failed: ${error.apiErrorModel.message}');
        emit(
          ForgetPasswordState.error(
            error.apiErrorModel.message ?? 'فشل التحقق من الرمز',
          ),
        );
      },
    );
  }

  // 3. Reset Password
  Future<void> resetPassword(String token) async {
    if (passwordController.text != confirmPasswordController.text) {
      emit(const ForgetPasswordState.error('كلمات المرور غير متطابقة'));
      return;
    }

    if (passwordController.text.length < 6) {
      emit(
        const ForgetPasswordState.error(
          'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
        ),
      );
      return;
    }

    emit(const ForgetPasswordState.resetting());

    final result = await _repo.resetPassword(
      token: token,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    result.when(
      success: (response) {
        emit(ForgetPasswordState.passwordReset(response.message));
      },
      failure: (error) {
        emit(
          ForgetPasswordState.error(
            error.apiErrorModel.message ?? 'فشل إعادة تعيين كلمة المرور',
          ),
        );
      },
    );
  }

  // Timer Functions
  void startTimer() {
    _remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        emit(ForgetPasswordState.timerTick(_remainingSeconds));
      } else {
        timer.cancel();
        emit(const ForgetPasswordState.timerComplete());
      }
    });
  }

  // دالة لتحديث حالة الزر
  void changeButtonStatus(bool isEnabled) {
    emit(ForgetPasswordState.buttonStatusChanged(isEnabled));
  }

  // دالة لتحديث حالة زر التحقق
  void updateVerifyButtonState(int length) {
    if (length == 6) {
      emit(ForgetPasswordState.buttonStatusChanged(true));
    } else {
      emit(ForgetPasswordState.buttonStatusChanged(false));
    }
  }

  // دالة لتفعيل الزر
  void enableVerifyButton() {
    emit(ForgetPasswordState.buttonStatusChanged(true));
  }

  // دالة لتعطيل الزر
  void disableVerifyButton() {
    emit(ForgetPasswordState.buttonStatusChanged(false));
  }

  // دالة للإدخال السريع في OTP (للتجربة فقط)
  void fillTestOtp() {
    otpController.text = '1234';
    emit(ForgetPasswordState.otpFilled('1234'));
  }

  void resendOtp() {
    if (_remainingSeconds == 0) {
      sendOtp();
    }
  }

  @override
  Future<void> close() {
    showPassword.dispose();
    showConfirmPassword.dispose();
    _timer?.cancel();
    phoneController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
