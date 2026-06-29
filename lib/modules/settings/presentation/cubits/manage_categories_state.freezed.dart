// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manage_categories_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ManageCategoriesState {
  ManageCategoriesStatus get status;
  List<Category> get categories;
  Map<int, double> get newBases;
  double get newSalary;
  List<String> get deferredNames;
  String? get errorMessage;

  /// Create a copy of ManageCategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ManageCategoriesStateCopyWith<ManageCategoriesState> get copyWith =>
      _$ManageCategoriesStateCopyWithImpl<ManageCategoriesState>(
          this as ManageCategoriesState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ManageCategoriesState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality().equals(other.newBases, newBases) &&
            (identical(other.newSalary, newSalary) ||
                other.newSalary == newSalary) &&
            const DeepCollectionEquality()
                .equals(other.deferredNames, deferredNames) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(categories),
      const DeepCollectionEquality().hash(newBases),
      newSalary,
      const DeepCollectionEquality().hash(deferredNames),
      errorMessage);

  @override
  String toString() {
    return 'ManageCategoriesState(status: $status, categories: $categories, newBases: $newBases, newSalary: $newSalary, deferredNames: $deferredNames, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $ManageCategoriesStateCopyWith<$Res> {
  factory $ManageCategoriesStateCopyWith(ManageCategoriesState value,
          $Res Function(ManageCategoriesState) _then) =
      _$ManageCategoriesStateCopyWithImpl;
  @useResult
  $Res call(
      {ManageCategoriesStatus status,
      List<Category> categories,
      Map<int, double> newBases,
      double newSalary,
      List<String> deferredNames,
      String? errorMessage});
}

/// @nodoc
class _$ManageCategoriesStateCopyWithImpl<$Res>
    implements $ManageCategoriesStateCopyWith<$Res> {
  _$ManageCategoriesStateCopyWithImpl(this._self, this._then);

  final ManageCategoriesState _self;
  final $Res Function(ManageCategoriesState) _then;

  /// Create a copy of ManageCategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? categories = null,
    Object? newBases = null,
    Object? newSalary = null,
    Object? deferredNames = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ManageCategoriesStatus,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      newBases: null == newBases
          ? _self.newBases
          : newBases // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      newSalary: null == newSalary
          ? _self.newSalary
          : newSalary // ignore: cast_nullable_to_non_nullable
              as double,
      deferredNames: null == deferredNames
          ? _self.deferredNames
          : deferredNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ManageCategoriesState].
extension ManageCategoriesStatePatterns on ManageCategoriesState {
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
    TResult Function(_ManageCategoriesState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ManageCategoriesState() when $default != null:
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
    TResult Function(_ManageCategoriesState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManageCategoriesState():
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
    TResult? Function(_ManageCategoriesState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManageCategoriesState() when $default != null:
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
    TResult Function(
            ManageCategoriesStatus status,
            List<Category> categories,
            Map<int, double> newBases,
            double newSalary,
            List<String> deferredNames,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ManageCategoriesState() when $default != null:
        return $default(_that.status, _that.categories, _that.newBases,
            _that.newSalary, _that.deferredNames, _that.errorMessage);
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
    TResult Function(
            ManageCategoriesStatus status,
            List<Category> categories,
            Map<int, double> newBases,
            double newSalary,
            List<String> deferredNames,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManageCategoriesState():
        return $default(_that.status, _that.categories, _that.newBases,
            _that.newSalary, _that.deferredNames, _that.errorMessage);
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
    TResult? Function(
            ManageCategoriesStatus status,
            List<Category> categories,
            Map<int, double> newBases,
            double newSalary,
            List<String> deferredNames,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ManageCategoriesState() when $default != null:
        return $default(_that.status, _that.categories, _that.newBases,
            _that.newSalary, _that.deferredNames, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ManageCategoriesState implements ManageCategoriesState {
  const _ManageCategoriesState(
      {this.status = ManageCategoriesStatus.initial,
      final List<Category> categories = const [],
      final Map<int, double> newBases = const {},
      this.newSalary = 0.0,
      final List<String> deferredNames = const [],
      this.errorMessage})
      : _categories = categories,
        _newBases = newBases,
        _deferredNames = deferredNames;

  @override
  @JsonKey()
  final ManageCategoriesStatus status;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final Map<int, double> _newBases;
  @override
  @JsonKey()
  Map<int, double> get newBases {
    if (_newBases is EqualUnmodifiableMapView) return _newBases;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_newBases);
  }

  @override
  @JsonKey()
  final double newSalary;
  final List<String> _deferredNames;
  @override
  @JsonKey()
  List<String> get deferredNames {
    if (_deferredNames is EqualUnmodifiableListView) return _deferredNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deferredNames);
  }

  @override
  final String? errorMessage;

  /// Create a copy of ManageCategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ManageCategoriesStateCopyWith<_ManageCategoriesState> get copyWith =>
      __$ManageCategoriesStateCopyWithImpl<_ManageCategoriesState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ManageCategoriesState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._newBases, _newBases) &&
            (identical(other.newSalary, newSalary) ||
                other.newSalary == newSalary) &&
            const DeepCollectionEquality()
                .equals(other._deferredNames, _deferredNames) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_newBases),
      newSalary,
      const DeepCollectionEquality().hash(_deferredNames),
      errorMessage);

  @override
  String toString() {
    return 'ManageCategoriesState(status: $status, categories: $categories, newBases: $newBases, newSalary: $newSalary, deferredNames: $deferredNames, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$ManageCategoriesStateCopyWith<$Res>
    implements $ManageCategoriesStateCopyWith<$Res> {
  factory _$ManageCategoriesStateCopyWith(_ManageCategoriesState value,
          $Res Function(_ManageCategoriesState) _then) =
      __$ManageCategoriesStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ManageCategoriesStatus status,
      List<Category> categories,
      Map<int, double> newBases,
      double newSalary,
      List<String> deferredNames,
      String? errorMessage});
}

/// @nodoc
class __$ManageCategoriesStateCopyWithImpl<$Res>
    implements _$ManageCategoriesStateCopyWith<$Res> {
  __$ManageCategoriesStateCopyWithImpl(this._self, this._then);

  final _ManageCategoriesState _self;
  final $Res Function(_ManageCategoriesState) _then;

  /// Create a copy of ManageCategoriesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? categories = null,
    Object? newBases = null,
    Object? newSalary = null,
    Object? deferredNames = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_ManageCategoriesState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ManageCategoriesStatus,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      newBases: null == newBases
          ? _self._newBases
          : newBases // ignore: cast_nullable_to_non_nullable
              as Map<int, double>,
      newSalary: null == newSalary
          ? _self.newSalary
          : newSalary // ignore: cast_nullable_to_non_nullable
              as double,
      deferredNames: null == deferredNames
          ? _self._deferredNames
          : deferredNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
