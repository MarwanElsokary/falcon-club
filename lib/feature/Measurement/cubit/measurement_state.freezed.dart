// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MeasurementState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() uploadLoading,
    required TResult Function(int progress) uploadProgress,
    required TResult Function(MeasurementModel measurement) uploadSuccess,
    required TResult Function(String error) uploadError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? uploadLoading,
    TResult? Function(int progress)? uploadProgress,
    TResult? Function(MeasurementModel measurement)? uploadSuccess,
    TResult? Function(String error)? uploadError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? uploadLoading,
    TResult Function(int progress)? uploadProgress,
    TResult Function(MeasurementModel measurement)? uploadSuccess,
    TResult Function(String error)? uploadError,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MeasurementInitial value) initial,
    required TResult Function(UploadLoading value) uploadLoading,
    required TResult Function(UploadProgress value) uploadProgress,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(UploadError value) uploadError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MeasurementInitial value)? initial,
    TResult? Function(UploadLoading value)? uploadLoading,
    TResult? Function(UploadProgress value)? uploadProgress,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(UploadError value)? uploadError,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MeasurementInitial value)? initial,
    TResult Function(UploadLoading value)? uploadLoading,
    TResult Function(UploadProgress value)? uploadProgress,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(UploadError value)? uploadError,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeasurementStateCopyWith<$Res> {
  factory $MeasurementStateCopyWith(
    MeasurementState value,
    $Res Function(MeasurementState) then,
  ) = _$MeasurementStateCopyWithImpl<$Res, MeasurementState>;
}

/// @nodoc
class _$MeasurementStateCopyWithImpl<$Res, $Val extends MeasurementState>
    implements $MeasurementStateCopyWith<$Res> {
  _$MeasurementStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MeasurementInitialImplCopyWith<$Res> {
  factory _$$MeasurementInitialImplCopyWith(
    _$MeasurementInitialImpl value,
    $Res Function(_$MeasurementInitialImpl) then,
  ) = __$$MeasurementInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MeasurementInitialImplCopyWithImpl<$Res>
    extends _$MeasurementStateCopyWithImpl<$Res, _$MeasurementInitialImpl>
    implements _$$MeasurementInitialImplCopyWith<$Res> {
  __$$MeasurementInitialImplCopyWithImpl(
    _$MeasurementInitialImpl _value,
    $Res Function(_$MeasurementInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$MeasurementInitialImpl implements MeasurementInitial {
  const _$MeasurementInitialImpl();

  @override
  String toString() {
    return 'MeasurementState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MeasurementInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() uploadLoading,
    required TResult Function(int progress) uploadProgress,
    required TResult Function(MeasurementModel measurement) uploadSuccess,
    required TResult Function(String error) uploadError,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? uploadLoading,
    TResult? Function(int progress)? uploadProgress,
    TResult? Function(MeasurementModel measurement)? uploadSuccess,
    TResult? Function(String error)? uploadError,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? uploadLoading,
    TResult Function(int progress)? uploadProgress,
    TResult Function(MeasurementModel measurement)? uploadSuccess,
    TResult Function(String error)? uploadError,
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
    required TResult Function(MeasurementInitial value) initial,
    required TResult Function(UploadLoading value) uploadLoading,
    required TResult Function(UploadProgress value) uploadProgress,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(UploadError value) uploadError,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MeasurementInitial value)? initial,
    TResult? Function(UploadLoading value)? uploadLoading,
    TResult? Function(UploadProgress value)? uploadProgress,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(UploadError value)? uploadError,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MeasurementInitial value)? initial,
    TResult Function(UploadLoading value)? uploadLoading,
    TResult Function(UploadProgress value)? uploadProgress,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(UploadError value)? uploadError,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class MeasurementInitial implements MeasurementState {
  const factory MeasurementInitial() = _$MeasurementInitialImpl;
}

/// @nodoc
abstract class _$$UploadLoadingImplCopyWith<$Res> {
  factory _$$UploadLoadingImplCopyWith(
    _$UploadLoadingImpl value,
    $Res Function(_$UploadLoadingImpl) then,
  ) = __$$UploadLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UploadLoadingImplCopyWithImpl<$Res>
    extends _$MeasurementStateCopyWithImpl<$Res, _$UploadLoadingImpl>
    implements _$$UploadLoadingImplCopyWith<$Res> {
  __$$UploadLoadingImplCopyWithImpl(
    _$UploadLoadingImpl _value,
    $Res Function(_$UploadLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UploadLoadingImpl implements UploadLoading {
  const _$UploadLoadingImpl();

  @override
  String toString() {
    return 'MeasurementState.uploadLoading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UploadLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() uploadLoading,
    required TResult Function(int progress) uploadProgress,
    required TResult Function(MeasurementModel measurement) uploadSuccess,
    required TResult Function(String error) uploadError,
  }) {
    return uploadLoading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? uploadLoading,
    TResult? Function(int progress)? uploadProgress,
    TResult? Function(MeasurementModel measurement)? uploadSuccess,
    TResult? Function(String error)? uploadError,
  }) {
    return uploadLoading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? uploadLoading,
    TResult Function(int progress)? uploadProgress,
    TResult Function(MeasurementModel measurement)? uploadSuccess,
    TResult Function(String error)? uploadError,
    required TResult orElse(),
  }) {
    if (uploadLoading != null) {
      return uploadLoading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MeasurementInitial value) initial,
    required TResult Function(UploadLoading value) uploadLoading,
    required TResult Function(UploadProgress value) uploadProgress,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(UploadError value) uploadError,
  }) {
    return uploadLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MeasurementInitial value)? initial,
    TResult? Function(UploadLoading value)? uploadLoading,
    TResult? Function(UploadProgress value)? uploadProgress,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(UploadError value)? uploadError,
  }) {
    return uploadLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MeasurementInitial value)? initial,
    TResult Function(UploadLoading value)? uploadLoading,
    TResult Function(UploadProgress value)? uploadProgress,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(UploadError value)? uploadError,
    required TResult orElse(),
  }) {
    if (uploadLoading != null) {
      return uploadLoading(this);
    }
    return orElse();
  }
}

abstract class UploadLoading implements MeasurementState {
  const factory UploadLoading() = _$UploadLoadingImpl;
}

/// @nodoc
abstract class _$$UploadProgressImplCopyWith<$Res> {
  factory _$$UploadProgressImplCopyWith(
    _$UploadProgressImpl value,
    $Res Function(_$UploadProgressImpl) then,
  ) = __$$UploadProgressImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int progress});
}

