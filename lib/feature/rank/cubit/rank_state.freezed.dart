// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rank_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RankState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() rankloading,
    required TResult Function() ranksuccess,
    required TResult Function(String error) rankerror,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? rankloading,
    TResult? Function()? ranksuccess,
    TResult? Function(String error)? rankerror,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? rankloading,
    TResult Function()? ranksuccess,
    TResult Function(String error)? rankerror,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(rankLoading value) rankloading,
    required TResult Function(rankSuccess value) ranksuccess,
    required TResult Function(rankError value) rankerror,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(rankLoading value)? rankloading,
    TResult? Function(rankSuccess value)? ranksuccess,
    TResult? Function(rankError value)? rankerror,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(rankLoading value)? rankloading,
    TResult Function(rankSuccess value)? ranksuccess,
    TResult Function(rankError value)? rankerror,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankStateCopyWith<$Res> {
  factory $RankStateCopyWith(RankState value, $Res Function(RankState) then) =
      _$RankStateCopyWithImpl<$Res, RankState>;
}

/// @nodoc
class _$RankStateCopyWithImpl<$Res, $Val extends RankState>
    implements $RankStateCopyWith<$Res> {
  _$RankStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RankState
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
    extends _$RankStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'RankState.initial()';
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
    required TResult Function() rankloading,
    required TResult Function() ranksuccess,
    required TResult Function(String error) rankerror,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? rankloading,
    TResult? Function()? ranksuccess,
    TResult? Function(String error)? rankerror,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? rankloading,
    TResult Function()? ranksuccess,
    TResult Function(String error)? rankerror,
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
    required TResult Function(rankLoading value) rankloading,
    required TResult Function(rankSuccess value) ranksuccess,
    required TResult Function(rankError value) rankerror,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(rankLoading value)? rankloading,
    TResult? Function(rankSuccess value)? ranksuccess,
    TResult? Function(rankError value)? rankerror,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(rankLoading value)? rankloading,
    TResult Function(rankSuccess value)? ranksuccess,
    TResult Function(rankError value)? rankerror,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements RankState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$rankLoadingImplCopyWith<$Res> {
  factory _$$rankLoadingImplCopyWith(
    _$rankLoadingImpl value,
    $Res Function(_$rankLoadingImpl) then,
  ) = __$$rankLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$rankLoadingImplCopyWithImpl<$Res>
    extends _$RankStateCopyWithImpl<$Res, _$rankLoadingImpl>
    implements _$$rankLoadingImplCopyWith<$Res> {
  __$$rankLoadingImplCopyWithImpl(
    _$rankLoadingImpl _value,
    $Res Function(_$rankLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$rankLoadingImpl implements rankLoading {
  const _$rankLoadingImpl();

  @override
  String toString() {
    return 'RankState.rankloading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$rankLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() rankloading,
    required TResult Function() ranksuccess,
    required TResult Function(String error) rankerror,
  }) {
    return rankloading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? rankloading,
    TResult? Function()? ranksuccess,
    TResult? Function(String error)? rankerror,
  }) {
    return rankloading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? rankloading,
    TResult Function()? ranksuccess,
    TResult Function(String error)? rankerror,
    required TResult orElse(),
  }) {
    if (rankloading != null) {
      return rankloading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(rankLoading value) rankloading,
    required TResult Function(rankSuccess value) ranksuccess,
    required TResult Function(rankError value) rankerror,
  }) {
    return rankloading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(rankLoading value)? rankloading,
    TResult? Function(rankSuccess value)? ranksuccess,
    TResult? Function(rankError value)? rankerror,
  }) {
    return rankloading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(rankLoading value)? rankloading,
    TResult Function(rankSuccess value)? ranksuccess,
    TResult Function(rankError value)? rankerror,
    required TResult orElse(),
  }) {
    if (rankloading != null) {
      return rankloading(this);
    }
    return orElse();
  }
}

abstract class rankLoading implements RankState {
  const factory rankLoading() = _$rankLoadingImpl;
}

