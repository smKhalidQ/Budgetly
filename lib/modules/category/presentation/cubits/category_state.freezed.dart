// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryState {
  CategoryStatus get status;
  List<Category> get categories;
  String? get errorMessage;
  String get selectedIcon;
  String get selectedColor;
  int get remainingBudget;
  Map<int, int> get allocations;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryStateCopyWith<CategoryState> get copyWith =>
      _$CategoryStateCopyWithImpl<CategoryState>(
          this as CategoryState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.selectedIcon, selectedIcon) ||
                other.selectedIcon == selectedIcon) &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.remainingBudget, remainingBudget) ||
                other.remainingBudget == remainingBudget) &&
            const DeepCollectionEquality()
                .equals(other.allocations, allocations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(categories),
      errorMessage,
      selectedIcon,
      selectedColor,
      remainingBudget,
      const DeepCollectionEquality().hash(allocations));

  @override
  String toString() {
    return 'CategoryState(status: $status, categories: $categories, errorMessage: $errorMessage, selectedIcon: $selectedIcon, selectedColor: $selectedColor, remainingBudget: $remainingBudget, allocations: $allocations)';
  }
}

/// @nodoc
abstract mixin class $CategoryStateCopyWith<$Res> {
  factory $CategoryStateCopyWith(
          CategoryState value, $Res Function(CategoryState) _then) =
      _$CategoryStateCopyWithImpl;
  @useResult
  $Res call(
      {CategoryStatus status,
      List<Category> categories,
      String? errorMessage,
      String selectedIcon,
      String selectedColor,
      int remainingBudget,
      Map<int, int> allocations});
}

/// @nodoc
class _$CategoryStateCopyWithImpl<$Res>
    implements $CategoryStateCopyWith<$Res> {
  _$CategoryStateCopyWithImpl(this._self, this._then);

  final CategoryState _self;
  final $Res Function(CategoryState) _then;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? categories = null,
    Object? errorMessage = freezed,
    Object? selectedIcon = null,
    Object? selectedColor = null,
    Object? remainingBudget = null,
    Object? allocations = null,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as CategoryStatus,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedIcon: null == selectedIcon
          ? _self.selectedIcon
          : selectedIcon // ignore: cast_nullable_to_non_nullable
              as String,
      selectedColor: null == selectedColor
          ? _self.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as String,
      remainingBudget: null == remainingBudget
          ? _self.remainingBudget
          : remainingBudget // ignore: cast_nullable_to_non_nullable
              as int,
      allocations: null == allocations
          ? _self.allocations
          : allocations // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CategoryState].
extension CategoryStatePatterns on CategoryState {
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
    TResult Function(_CategoryState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryState() when $default != null:
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
    TResult Function(_CategoryState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryState():
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
    TResult? Function(_CategoryState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryState() when $default != null:
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
            CategoryStatus status,
            List<Category> categories,
            String? errorMessage,
            String selectedIcon,
            String selectedColor,
            int remainingBudget,
            Map<int, int> allocations)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryState() when $default != null:
        return $default(
            _that.status,
            _that.categories,
            _that.errorMessage,
            _that.selectedIcon,
            _that.selectedColor,
            _that.remainingBudget,
            _that.allocations);
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
            CategoryStatus status,
            List<Category> categories,
            String? errorMessage,
            String selectedIcon,
            String selectedColor,
            int remainingBudget,
            Map<int, int> allocations)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryState():
        return $default(
            _that.status,
            _that.categories,
            _that.errorMessage,
            _that.selectedIcon,
            _that.selectedColor,
            _that.remainingBudget,
            _that.allocations);
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
            CategoryStatus status,
            List<Category> categories,
            String? errorMessage,
            String selectedIcon,
            String selectedColor,
            int remainingBudget,
            Map<int, int> allocations)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryState() when $default != null:
        return $default(
            _that.status,
            _that.categories,
            _that.errorMessage,
            _that.selectedIcon,
            _that.selectedColor,
            _that.remainingBudget,
            _that.allocations);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CategoryState implements CategoryState {
  const _CategoryState(
      {this.status = CategoryStatus.initial,
      final List<Category> categories = const [],
      this.errorMessage,
      this.selectedIcon = '',
      this.selectedColor = 'Color(0xff2196f3)',
      this.remainingBudget = 0,
      final Map<int, int> allocations = const <int, int>{}})
      : _categories = categories,
        _allocations = allocations;

  @override
  @JsonKey()
  final CategoryStatus status;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final String selectedIcon;
  @override
  @JsonKey()
  final String selectedColor;
  @override
  @JsonKey()
  final int remainingBudget;
  final Map<int, int> _allocations;
  @override
  @JsonKey()
  Map<int, int> get allocations {
    if (_allocations is EqualUnmodifiableMapView) return _allocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_allocations);
  }

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryStateCopyWith<_CategoryState> get copyWith =>
      __$CategoryStateCopyWithImpl<_CategoryState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.selectedIcon, selectedIcon) ||
                other.selectedIcon == selectedIcon) &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.remainingBudget, remainingBudget) ||
                other.remainingBudget == remainingBudget) &&
            const DeepCollectionEquality()
                .equals(other._allocations, _allocations));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_categories),
      errorMessage,
      selectedIcon,
      selectedColor,
      remainingBudget,
      const DeepCollectionEquality().hash(_allocations));

  @override
  String toString() {
    return 'CategoryState(status: $status, categories: $categories, errorMessage: $errorMessage, selectedIcon: $selectedIcon, selectedColor: $selectedColor, remainingBudget: $remainingBudget, allocations: $allocations)';
  }
}

/// @nodoc
abstract mixin class _$CategoryStateCopyWith<$Res>
    implements $CategoryStateCopyWith<$Res> {
  factory _$CategoryStateCopyWith(
          _CategoryState value, $Res Function(_CategoryState) _then) =
      __$CategoryStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {CategoryStatus status,
      List<Category> categories,
      String? errorMessage,
      String selectedIcon,
      String selectedColor,
      int remainingBudget,
      Map<int, int> allocations});
}

/// @nodoc
class __$CategoryStateCopyWithImpl<$Res>
    implements _$CategoryStateCopyWith<$Res> {
  __$CategoryStateCopyWithImpl(this._self, this._then);

  final _CategoryState _self;
  final $Res Function(_CategoryState) _then;

  /// Create a copy of CategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? categories = null,
    Object? errorMessage = freezed,
    Object? selectedIcon = null,
    Object? selectedColor = null,
    Object? remainingBudget = null,
    Object? allocations = null,
  }) {
    return _then(_CategoryState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as CategoryStatus,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedIcon: null == selectedIcon
          ? _self.selectedIcon
          : selectedIcon // ignore: cast_nullable_to_non_nullable
              as String,
      selectedColor: null == selectedColor
          ? _self.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as String,
      remainingBudget: null == remainingBudget
          ? _self.remainingBudget
          : remainingBudget // ignore: cast_nullable_to_non_nullable
              as int,
      allocations: null == allocations
          ? _self._allocations
          : allocations // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
    ));
  }
}

// dart format on