/// @nodoc
class __$$UploadProgressImplCopyWithImpl<$Res>
    extends _$MeasurementStateCopyWithImpl<$Res, _$UploadProgressImpl>
    implements _$$UploadProgressImplCopyWith<$Res> {
  __$$UploadProgressImplCopyWithImpl(
    _$UploadProgressImpl _value,
    $Res Function(_$UploadProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? progress = null}) {
    return _then(
      _$UploadProgressImpl(
        null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$UploadProgressImpl implements UploadProgress {
  const _$UploadProgressImpl(this.progress);

  @override
  final int progress;

  @override
  String toString() {
    return 'MeasurementState.uploadProgress(progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadProgressImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progress);

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadProgressImplCopyWith<_$UploadProgressImpl> get copyWith =>
      __$$UploadProgressImplCopyWithImpl<_$UploadProgressImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() uploadLoading,
    required TResult Function(int progress) uploadProgress,
    required TResult Function(MeasurementModel measurement) uploadSuccess,
    required TResult Function(String error) uploadError,
  }) {
    return uploadProgress(progress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? uploadLoading,
    TResult? Function(int progress)? uploadProgress,
    TResult? Function(MeasurementModel measurement)? uploadSuccess,
    TResult? Function(String error)? uploadError,
  }) {
    return uploadProgress?.call(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? uploadLoading,
    TResult Function(int progress)? uploadProgress,
    TResult Function(MeasurementModel measurement)? uploadSuccess,
    TResult Function(String error)? uploadError,
    required TResult orElse(),
  }) {
    if (uploadProgress != null) {
      return uploadProgress(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MeasurementInitial value) initial,
    required TResult Function(UploadLoading value) uploadLoading,
    required TResult Function(UploadProgress value) uploadProgress,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(UploadError value) uploadError,
  }) {
    return uploadProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MeasurementInitial value)? initial,
    TResult? Function(UploadLoading value)? uploadLoading,
    TResult? Function(UploadProgress value)? uploadProgress,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(UploadError value)? uploadError,
  }) {
    return uploadProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MeasurementInitial value)? initial,
    TResult Function(UploadLoading value)? uploadLoading,
    TResult Function(UploadProgress value)? uploadProgress,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(UploadError value)? uploadError,
    required TResult orElse(),
  }) {
    if (uploadProgress != null) {
      return uploadProgress(this);
    }
    return orElse();
  }
}

abstract class UploadProgress implements MeasurementState {
  const factory UploadProgress(final int progress) = _$UploadProgressImpl;

  int get progress;

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadProgressImplCopyWith<_$UploadProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadSuccessImplCopyWith<$Res> {
  factory _$$UploadSuccessImplCopyWith(
    _$UploadSuccessImpl value,
    $Res Function(_$UploadSuccessImpl) then,
  ) = __$$UploadSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({MeasurementModel measurement});
}

/// @nodoc
class __$$UploadSuccessImplCopyWithImpl<$Res>
    extends _$MeasurementStateCopyWithImpl<$Res, _$UploadSuccessImpl>
    implements _$$UploadSuccessImplCopyWith<$Res> {
  __$$UploadSuccessImplCopyWithImpl(
    _$UploadSuccessImpl _value,
    $Res Function(_$UploadSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? measurement = null}) {
    return _then(
      _$UploadSuccessImpl(
        null == measurement
            ? _value.measurement
            : measurement // ignore: cast_nullable_to_non_nullable
                  as MeasurementModel,
      ),
    );
  }
}

/// @nodoc

class _$UploadSuccessImpl implements UploadSuccess {
  const _$UploadSuccessImpl(this.measurement);

  @override
  final MeasurementModel measurement;

