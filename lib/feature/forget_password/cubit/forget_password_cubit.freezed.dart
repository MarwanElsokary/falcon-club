// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forget_password_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ForgetPasswordState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgetPasswordStateCopyWith<$Res> {
  factory $ForgetPasswordStateCopyWith(
    ForgetPasswordState value,
    $Res Function(ForgetPasswordState) then,
  ) = _$ForgetPasswordStateCopyWithImpl<$Res, ForgetPasswordState>;
}

/// @nodoc
class _$ForgetPasswordStateCopyWithImpl<$Res, $Val extends ForgetPasswordState>
    implements $ForgetPasswordStateCopyWith<$Res> {
  _$ForgetPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'ForgetPasswordState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements ForgetPasswordState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'ForgetPasswordState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements ForgetPasswordState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$VerifyingImplCopyWith<$Res> {
  factory _$$VerifyingImplCopyWith(
    _$VerifyingImpl value,
    $Res Function(_$VerifyingImpl) then,
  ) = __$$VerifyingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$VerifyingImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$VerifyingImpl>
    implements _$$VerifyingImplCopyWith<$Res> {
  __$$VerifyingImplCopyWithImpl(
    _$VerifyingImpl _value,
    $Res Function(_$VerifyingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$VerifyingImpl implements _Verifying {
  const _$VerifyingImpl();

  @override
  String toString() {
    return 'ForgetPasswordState.verifying()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$VerifyingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return verifying();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return verifying?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (verifying != null) {
      return verifying();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return verifying(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return verifying?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (verifying != null) {
      return verifying(this);
    }
    return orElse();
  }
}

abstract class _Verifying implements ForgetPasswordState {
  const factory _Verifying() = _$VerifyingImpl;
}

/// @nodoc
abstract class _$$ResettingImplCopyWith<$Res> {
  factory _$$ResettingImplCopyWith(
    _$ResettingImpl value,
    $Res Function(_$ResettingImpl) then,
  ) = __$$ResettingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResettingImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$ResettingImpl>
    implements _$$ResettingImplCopyWith<$Res> {
  __$$ResettingImplCopyWithImpl(
    _$ResettingImpl _value,
    $Res Function(_$ResettingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResettingImpl implements _Resetting {
  const _$ResettingImpl();

  @override
  String toString() {
    return 'ForgetPasswordState.resetting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResettingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return resetting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return resetting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (resetting != null) {
      return resetting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return resetting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return resetting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (resetting != null) {
      return resetting(this);
    }
    return orElse();
  }
}

abstract class _Resetting implements ForgetPasswordState {
  const factory _Resetting() = _$ResettingImpl;
}

/// @nodoc
abstract class _$$OtpSentImplCopyWith<$Res> {
  factory _$$OtpSentImplCopyWith(
    _$OtpSentImpl value,
    $Res Function(_$OtpSentImpl) then,
  ) = __$$OtpSentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$OtpSentImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$OtpSentImpl>
    implements _$$OtpSentImplCopyWith<$Res> {
  __$$OtpSentImplCopyWithImpl(
    _$OtpSentImpl _value,
    $Res Function(_$OtpSentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$OtpSentImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OtpSentImpl implements _OtpSent {
  const _$OtpSentImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ForgetPasswordState.otpSent(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpSentImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpSentImplCopyWith<_$OtpSentImpl> get copyWith =>
      __$$OtpSentImplCopyWithImpl<_$OtpSentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return otpSent(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return otpSent?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (otpSent != null) {
      return otpSent(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return otpSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return otpSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (otpSent != null) {
      return otpSent(this);
    }
    return orElse();
  }
}

abstract class _OtpSent implements ForgetPasswordState {
  const factory _OtpSent(final String message) = _$OtpSentImpl;

  String get message;

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OtpSentImplCopyWith<_$OtpSentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OtpVerifiedImplCopyWith<$Res> {
  factory _$$OtpVerifiedImplCopyWith(
    _$OtpVerifiedImpl value,
    $Res Function(_$OtpVerifiedImpl) then,
  ) = __$$OtpVerifiedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String token});
}

/// @nodoc
class __$$OtpVerifiedImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$OtpVerifiedImpl>
    implements _$$OtpVerifiedImplCopyWith<$Res> {
  __$$OtpVerifiedImplCopyWithImpl(
    _$OtpVerifiedImpl _value,
    $Res Function(_$OtpVerifiedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? token = null}) {
    return _then(
      _$OtpVerifiedImpl(
        null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OtpVerifiedImpl implements _OtpVerified {
  const _$OtpVerifiedImpl(this.token);

  @override
  final String token;

  @override
  String toString() {
    return 'ForgetPasswordState.otpVerified(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpVerifiedImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @override
  int get hashCode => Object.hash(runtimeType, token);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpVerifiedImplCopyWith<_$OtpVerifiedImpl> get copyWith =>
      __$$OtpVerifiedImplCopyWithImpl<_$OtpVerifiedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return otpVerified(token);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return otpVerified?.call(token);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (otpVerified != null) {
      return otpVerified(token);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return otpVerified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return otpVerified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (otpVerified != null) {
      return otpVerified(this);
    }
    return orElse();
  }
}

abstract class _OtpVerified implements ForgetPasswordState {
  const factory _OtpVerified(final String token) = _$OtpVerifiedImpl;

  String get token;

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OtpVerifiedImplCopyWith<_$OtpVerifiedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PasswordResetImplCopyWith<$Res> {
  factory _$$PasswordResetImplCopyWith(
    _$PasswordResetImpl value,
    $Res Function(_$PasswordResetImpl) then,
  ) = __$$PasswordResetImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PasswordResetImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$PasswordResetImpl>
    implements _$$PasswordResetImplCopyWith<$Res> {
  __$$PasswordResetImplCopyWithImpl(
    _$PasswordResetImpl _value,
    $Res Function(_$PasswordResetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$PasswordResetImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PasswordResetImpl implements _PasswordReset {
  const _$PasswordResetImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ForgetPasswordState.passwordReset(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PasswordResetImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PasswordResetImplCopyWith<_$PasswordResetImpl> get copyWith =>
      __$$PasswordResetImplCopyWithImpl<_$PasswordResetImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return passwordReset(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return passwordReset?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (passwordReset != null) {
      return passwordReset(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return passwordReset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return passwordReset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (passwordReset != null) {
      return passwordReset(this);
    }
    return orElse();
  }
}

abstract class _PasswordReset implements ForgetPasswordState {
  const factory _PasswordReset(final String message) = _$PasswordResetImpl;

  String get message;

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PasswordResetImplCopyWith<_$PasswordResetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerTickImplCopyWith<$Res> {
  factory _$$TimerTickImplCopyWith(
    _$TimerTickImpl value,
    $Res Function(_$TimerTickImpl) then,
  ) = __$$TimerTickImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int seconds});
}

/// @nodoc
class __$$TimerTickImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$TimerTickImpl>
    implements _$$TimerTickImplCopyWith<$Res> {
  __$$TimerTickImplCopyWithImpl(
    _$TimerTickImpl _value,
    $Res Function(_$TimerTickImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? seconds = null}) {
    return _then(
      _$TimerTickImpl(
        null == seconds
            ? _value.seconds
            : seconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TimerTickImpl implements _TimerTick {
  const _$TimerTickImpl(this.seconds);

  @override
  final int seconds;

  @override
  String toString() {
    return 'ForgetPasswordState.timerTick(seconds: $seconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerTickImpl &&
            (identical(other.seconds, seconds) || other.seconds == seconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, seconds);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerTickImplCopyWith<_$TimerTickImpl> get copyWith =>
      __$$TimerTickImplCopyWithImpl<_$TimerTickImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return timerTick(seconds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return timerTick?.call(seconds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (timerTick != null) {
      return timerTick(seconds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return timerTick(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return timerTick?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (timerTick != null) {
      return timerTick(this);
    }
    return orElse();
  }
}

abstract class _TimerTick implements ForgetPasswordState {
  const factory _TimerTick(final int seconds) = _$TimerTickImpl;

  int get seconds;

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerTickImplCopyWith<_$TimerTickImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerCompleteImplCopyWith<$Res> {
  factory _$$TimerCompleteImplCopyWith(
    _$TimerCompleteImpl value,
    $Res Function(_$TimerCompleteImpl) then,
  ) = __$$TimerCompleteImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TimerCompleteImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$TimerCompleteImpl>
    implements _$$TimerCompleteImplCopyWith<$Res> {
  __$$TimerCompleteImplCopyWithImpl(
    _$TimerCompleteImpl _value,
    $Res Function(_$TimerCompleteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TimerCompleteImpl implements _TimerComplete {
  const _$TimerCompleteImpl();

  @override
  String toString() {
    return 'ForgetPasswordState.timerComplete()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TimerCompleteImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return timerComplete();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return timerComplete?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (timerComplete != null) {
      return timerComplete();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return timerComplete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return timerComplete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (timerComplete != null) {
      return timerComplete(this);
    }
    return orElse();
  }
}

abstract class _TimerComplete implements ForgetPasswordState {
  const factory _TimerComplete() = _$TimerCompleteImpl;
}

/// @nodoc
abstract class _$$ButtonStatusChangedImplCopyWith<$Res> {
  factory _$$ButtonStatusChangedImplCopyWith(
    _$ButtonStatusChangedImpl value,
    $Res Function(_$ButtonStatusChangedImpl) then,
  ) = __$$ButtonStatusChangedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isEnabled});
}

/// @nodoc
class __$$ButtonStatusChangedImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$ButtonStatusChangedImpl>
    implements _$$ButtonStatusChangedImplCopyWith<$Res> {
  __$$ButtonStatusChangedImplCopyWithImpl(
    _$ButtonStatusChangedImpl _value,
    $Res Function(_$ButtonStatusChangedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isEnabled = null}) {
    return _then(
      _$ButtonStatusChangedImpl(
        null == isEnabled
            ? _value.isEnabled
            : isEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ButtonStatusChangedImpl implements _ButtonStatusChanged {
  const _$ButtonStatusChangedImpl(this.isEnabled);

  @override
  final bool isEnabled;

  @override
  String toString() {
    return 'ForgetPasswordState.buttonStatusChanged(isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ButtonStatusChangedImpl &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isEnabled);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ButtonStatusChangedImplCopyWith<_$ButtonStatusChangedImpl> get copyWith =>
      __$$ButtonStatusChangedImplCopyWithImpl<_$ButtonStatusChangedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return buttonStatusChanged(isEnabled);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return buttonStatusChanged?.call(isEnabled);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (buttonStatusChanged != null) {
      return buttonStatusChanged(isEnabled);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return buttonStatusChanged(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return buttonStatusChanged?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (buttonStatusChanged != null) {
      return buttonStatusChanged(this);
    }
    return orElse();
  }
}

abstract class _ButtonStatusChanged implements ForgetPasswordState {
  const factory _ButtonStatusChanged(final bool isEnabled) =
      _$ButtonStatusChangedImpl;

  bool get isEnabled;

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ButtonStatusChangedImplCopyWith<_$ButtonStatusChangedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OtpFilledImplCopyWith<$Res> {
  factory _$$OtpFilledImplCopyWith(
    _$OtpFilledImpl value,
    $Res Function(_$OtpFilledImpl) then,
  ) = __$$OtpFilledImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String otp});
}

/// @nodoc
class __$$OtpFilledImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$OtpFilledImpl>
    implements _$$OtpFilledImplCopyWith<$Res> {
  __$$OtpFilledImplCopyWithImpl(
    _$OtpFilledImpl _value,
    $Res Function(_$OtpFilledImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? otp = null}) {
    return _then(
      _$OtpFilledImpl(
        null == otp
            ? _value.otp
            : otp // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$OtpFilledImpl implements _OtpFilled {
  const _$OtpFilledImpl(this.otp);

  @override
  final String otp;

  @override
  String toString() {
    return 'ForgetPasswordState.otpFilled(otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpFilledImpl &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, otp);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpFilledImplCopyWith<_$OtpFilledImpl> get copyWith =>
      __$$OtpFilledImplCopyWithImpl<_$OtpFilledImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return otpFilled(otp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return otpFilled?.call(otp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (otpFilled != null) {
      return otpFilled(otp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return otpFilled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return otpFilled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (otpFilled != null) {
      return otpFilled(this);
    }
    return orElse();
  }
}

abstract class _OtpFilled implements ForgetPasswordState {
  const factory _OtpFilled(final String otp) = _$OtpFilledImpl;

  String get otp;

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OtpFilledImplCopyWith<_$OtpFilledImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ForgetPasswordStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ForgetPasswordState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() verifying,
    required TResult Function() resetting,
    required TResult Function(String message) otpSent,
    required TResult Function(String token) otpVerified,
    required TResult Function(String message) passwordReset,
    required TResult Function(int seconds) timerTick,
    required TResult Function() timerComplete,
    required TResult Function(bool isEnabled) buttonStatusChanged,
    required TResult Function(String otp) otpFilled,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? verifying,
    TResult? Function()? resetting,
    TResult? Function(String message)? otpSent,
    TResult? Function(String token)? otpVerified,
    TResult? Function(String message)? passwordReset,
    TResult? Function(int seconds)? timerTick,
    TResult? Function()? timerComplete,
    TResult? Function(bool isEnabled)? buttonStatusChanged,
    TResult? Function(String otp)? otpFilled,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? verifying,
    TResult Function()? resetting,
    TResult Function(String message)? otpSent,
    TResult Function(String token)? otpVerified,
    TResult Function(String message)? passwordReset,
    TResult Function(int seconds)? timerTick,
    TResult Function()? timerComplete,
    TResult Function(bool isEnabled)? buttonStatusChanged,
    TResult Function(String otp)? otpFilled,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Verifying value) verifying,
    required TResult Function(_Resetting value) resetting,
    required TResult Function(_OtpSent value) otpSent,
    required TResult Function(_OtpVerified value) otpVerified,
    required TResult Function(_PasswordReset value) passwordReset,
    required TResult Function(_TimerTick value) timerTick,
    required TResult Function(_TimerComplete value) timerComplete,
    required TResult Function(_ButtonStatusChanged value) buttonStatusChanged,
    required TResult Function(_OtpFilled value) otpFilled,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Verifying value)? verifying,
    TResult? Function(_Resetting value)? resetting,
    TResult? Function(_OtpSent value)? otpSent,
    TResult? Function(_OtpVerified value)? otpVerified,
    TResult? Function(_PasswordReset value)? passwordReset,
    TResult? Function(_TimerTick value)? timerTick,
    TResult? Function(_TimerComplete value)? timerComplete,
    TResult? Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult? Function(_OtpFilled value)? otpFilled,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Verifying value)? verifying,
    TResult Function(_Resetting value)? resetting,
    TResult Function(_OtpSent value)? otpSent,
    TResult Function(_OtpVerified value)? otpVerified,
    TResult Function(_PasswordReset value)? passwordReset,
    TResult Function(_TimerTick value)? timerTick,
    TResult Function(_TimerComplete value)? timerComplete,
    TResult Function(_ButtonStatusChanged value)? buttonStatusChanged,
    TResult Function(_OtpFilled value)? otpFilled,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements ForgetPasswordState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of ForgetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