/// @nodoc
abstract class _$$rankSuccessImplCopyWith<$Res> {
  factory _$$rankSuccessImplCopyWith(
    _$rankSuccessImpl value,
    $Res Function(_$rankSuccessImpl) then,
  ) = __$$rankSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$rankSuccessImplCopyWithImpl<$Res>
    extends _$RankStateCopyWithImpl<$Res, _$rankSuccessImpl>
    implements _$$rankSuccessImplCopyWith<$Res> {
  __$$rankSuccessImplCopyWithImpl(
    _$rankSuccessImpl _value,
    $Res Function(_$rankSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$rankSuccessImpl implements rankSuccess {
  const _$rankSuccessImpl();

  @override
  String toString() {
    return 'RankState.ranksuccess()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$rankSuccessImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() rankloading,
    required TResult Function() ranksuccess,
    required TResult Function(String error) rankerror,
  }) {
    return ranksuccess();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? rankloading,
    TResult? Function()? ranksuccess,
    TResult? Function(String error)? rankerror,
  }) {
    return ranksuccess?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? rankloading,
    TResult Function()? ranksuccess,
    TResult Function(String error)? rankerror,
    required TResult orElse(),
  }) {
    if (ranksuccess != null) {
      return ranksuccess();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(rankLoading value) rankloading,
    required TResult Function(rankSuccess value) ranksuccess,
    required TResult Function(rankError value) rankerror,
  }) {
    return ranksuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(rankLoading value)? rankloading,
    TResult? Function(rankSuccess value)? ranksuccess,
    TResult? Function(rankError value)? rankerror,
  }) {
    return ranksuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(rankLoading value)? rankloading,
    TResult Function(rankSuccess value)? ranksuccess,
    TResult Function(rankError value)? rankerror,
    required TResult orElse(),
  }) {
    if (ranksuccess != null) {
      return ranksuccess(this);
    }
    return orElse();
  }
}

abstract class rankSuccess implements RankState {
  const factory rankSuccess() = _$rankSuccessImpl;
}

/// @nodoc
abstract class _$$rankErrorImplCopyWith<$Res> {
  factory _$$rankErrorImplCopyWith(
    _$rankErrorImpl value,
    $Res Function(_$rankErrorImpl) then,
  ) = __$$rankErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$rankErrorImplCopyWithImpl<$Res>
    extends _$RankStateCopyWithImpl<$Res, _$rankErrorImpl>
    implements _$$rankErrorImplCopyWith<$Res> {
  __$$rankErrorImplCopyWithImpl(
    _$rankErrorImpl _value,
    $Res Function(_$rankErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RankState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$rankErrorImpl(
        error: null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$rankErrorImpl implements rankError {
  const _$rankErrorImpl({required this.error});

  @override
  final String error;

  @override
  String toString() {
    return 'RankState.rankerror(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$rankErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of RankState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$rankErrorImplCopyWith<_$rankErrorImpl> get copyWith =>
      __$$rankErrorImplCopyWithImpl<_$rankErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() rankloading,
    required TResult Function() ranksuccess,
    required TResult Function(String error) rankerror,
  }) {
    return rankerror(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? rankloading,
    TResult? Function()? ranksuccess,
    TResult? Function(String error)? rankerror,
  }) {
    return rankerror?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? rankloading,
    TResult Function()? ranksuccess,
    TResult Function(String error)? rankerror,
    required TResult orElse(),
  }) {
    if (rankerror != null) {
      return rankerror(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(rankLoading value) rankloading,
    required TResult Function(rankSuccess value) ranksuccess,
    required TResult Function(rankError value) rankerror,
  }) {
    return rankerror(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(rankLoading value)? rankloading,
    TResult? Function(rankSuccess value)? ranksuccess,
    TResult? Function(rankError value)? rankerror,
  }) {
    return rankerror?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(rankLoading value)? rankloading,
    TResult Function(rankSuccess value)? ranksuccess,
    TResult Function(rankError value)? rankerror,
    required TResult orElse(),
  }) {
    if (rankerror != null) {
      return rankerror(this);
    }
    return orElse();
  }
}

abstract class rankError implements RankState {
  const factory rankError({required final String error}) = _$rankErrorImpl;

  String get error;

  /// Create a copy of RankState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$rankErrorImplCopyWith<_$rankErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