  @override
  String toString() {
    return 'MeasurementState.uploadSuccess(measurement: $measurement)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadSuccessImpl &&
            (identical(other.measurement, measurement) ||
                other.measurement == measurement));
  }

  @override
  int get hashCode => Object.hash(runtimeType, measurement);

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadSuccessImplCopyWith<_$UploadSuccessImpl> get copyWith =>
      __$$UploadSuccessImplCopyWithImpl<_$UploadSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() uploadLoading,
    required TResult Function(int progress) uploadProgress,
    required TResult Function(MeasurementModel measurement) uploadSuccess,
    required TResult Function(String error) uploadError,
  }) {
    return uploadSuccess(measurement);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? uploadLoading,
    TResult? Function(int progress)? uploadProgress,
    TResult? Function(MeasurementModel measurement)? uploadSuccess,
    TResult? Function(String error)? uploadError,
  }) {
    return uploadSuccess?.call(measurement);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? uploadLoading,
    TResult Function(int progress)? uploadProgress,
    TResult Function(MeasurementModel measurement)? uploadSuccess,
    TResult Function(String error)? uploadError,
    required TResult orElse(),
  }) {
    if (uploadSuccess != null) {
      return uploadSuccess(measurement);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MeasurementInitial value) initial,
    required TResult Function(UploadLoading value) uploadLoading,
    required TResult Function(UploadProgress value) uploadProgress,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(UploadError value) uploadError,
  }) {
    return uploadSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MeasurementInitial value)? initial,
    TResult? Function(UploadLoading value)? uploadLoading,
    TResult? Function(UploadProgress value)? uploadProgress,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(UploadError value)? uploadError,
  }) {
    return uploadSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MeasurementInitial value)? initial,
    TResult Function(UploadLoading value)? uploadLoading,
    TResult Function(UploadProgress value)? uploadProgress,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(UploadError value)? uploadError,
    required TResult orElse(),
  }) {
    if (uploadSuccess != null) {
      return uploadSuccess(this);
    }
    return orElse();
  }
}

abstract class UploadSuccess implements MeasurementState {
  const factory UploadSuccess(final MeasurementModel measurement) =
      _$UploadSuccessImpl;

  MeasurementModel get measurement;

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadSuccessImplCopyWith<_$UploadSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UploadErrorImplCopyWith<$Res> {
  factory _$$UploadErrorImplCopyWith(
    _$UploadErrorImpl value,
    $Res Function(_$UploadErrorImpl) then,
  ) = __$$UploadErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$UploadErrorImplCopyWithImpl<$Res>
    extends _$MeasurementStateCopyWithImpl<$Res, _$UploadErrorImpl>
    implements _$$UploadErrorImplCopyWith<$Res> {
  __$$UploadErrorImplCopyWithImpl(
    _$UploadErrorImpl _value,
    $Res Function(_$UploadErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$UploadErrorImpl(
        null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UploadErrorImpl implements UploadError {
  const _$UploadErrorImpl(this.error);

  @override
  final String error;

  @override
  String toString() {
    return 'MeasurementState.uploadError(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadErrorImplCopyWith<_$UploadErrorImpl> get copyWith =>
      __$$UploadErrorImplCopyWithImpl<_$UploadErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() uploadLoading,
    required TResult Function(int progress) uploadProgress,
    required TResult Function(MeasurementModel measurement) uploadSuccess,
    required TResult Function(String error) uploadError,
  }) {
    return uploadError(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? uploadLoading,
    TResult? Function(int progress)? uploadProgress,
    TResult? Function(MeasurementModel measurement)? uploadSuccess,
    TResult? Function(String error)? uploadError,
  }) {
    return uploadError?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? uploadLoading,
    TResult Function(int progress)? uploadProgress,
    TResult Function(MeasurementModel measurement)? uploadSuccess,
    TResult Function(String error)? uploadError,
    required TResult orElse(),
  }) {
    if (uploadError != null) {
      return uploadError(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MeasurementInitial value) initial,
    required TResult Function(UploadLoading value) uploadLoading,
    required TResult Function(UploadProgress value) uploadProgress,
    required TResult Function(UploadSuccess value) uploadSuccess,
    required TResult Function(UploadError value) uploadError,
  }) {
    return uploadError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MeasurementInitial value)? initial,
    TResult? Function(UploadLoading value)? uploadLoading,
    TResult? Function(UploadProgress value)? uploadProgress,
    TResult? Function(UploadSuccess value)? uploadSuccess,
    TResult? Function(UploadError value)? uploadError,
  }) {
    return uploadError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MeasurementInitial value)? initial,
    TResult Function(UploadLoading value)? uploadLoading,
    TResult Function(UploadProgress value)? uploadProgress,
    TResult Function(UploadSuccess value)? uploadSuccess,
    TResult Function(UploadError value)? uploadError,
    required TResult orElse(),
  }) {
    if (uploadError != null) {
      return uploadError(this);
    }
    return orElse();
  }
}

abstract class UploadError implements MeasurementState {
  const factory UploadError(final String error) = _$UploadErrorImpl;

  String get error;

  /// Create a copy of MeasurementState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadErrorImplCopyWith<_$UploadErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
