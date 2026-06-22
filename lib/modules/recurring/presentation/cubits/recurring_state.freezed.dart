// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringState {
  RecurringStatus get status;
  List<RecurringExpense> get items;
  List<Category> get categories;
  List<Subcategory> get subcategories;
  String? get errorMessage;

  /// Create a copy of RecurringState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurringStateCopyWith<RecurringState> get copyWith =>
      _$RecurringStateCopyWithImpl<RecurringState>(
          this as RecurringState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurringState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality()
                .equals(other.subcategories, subcategories) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(items),
      const DeepCollectionEquality().hash(categories),
      const DeepCollectionEquality().hash(subcategories),
      errorMessage);

  @override
  String toString() {
    return 'RecurringState(status: $status, items: $items, categories: $categories, subcategories: $subcategories, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $RecurringStateCopyWith<$Res> {
  factory $RecurringStateCopyWith(
          RecurringState value, $Res Function(RecurringState) _then) =
      _$RecurringStateCopyWithImpl;
  @useResult
  $Res call(
      {RecurringStatus status,
      List<RecurringExpense> items,
      List<Category> categories,
      List<Subcategory> subcategories,
      String? errorMessage});
}

/// @nodoc
class _$RecurringStateCopyWithImpl<$Res>
    implements $RecurringStateCopyWith<$Res> {
  _$RecurringStateCopyWithImpl(this._self, this._then);

  final RecurringState _self;
  final $Res Function(RecurringState) _then;

  /// Create a copy of RecurringState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? items = null,
    Object? categories = null,
    Object? subcategories = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecurringStatus,
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<RecurringExpense>,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      subcategories: null == subcategories
          ? _self.subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<Subcategory>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecurringState].
extension RecurringStatePatterns on RecurringState {
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
    TResult Function(_RecurringState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringState() when $default != null:
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
    TResult Function(_RecurringState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringState():
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
    TResult? Function(_RecurringState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringState() when $default != null:
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
            RecurringStatus status,
            List<RecurringExpense> items,
            List<Category> categories,
            List<Subcategory> subcategories,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringState() when $default != null:
        return $default(_that.status, _that.items, _that.categories,
            _that.subcategories, _that.errorMessage);
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
            RecurringStatus status,
            List<RecurringExpense> items,
            List<Category> categories,
            List<Subcategory> subcategories,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringState():
        return $default(_that.status, _that.items, _that.categories,
            _that.subcategories, _that.errorMessage);
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
            RecurringStatus status,
            List<RecurringExpense> items,
            List<Category> categories,
            List<Subcategory> subcategories,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringState() when $default != null:
        return $default(_that.status, _that.items, _that.categories,
            _that.subcategories, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RecurringState implements RecurringState {
  const _RecurringState(
      {this.status = RecurringStatus.initial,
      final List<RecurringExpense> items = const [],
      final List<Category> categories = const [],
      final List<Subcategory> subcategories = const [],
      this.errorMessage})
      : _items = items,
        _categories = categories,
        _subcategories = subcategories;

  @override
  @JsonKey()
  final RecurringStatus status;
  final List<RecurringExpense> _items;
  @override
  @JsonKey()
  List<RecurringExpense> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<Subcategory> _subcategories;
  @override
  @JsonKey()
  List<Subcategory> get subcategories {
    if (_subcategories is EqualUnmodifiableListView) return _subcategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subcategories);
  }

  @override
  final String? errorMessage;

  /// Create a copy of RecurringState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurringStateCopyWith<_RecurringState> get copyWith =>
      __$RecurringStateCopyWithImpl<_RecurringState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurringState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._subcategories, _subcategories) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_subcategories),
      errorMessage);

  @override
  String toString() {
    return 'RecurringState(status: $status, items: $items, categories: $categories, subcategories: $subcategories, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$RecurringStateCopyWith<$Res>
    implements $RecurringStateCopyWith<$Res> {
  factory _$RecurringStateCopyWith(
          _RecurringState value, $Res Function(_RecurringState) _then) =
      __$RecurringStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {RecurringStatus status,
      List<RecurringExpense> items,
      List<Category> categories,
      List<Subcategory> subcategories,
      String? errorMessage});
}

/// @nodoc
class __$RecurringStateCopyWithImpl<$Res>
    implements _$RecurringStateCopyWith<$Res> {
  __$RecurringStateCopyWithImpl(this._self, this._then);

  final _RecurringState _self;
  final $Res Function(_RecurringState) _then;

  /// Create a copy of RecurringState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? items = null,
    Object? categories = null,
    Object? subcategories = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_RecurringState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as RecurringStatus,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<RecurringExpense>,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      subcategories: null == subcategories
          ? _self._subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<Subcategory>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
