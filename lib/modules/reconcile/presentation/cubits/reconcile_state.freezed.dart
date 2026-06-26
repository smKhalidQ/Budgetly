// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reconcile_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReconcileState {
  ReconcileStatus get status;
  List<Category> get categories;
  double get actual;
  String? get errorMessage;

  /// Create a copy of ReconcileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReconcileStateCopyWith<ReconcileState> get copyWith =>
      _$ReconcileStateCopyWithImpl<ReconcileState>(
          this as ReconcileState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReconcileState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status,
      const DeepCollectionEquality().hash(categories), actual, errorMessage);

  @override
  String toString() {
    return 'ReconcileState(status: $status, categories: $categories, actual: $actual, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $ReconcileStateCopyWith<$Res> {
  factory $ReconcileStateCopyWith(
          ReconcileState value, $Res Function(ReconcileState) _then) =
      _$ReconcileStateCopyWithImpl;
  @useResult
  $Res call(
      {ReconcileStatus status,
      List<Category> categories,
      double actual,
      String? errorMessage});
}

/// @nodoc
class _$ReconcileStateCopyWithImpl<$Res>
    implements $ReconcileStateCopyWith<$Res> {
  _$ReconcileStateCopyWithImpl(this._self, this._then);

  final ReconcileState _self;
  final $Res Function(ReconcileState) _then;

  /// Create a copy of ReconcileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? categories = null,
    Object? actual = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReconcileStatus,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      actual: null == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as double,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReconcileState].
extension ReconcileStatePatterns on ReconcileState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ReconcileState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReconcileState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ReconcileState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReconcileState():
        return $default(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ReconcileState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReconcileState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(ReconcileStatus status, List<Category> categories,
            double actual, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReconcileState() when $default != null:
        return $default(
            _that.status, _that.categories, _that.actual, _that.errorMessage);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(ReconcileStatus status, List<Category> categories,
            double actual, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReconcileState():
        return $default(
            _that.status, _that.categories, _that.actual, _that.errorMessage);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(ReconcileStatus status, List<Category> categories,
            double actual, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReconcileState() when $default != null:
        return $default(
            _that.status, _that.categories, _that.actual, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ReconcileState implements ReconcileState {
  const _ReconcileState(
      {this.status = ReconcileStatus.initial,
      final List<Category> categories = const [],
      this.actual = 0.0,
      this.errorMessage})
      : _categories = categories;

  @override
  @JsonKey()
  final ReconcileStatus status;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final double actual;
  @override
  final String? errorMessage;

  /// Create a copy of ReconcileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReconcileStateCopyWith<_ReconcileState> get copyWith =>
      __$ReconcileStateCopyWithImpl<_ReconcileState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReconcileState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.actual, actual) || other.actual == actual) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status,
      const DeepCollectionEquality().hash(_categories), actual, errorMessage);

  @override
  String toString() {
    return 'ReconcileState(status: $status, categories: $categories, actual: $actual, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$ReconcileStateCopyWith<$Res>
    implements $ReconcileStateCopyWith<$Res> {
  factory _$ReconcileStateCopyWith(
          _ReconcileState value, $Res Function(_ReconcileState) _then) =
      __$ReconcileStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ReconcileStatus status,
      List<Category> categories,
      double actual,
      String? errorMessage});
}

/// @nodoc
class __$ReconcileStateCopyWithImpl<$Res>
    implements _$ReconcileStateCopyWith<$Res> {
  __$ReconcileStateCopyWithImpl(this._self, this._then);

  final _ReconcileState _self;
  final $Res Function(_ReconcileState) _then;

  /// Create a copy of ReconcileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? categories = null,
    Object? actual = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_ReconcileState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReconcileStatus,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      actual: null == actual
          ? _self.actual
          : actual // ignore: cast_nullable_to_non_nullable
              as double,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
