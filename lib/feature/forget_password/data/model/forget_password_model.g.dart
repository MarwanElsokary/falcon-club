// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_password_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForgetPasswordRequestImpl _$$ForgetPasswordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ForgetPasswordRequestImpl(phoneNumber: json['phoneNumber'] as String);

Map<String, dynamic> _$$ForgetPasswordRequestImplToJson(
  _$ForgetPasswordRequestImpl instance,
) => <String, dynamic>{'phoneNumber': instance.phoneNumber};

_$CheckOtpRequestImpl _$$CheckOtpRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CheckOtpRequestImpl(
  otp: json['otp'] as String,
  phoneNumber: json['phoneNumber'] as String,
);

Map<String, dynamic> _$$CheckOtpRequestImplToJson(
  _$CheckOtpRequestImpl instance,
) => <String, dynamic>{
  'otp': instance.otp,
  'phoneNumber': instance.phoneNumber,
};

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ResetPasswordRequestImpl(
  token: json['token'] as String,
  password: json['password'] as String,
  confirmPassword: json['ConfirmPassword'] as String,
);

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
  _$ResetPasswordRequestImpl instance,
) => <String, dynamic>{
  'token': instance.token,
  'password': instance.password,
  'ConfirmPassword': instance.confirmPassword,
};

_$ForgetPasswordResponseImpl _$$ForgetPasswordResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ForgetPasswordResponseImpl(
  message: json['message'] as String,
  token: json['token'] as String?,
);

Map<String, dynamic> _$$ForgetPasswordResponseImplToJson(
  _$ForgetPasswordResponseImpl instance,
) => <String, dynamic>{'message': instance.message, 'token': instance.token};

_$CheckOtpResponseImpl _$$CheckOtpResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CheckOtpResponseImpl(
  message: json['message'] as String,
  resetToken: json['resetToken'] as String,
);

Map<String, dynamic> _$$CheckOtpResponseImplToJson(
  _$CheckOtpResponseImpl instance,
) => <String, dynamic>{
  'message': instance.message,
  'resetToken': instance.resetToken,
};

_$ResetPasswordResponseImpl _$$ResetPasswordResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ResetPasswordResponseImpl(message: json['message'] as String);

Map<String, dynamic> _$$ResetPasswordResponseImplToJson(
  _$ResetPasswordResponseImpl instance,
) => <String, dynamic>{'message': instance.message};
