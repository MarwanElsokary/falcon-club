part of 'forget_password_cubit.dart';

@freezed
class ForgetPasswordState with _$ForgetPasswordState {
  const factory ForgetPasswordState.initial() = _Initial;

  const factory ForgetPasswordState.loading() = _Loading;

  const factory ForgetPasswordState.verifying() = _Verifying;

  const factory ForgetPasswordState.resetting() = _Resetting;

  const factory ForgetPasswordState.otpSent(String message) = _OtpSent;

  const factory ForgetPasswordState.otpVerified(String token) = _OtpVerified;

  const factory ForgetPasswordState.passwordReset(String message) =
      _PasswordReset;

  const factory ForgetPasswordState.timerTick(int seconds) = _TimerTick;

  const factory ForgetPasswordState.timerComplete() = _TimerComplete;

  const factory ForgetPasswordState.buttonStatusChanged(bool isEnabled) =
      _ButtonStatusChanged;

  const factory ForgetPasswordState.otpFilled(String otp) = _OtpFilled;

  const factory ForgetPasswordState.error(String message) = _Error;
}
