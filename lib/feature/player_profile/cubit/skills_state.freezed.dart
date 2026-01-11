// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'skills_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SkillsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Skill skillsModel) success,
    required TResult Function(String error) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Skill skillsModel)? success,
    TResult? Function(String error)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Skill skillsModel)? success,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SkillsLoading value) loading,
    required TResult Function(SkillsSuccess value) success,
    required TResult Function(SkillsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SkillsLoading value)? loading,
    TResult? Function(SkillsSuccess value)? success,
    TResult? Function(SkillsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SkillsLoading value)? loading,
    TResult Function(SkillsSuccess value)? success,
    TResult Function(SkillsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillsStateCopyWith<$Res> {
  factory $SkillsStateCopyWith(
    SkillsState value,
    $Res Function(SkillsState) then,
  ) = _$SkillsStateCopyWithImpl<$Res, SkillsState>;
}

/// @nodoc
class _$SkillsStateCopyWithImpl<$Res, $Val extends SkillsState>
    implements $SkillsStateCopyWith<$Res> {
  _$SkillsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SkillsState
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
    extends _$SkillsStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'SkillsState.initial()';
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
    required TResult Function(Skill skillsModel) success,
    required TResult Function(String error) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Skill skillsModel)? success,
    TResult? Function(String error)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Skill skillsModel)? success,
    TResult Function(String error)? error,
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
    required TResult Function(SkillsLoading value) loading,
    required TResult Function(SkillsSuccess value) success,
    required TResult Function(SkillsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SkillsLoading value)? loading,
    TResult? Function(SkillsSuccess value)? success,
    TResult? Function(SkillsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SkillsLoading value)? loading,
    TResult Function(SkillsSuccess value)? success,
    TResult Function(SkillsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements SkillsState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$SkillsLoadingImplCopyWith<$Res> {
  factory _$$SkillsLoadingImplCopyWith(
    _$SkillsLoadingImpl value,
    $Res Function(_$SkillsLoadingImpl) then,
  ) = __$$SkillsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SkillsLoadingImplCopyWithImpl<$Res>
    extends _$SkillsStateCopyWithImpl<$Res, _$SkillsLoadingImpl>
    implements _$$SkillsLoadingImplCopyWith<$Res> {
  __$$SkillsLoadingImplCopyWithImpl(
    _$SkillsLoadingImpl _value,
    $Res Function(_$SkillsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SkillsLoadingImpl implements SkillsLoading {
  const _$SkillsLoadingImpl();

  @override
  String toString() {
    return 'SkillsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SkillsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Skill skillsModel) success,
    required TResult Function(String error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Skill skillsModel)? success,
    TResult? Function(String error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Skill skillsModel)? success,
    TResult Function(String error)? error,
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
    required TResult Function(SkillsLoading value) loading,
    required TResult Function(SkillsSuccess value) success,
    required TResult Function(SkillsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SkillsLoading value)? loading,
    TResult? Function(SkillsSuccess value)? success,
    TResult? Function(SkillsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SkillsLoading value)? loading,
    TResult Function(SkillsSuccess value)? success,
    TResult Function(SkillsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SkillsLoading implements SkillsState {
  const factory SkillsLoading() = _$SkillsLoadingImpl;
}

/// @nodoc
abstract class _$$SkillsSuccessImplCopyWith<$Res> {
  factory _$$SkillsSuccessImplCopyWith(
    _$SkillsSuccessImpl value,
    $Res Function(_$SkillsSuccessImpl) then,
  ) = __$$SkillsSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Skill skillsModel});
}

/// @nodoc
class __$$SkillsSuccessImplCopyWithImpl<$Res>
    extends _$SkillsStateCopyWithImpl<$Res, _$SkillsSuccessImpl>
    implements _$$SkillsSuccessImplCopyWith<$Res> {
  __$$SkillsSuccessImplCopyWithImpl(
    _$SkillsSuccessImpl _value,
    $Res Function(_$SkillsSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? skillsModel = null}) {
    return _then(
      _$SkillsSuccessImpl(
        null == skillsModel
            ? _value.skillsModel
            : skillsModel // ignore: cast_nullable_to_non_nullable
                  as Skill,
      ),
    );
  }
}

/// @nodoc

class _$SkillsSuccessImpl implements SkillsSuccess {
  const _$SkillsSuccessImpl(this.skillsModel);

  @override
  final Skill skillsModel;

  @override
  String toString() {
    return 'SkillsState.success(skillsModel: $skillsModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillsSuccessImpl &&
            (identical(other.skillsModel, skillsModel) ||
                other.skillsModel == skillsModel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, skillsModel);

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillsSuccessImplCopyWith<_$SkillsSuccessImpl> get copyWith =>
      __$$SkillsSuccessImplCopyWithImpl<_$SkillsSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Skill skillsModel) success,
    required TResult Function(String error) error,
  }) {
    return success(skillsModel);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Skill skillsModel)? success,
    TResult? Function(String error)? error,
  }) {
    return success?.call(skillsModel);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Skill skillsModel)? success,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(skillsModel);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SkillsLoading value) loading,
    required TResult Function(SkillsSuccess value) success,
    required TResult Function(SkillsError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SkillsLoading value)? loading,
    TResult? Function(SkillsSuccess value)? success,
    TResult? Function(SkillsError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SkillsLoading value)? loading,
    TResult Function(SkillsSuccess value)? success,
    TResult Function(SkillsError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SkillsSuccess implements SkillsState {
  const factory SkillsSuccess(final Skill skillsModel) = _$SkillsSuccessImpl;

  Skill get skillsModel;

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillsSuccessImplCopyWith<_$SkillsSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SkillsErrorImplCopyWith<$Res> {
  factory _$$SkillsErrorImplCopyWith(
    _$SkillsErrorImpl value,
    $Res Function(_$SkillsErrorImpl) then,
  ) = __$$SkillsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$SkillsErrorImplCopyWithImpl<$Res>
    extends _$SkillsStateCopyWithImpl<$Res, _$SkillsErrorImpl>
    implements _$$SkillsErrorImplCopyWith<$Res> {
  __$$SkillsErrorImplCopyWithImpl(
    _$SkillsErrorImpl _value,
    $Res Function(_$SkillsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$SkillsErrorImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SkillsErrorImpl implements SkillsError {
  const _$SkillsErrorImpl({required this.error});

  @override
  final String error;

  @override
  String toString() {
    return 'SkillsState.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillsErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillsErrorImplCopyWith<_$SkillsErrorImpl> get copyWith =>
      __$$SkillsErrorImplCopyWithImpl<_$SkillsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(Skill skillsModel) success,
    required TResult Function(String error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(Skill skillsModel)? success,
    TResult? Function(String error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(Skill skillsModel)? success,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SkillsLoading value) loading,
    required TResult Function(SkillsSuccess value) success,
    required TResult Function(SkillsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SkillsLoading value)? loading,
    TResult? Function(SkillsSuccess value)? success,
    TResult? Function(SkillsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SkillsLoading value)? loading,
    TResult Function(SkillsSuccess value)? success,
    TResult Function(SkillsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SkillsError implements SkillsState {
  const factory SkillsError({required final String error}) = _$SkillsErrorImpl;

  String get error;

  /// Create a copy of SkillsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillsErrorImplCopyWith<_$SkillsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
