// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forget_password_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ForgetPasswordRequest _$ForgetPasswordRequestFromJson(
  Map<String, dynamic> json,
) {
  return _ForgetPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ForgetPasswordRequest {
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this ForgetPasswordRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgetPasswordRequestCopyWith<ForgetPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgetPasswordRequestCopyWith<$Res> {
  factory $ForgetPasswordRequestCopyWith(
    ForgetPasswordRequest value,
    $Res Function(ForgetPasswordRequest) then,
  ) = _$ForgetPasswordRequestCopyWithImpl<$Res, ForgetPasswordRequest>;
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class _$ForgetPasswordRequestCopyWithImpl<
  $Res,
  $Val extends ForgetPasswordRequest
>
    implements $ForgetPasswordRequestCopyWith<$Res> {
  _$ForgetPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phoneNumber = null}) {
    return _then(
      _value.copyWith(
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForgetPasswordRequestImplCopyWith<$Res>
    implements $ForgetPasswordRequestCopyWith<$Res> {
  factory _$$ForgetPasswordRequestImplCopyWith(
    _$ForgetPasswordRequestImpl value,
    $Res Function(_$ForgetPasswordRequestImpl) then,
  ) = __$$ForgetPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class __$$ForgetPasswordRequestImplCopyWithImpl<$Res>
    extends
        _$ForgetPasswordRequestCopyWithImpl<$Res, _$ForgetPasswordRequestImpl>
    implements _$$ForgetPasswordRequestImplCopyWith<$Res> {
  __$$ForgetPasswordRequestImplCopyWithImpl(
    _$ForgetPasswordRequestImpl _value,
    $Res Function(_$ForgetPasswordRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? phoneNumber = null}) {
    return _then(
      _$ForgetPasswordRequestImpl(
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgetPasswordRequestImpl implements _ForgetPasswordRequest {
  const _$ForgetPasswordRequestImpl({required this.phoneNumber});

  factory _$ForgetPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgetPasswordRequestImplFromJson(json);

  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'ForgetPasswordRequest(phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgetPasswordRequestImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber);

  /// Create a copy of ForgetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgetPasswordRequestImplCopyWith<_$ForgetPasswordRequestImpl>
  get copyWith =>
      __$$ForgetPasswordRequestImplCopyWithImpl<_$ForgetPasswordRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgetPasswordRequestImplToJson(this);
  }
}

abstract class _ForgetPasswordRequest implements ForgetPasswordRequest {
  const factory _ForgetPasswordRequest({required final String phoneNumber}) =
      _$ForgetPasswordRequestImpl;

  factory _ForgetPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ForgetPasswordRequestImpl.fromJson;

  @override
  String get phoneNumber;

  /// Create a copy of ForgetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgetPasswordRequestImplCopyWith<_$ForgetPasswordRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CheckOtpRequest _$CheckOtpRequestFromJson(Map<String, dynamic> json) {
  return _CheckOtpRequest.fromJson(json);
}

/// @nodoc
mixin _$CheckOtpRequest {
  String get otp => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this CheckOtpRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckOtpRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckOtpRequestCopyWith<CheckOtpRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckOtpRequestCopyWith<$Res> {
  factory $CheckOtpRequestCopyWith(
    CheckOtpRequest value,
    $Res Function(CheckOtpRequest) then,
  ) = _$CheckOtpRequestCopyWithImpl<$Res, CheckOtpRequest>;
  @useResult
  $Res call({String otp, String phoneNumber});
}

/// @nodoc
class _$CheckOtpRequestCopyWithImpl<$Res, $Val extends CheckOtpRequest>
    implements $CheckOtpRequestCopyWith<$Res> {
  _$CheckOtpRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckOtpRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? otp = null, Object? phoneNumber = null}) {
    return _then(
      _value.copyWith(
            otp: null == otp
                ? _value.otp
                : otp // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckOtpRequestImplCopyWith<$Res>
    implements $CheckOtpRequestCopyWith<$Res> {
  factory _$$CheckOtpRequestImplCopyWith(
    _$CheckOtpRequestImpl value,
    $Res Function(_$CheckOtpRequestImpl) then,
  ) = __$$CheckOtpRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String otp, String phoneNumber});
}

/// @nodoc
class __$$CheckOtpRequestImplCopyWithImpl<$Res>
    extends _$CheckOtpRequestCopyWithImpl<$Res, _$CheckOtpRequestImpl>
    implements _$$CheckOtpRequestImplCopyWith<$Res> {
  __$$CheckOtpRequestImplCopyWithImpl(
    _$CheckOtpRequestImpl _value,
    $Res Function(_$CheckOtpRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckOtpRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? otp = null, Object? phoneNumber = null}) {
    return _then(
      _$CheckOtpRequestImpl(
        otp: null == otp
            ? _value.otp
            : otp // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckOtpRequestImpl implements _CheckOtpRequest {
  const _$CheckOtpRequestImpl({required this.otp, required this.phoneNumber});

  factory _$CheckOtpRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckOtpRequestImplFromJson(json);

  @override
  final String otp;
  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'CheckOtpRequest(otp: $otp, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckOtpRequestImpl &&
            (identical(other.otp, otp) || other.otp == otp) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, otp, phoneNumber);

  /// Create a copy of CheckOtpRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckOtpRequestImplCopyWith<_$CheckOtpRequestImpl> get copyWith =>
      __$$CheckOtpRequestImplCopyWithImpl<_$CheckOtpRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckOtpRequestImplToJson(this);
  }
}

abstract class _CheckOtpRequest implements CheckOtpRequest {
  const factory _CheckOtpRequest({
    required final String otp,
    required final String phoneNumber,
  }) = _$CheckOtpRequestImpl;

  factory _CheckOtpRequest.fromJson(Map<String, dynamic> json) =
      _$CheckOtpRequestImpl.fromJson;

  @override
  String get otp;
  @override
  String get phoneNumber;

  /// Create a copy of CheckOtpRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckOtpRequestImplCopyWith<_$CheckOtpRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResetPasswordRequest _$ResetPasswordRequestFromJson(Map<String, dynamic> json) {
  return _ResetPasswordRequest.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordRequest {
  String get token => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  @JsonKey(name: 'ConfirmPassword')
  String get confirmPassword => throw _privateConstructorUsedError;

  /// Serializes this ResetPasswordRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResetPasswordRequestCopyWith<ResetPasswordRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordRequestCopyWith<$Res> {
  factory $ResetPasswordRequestCopyWith(
    ResetPasswordRequest value,
    $Res Function(ResetPasswordRequest) then,
  ) = _$ResetPasswordRequestCopyWithImpl<$Res, ResetPasswordRequest>;
  @useResult
  $Res call({
    String token,
    String password,
    @JsonKey(name: 'ConfirmPassword') String confirmPassword,
  });
}

/// @nodoc
class _$ResetPasswordRequestCopyWithImpl<
  $Res,
  $Val extends ResetPasswordRequest
>
    implements $ResetPasswordRequestCopyWith<$Res> {
  _$ResetPasswordRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? password = null,
    Object? confirmPassword = null,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            confirmPassword: null == confirmPassword
                ? _value.confirmPassword
                : confirmPassword // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResetPasswordRequestImplCopyWith<$Res>
    implements $ResetPasswordRequestCopyWith<$Res> {
  factory _$$ResetPasswordRequestImplCopyWith(
    _$ResetPasswordRequestImpl value,
    $Res Function(_$ResetPasswordRequestImpl) then,
  ) = __$$ResetPasswordRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    String password,
    @JsonKey(name: 'ConfirmPassword') String confirmPassword,
  });
}

/// @nodoc
class __$$ResetPasswordRequestImplCopyWithImpl<$Res>
    extends _$ResetPasswordRequestCopyWithImpl<$Res, _$ResetPasswordRequestImpl>
    implements _$$ResetPasswordRequestImplCopyWith<$Res> {
  __$$ResetPasswordRequestImplCopyWithImpl(
    _$ResetPasswordRequestImpl _value,
    $Res Function(_$ResetPasswordRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? password = null,
    Object? confirmPassword = null,
  }) {
    return _then(
      _$ResetPasswordRequestImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        confirmPassword: null == confirmPassword
            ? _value.confirmPassword
            : confirmPassword // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ResetPasswordRequestImpl implements _ResetPasswordRequest {
  const _$ResetPasswordRequestImpl({
    required this.token,
    required this.password,
    @JsonKey(name: 'ConfirmPassword') required this.confirmPassword,
  });

  factory _$ResetPasswordRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPasswordRequestImplFromJson(json);

  @override
  final String token;
  @override
  final String password;
  @override
  @JsonKey(name: 'ConfirmPassword')
  final String confirmPassword;

  @override
  String toString() {
    return 'ResetPasswordRequest(token: $token, password: $password, confirmPassword: $confirmPassword)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordRequestImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, token, password, confirmPassword);

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
  get copyWith =>
      __$$ResetPasswordRequestImplCopyWithImpl<_$ResetPasswordRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPasswordRequestImplToJson(this);
  }
}

abstract class _ResetPasswordRequest implements ResetPasswordRequest {
  const factory _ResetPasswordRequest({
    required final String token,
    required final String password,
    @JsonKey(name: 'ConfirmPassword') required final String confirmPassword,
  }) = _$ResetPasswordRequestImpl;

  factory _ResetPasswordRequest.fromJson(Map<String, dynamic> json) =
      _$ResetPasswordRequestImpl.fromJson;

  @override
  String get token;
  @override
  String get password;
  @override
  @JsonKey(name: 'ConfirmPassword')
  String get confirmPassword;

  /// Create a copy of ResetPasswordRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordRequestImplCopyWith<_$ResetPasswordRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ForgetPasswordResponse _$ForgetPasswordResponseFromJson(
  Map<String, dynamic> json,
) {
  return _ForgetPasswordResponse.fromJson(json);
}

/// @nodoc
mixin _$ForgetPasswordResponse {
  String get message => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;

  /// Serializes this ForgetPasswordResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgetPasswordResponseCopyWith<ForgetPasswordResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgetPasswordResponseCopyWith<$Res> {
  factory $ForgetPasswordResponseCopyWith(
    ForgetPasswordResponse value,
    $Res Function(ForgetPasswordResponse) then,
  ) = _$ForgetPasswordResponseCopyWithImpl<$Res, ForgetPasswordResponse>;
  @useResult
  $Res call({String message, String? token});
}

/// @nodoc
class _$ForgetPasswordResponseCopyWithImpl<
  $Res,
  $Val extends ForgetPasswordResponse
>
    implements $ForgetPasswordResponseCopyWith<$Res> {
  _$ForgetPasswordResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? token = freezed}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ForgetPasswordResponseImplCopyWith<$Res>
    implements $ForgetPasswordResponseCopyWith<$Res> {
  factory _$$ForgetPasswordResponseImplCopyWith(
    _$ForgetPasswordResponseImpl value,
    $Res Function(_$ForgetPasswordResponseImpl) then,
  ) = __$$ForgetPasswordResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? token});
}

/// @nodoc
class __$$ForgetPasswordResponseImplCopyWithImpl<$Res>
    extends
        _$ForgetPasswordResponseCopyWithImpl<$Res, _$ForgetPasswordResponseImpl>
    implements _$$ForgetPasswordResponseImplCopyWith<$Res> {
  __$$ForgetPasswordResponseImplCopyWithImpl(
    _$ForgetPasswordResponseImpl _value,
    $Res Function(_$ForgetPasswordResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ForgetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? token = freezed}) {
    return _then(
      _$ForgetPasswordResponseImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgetPasswordResponseImpl implements _ForgetPasswordResponse {
  const _$ForgetPasswordResponseImpl({required this.message, this.token});

  factory _$ForgetPasswordResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ForgetPasswordResponseImplFromJson(json);

  @override
  final String message;
  @override
  final String? token;

  @override
  String toString() {
    return 'ForgetPasswordResponse(message: $message, token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgetPasswordResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, token);

  /// Create a copy of ForgetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgetPasswordResponseImplCopyWith<_$ForgetPasswordResponseImpl>
  get copyWith =>
      __$$ForgetPasswordResponseImplCopyWithImpl<_$ForgetPasswordResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgetPasswordResponseImplToJson(this);
  }
}

abstract class _ForgetPasswordResponse implements ForgetPasswordResponse {
  const factory _ForgetPasswordResponse({
    required final String message,
    final String? token,
  }) = _$ForgetPasswordResponseImpl;

  factory _ForgetPasswordResponse.fromJson(Map<String, dynamic> json) =
      _$ForgetPasswordResponseImpl.fromJson;

  @override
  String get message;
  @override
  String? get token;

  /// Create a copy of ForgetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgetPasswordResponseImplCopyWith<_$ForgetPasswordResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CheckOtpResponse _$CheckOtpResponseFromJson(Map<String, dynamic> json) {
  return _CheckOtpResponse.fromJson(json);
}

/// @nodoc
mixin _$CheckOtpResponse {
  String get message => throw _privateConstructorUsedError;
  String get resetToken => throw _privateConstructorUsedError;

  /// Serializes this CheckOtpResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckOtpResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckOtpResponseCopyWith<CheckOtpResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckOtpResponseCopyWith<$Res> {
  factory $CheckOtpResponseCopyWith(
    CheckOtpResponse value,
    $Res Function(CheckOtpResponse) then,
  ) = _$CheckOtpResponseCopyWithImpl<$Res, CheckOtpResponse>;
  @useResult
  $Res call({String message, String resetToken});
}

/// @nodoc
class _$CheckOtpResponseCopyWithImpl<$Res, $Val extends CheckOtpResponse>
    implements $CheckOtpResponseCopyWith<$Res> {
  _$CheckOtpResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckOtpResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? resetToken = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            resetToken: null == resetToken
                ? _value.resetToken
                : resetToken // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckOtpResponseImplCopyWith<$Res>
    implements $CheckOtpResponseCopyWith<$Res> {
  factory _$$CheckOtpResponseImplCopyWith(
    _$CheckOtpResponseImpl value,
    $Res Function(_$CheckOtpResponseImpl) then,
  ) = __$$CheckOtpResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String resetToken});
}

/// @nodoc
class __$$CheckOtpResponseImplCopyWithImpl<$Res>
    extends _$CheckOtpResponseCopyWithImpl<$Res, _$CheckOtpResponseImpl>
    implements _$$CheckOtpResponseImplCopyWith<$Res> {
  __$$CheckOtpResponseImplCopyWithImpl(
    _$CheckOtpResponseImpl _value,
    $Res Function(_$CheckOtpResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckOtpResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? resetToken = null}) {
    return _then(
      _$CheckOtpResponseImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        resetToken: null == resetToken
            ? _value.resetToken
            : resetToken // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckOtpResponseImpl implements _CheckOtpResponse {
  const _$CheckOtpResponseImpl({
    required this.message,
    required this.resetToken,
  });

  factory _$CheckOtpResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckOtpResponseImplFromJson(json);

  @override
  final String message;
  @override
  final String resetToken;

  @override
  String toString() {
    return 'CheckOtpResponse(message: $message, resetToken: $resetToken)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckOtpResponseImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.resetToken, resetToken) ||
                other.resetToken == resetToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message, resetToken);

  /// Create a copy of CheckOtpResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckOtpResponseImplCopyWith<_$CheckOtpResponseImpl> get copyWith =>
      __$$CheckOtpResponseImplCopyWithImpl<_$CheckOtpResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckOtpResponseImplToJson(this);
  }
}

abstract class _CheckOtpResponse implements CheckOtpResponse {
  const factory _CheckOtpResponse({
    required final String message,
    required final String resetToken,
  }) = _$CheckOtpResponseImpl;

  factory _CheckOtpResponse.fromJson(Map<String, dynamic> json) =
      _$CheckOtpResponseImpl.fromJson;

  @override
  String get message;
  @override
  String get resetToken;

  /// Create a copy of CheckOtpResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckOtpResponseImplCopyWith<_$CheckOtpResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResetPasswordResponse _$ResetPasswordResponseFromJson(
  Map<String, dynamic> json,
) {
  return _ResetPasswordResponse.fromJson(json);
}

/// @nodoc
mixin _$ResetPasswordResponse {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this ResetPasswordResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResetPasswordResponseCopyWith<ResetPasswordResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordResponseCopyWith<$Res> {
  factory $ResetPasswordResponseCopyWith(
    ResetPasswordResponse value,
    $Res Function(ResetPasswordResponse) then,
  ) = _$ResetPasswordResponseCopyWithImpl<$Res, ResetPasswordResponse>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$ResetPasswordResponseCopyWithImpl<
  $Res,
  $Val extends ResetPasswordResponse
>
    implements $ResetPasswordResponseCopyWith<$Res> {
  _$ResetPasswordResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ResetPasswordResponseImplCopyWith<$Res>
    implements $ResetPasswordResponseCopyWith<$Res> {
  factory _$$ResetPasswordResponseImplCopyWith(
    _$ResetPasswordResponseImpl value,
    $Res Function(_$ResetPasswordResponseImpl) then,
  ) = __$$ResetPasswordResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ResetPasswordResponseImplCopyWithImpl<$Res>
    extends
        _$ResetPasswordResponseCopyWithImpl<$Res, _$ResetPasswordResponseImpl>
    implements _$$ResetPasswordResponseImplCopyWith<$Res> {
  __$$ResetPasswordResponseImplCopyWithImpl(
    _$ResetPasswordResponseImpl _value,
    $Res Function(_$ResetPasswordResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ResetPasswordResponseImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ResetPasswordResponseImpl implements _ResetPasswordResponse {
  const _$ResetPasswordResponseImpl({required this.message});

  factory _$ResetPasswordResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResetPasswordResponseImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'ResetPasswordResponse(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordResponseImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of ResetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordResponseImplCopyWith<_$ResetPasswordResponseImpl>
  get copyWith =>
      __$$ResetPasswordResponseImplCopyWithImpl<_$ResetPasswordResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ResetPasswordResponseImplToJson(this);
  }
}

abstract class _ResetPasswordResponse implements ResetPasswordResponse {
  const factory _ResetPasswordResponse({required final String message}) =
      _$ResetPasswordResponseImpl;

  factory _ResetPasswordResponse.fromJson(Map<String, dynamic> json) =
      _$ResetPasswordResponseImpl.fromJson;

  @override
  String get message;

  /// Create a copy of ResetPasswordResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordResponseImplCopyWith<_$ResetPasswordResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
