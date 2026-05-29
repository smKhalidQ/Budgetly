// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subcategory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubcategoryState {
  SubcategoryStatus get status;
  List<Subcategory> get subcategories;
  String? get errorMessage;
  String get selectedIcon;
  String get selectedColor;
  bool get isEditMode;
  bool get showPieChart;

  /// Create a copy of SubcategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubcategoryStateCopyWith<SubcategoryState> get copyWith =>
      _$SubcategoryStateCopyWithImpl<SubcategoryState>(
          this as SubcategoryState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubcategoryState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.subcategories, subcategories) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.selectedIcon, selectedIcon) ||
                other.selectedIcon == selectedIcon) &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.isEditMode, isEditMode) ||
                other.isEditMode == isEditMode) &&
            (identical(other.showPieChart, showPieChart) ||
                other.showPieChart == showPieChart));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(subcategories),
      errorMessage,
      selectedIcon,
      selectedColor,
      isEditMode,
      showPieChart);

  @override
  String toString() {
    return 'SubcategoryState(status: $status, subcategories: $subcategories, errorMessage: $errorMessage, selectedIcon: $selectedIcon, selectedColor: $selectedColor, isEditMode: $isEditMode, showPieChart: $showPieChart)';
  }
}

/// @nodoc
abstract mixin class $SubcategoryStateCopyWith<$Res> {
  factory $SubcategoryStateCopyWith(
          SubcategoryState value, $Res Function(SubcategoryState) _then) =
      _$SubcategoryStateCopyWithImpl;
  @useResult
  $Res call(
      {SubcategoryStatus status,
      List<Subcategory> subcategories,
      String? errorMessage,
      String selectedIcon,
      String selectedColor,
      bool isEditMode,
      bool showPieChart});
}

/// @nodoc
class _$SubcategoryStateCopyWithImpl<$Res>
    implements $SubcategoryStateCopyWith<$Res> {
  _$SubcategoryStateCopyWithImpl(this._self, this._then);

  final SubcategoryState _self;
  final $Res Function(SubcategoryState) _then;

  /// Create a copy of SubcategoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? subcategories = null,
    Object? errorMessage = freezed,
    Object? selectedIcon = null,
    Object? selectedColor = null,
    Object? isEditMode = null,
    Object? showPieChart = null,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubcategoryStatus,
      subcategories: null == subcategories
          ? _self.subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<Subcategory>,
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
      isEditMode: null == isEditMode
          ? _self.isEditMode
          : isEditMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showPieChart: null == showPieChart
          ? _self.showPieChart
          : showPieChart // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SubcategoryState].
extension SubcategoryStatePatterns on SubcategoryState {
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
    TResult Function(_SubcategoryState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubcategoryState() when $default != null:
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
    TResult Function(_SubcategoryState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubcategoryState():
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
    TResult? Function(_SubcategoryState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubcategoryState() when $default != null:
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
            SubcategoryStatus status,
            List<Subcategory> subcategories,
            String? errorMessage,
            String selectedIcon,
            String selectedColor,
            bool isEditMode,
            bool showPieChart)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubcategoryState() when $default != null:
        return $default(
            _that.status,
            _that.subcategories,
            _that.errorMessage,
            _that.selectedIcon,
            _that.selectedColor,
            _that.isEditMode,
            _that.showPieChart);
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
            SubcategoryStatus status,
            List<Subcategory> subcategories,
            String? errorMessage,
            String selectedIcon,
            String selectedColor,
            bool isEditMode,
            bool showPieChart)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubcategoryState():
        return $default(
            _that.status,
            _that.subcategories,
            _that.errorMessage,
            _that.selectedIcon,
            _that.selectedColor,
            _that.isEditMode,
            _that.showPieChart);
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
            SubcategoryStatus status,
            List<Subcategory> subcategories,
            String? errorMessage,
            String selectedIcon,
            String selectedColor,
            bool isEditMode,
            bool showPieChart)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubcategoryState() when $default != null:
        return $default(
            _that.status,
            _that.subcategories,
            _that.errorMessage,
            _that.selectedIcon,
            _that.selectedColor,
            _that.isEditMode,
            _that.showPieChart);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SubcategoryState implements SubcategoryState {
  const _SubcategoryState(
      {this.status = SubcategoryStatus.initial,
      final List<Subcategory> subcategories = const [],
      this.errorMessage,
      this.selectedIcon = '',
      this.selectedColor = 'Color(0xff2196f3)',
      this.isEditMode = false,
      this.showPieChart = false})
      : _subcategories = subcategories;

  @override
  @JsonKey()
  final SubcategoryStatus status;
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
  @override
  @JsonKey()
  final String selectedIcon;
  @override
  @JsonKey()
  final String selectedColor;
  @override
  @JsonKey()
  final bool isEditMode;
  @override
  @JsonKey()
  final bool showPieChart;

  /// Create a copy of SubcategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubcategoryStateCopyWith<_SubcategoryState> get copyWith =>
      __$SubcategoryStateCopyWithImpl<_SubcategoryState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubcategoryState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._subcategories, _subcategories) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.selectedIcon, selectedIcon) ||
                other.selectedIcon == selectedIcon) &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.isEditMode, isEditMode) ||
                other.isEditMode == isEditMode) &&
            (identical(other.showPieChart, showPieChart) ||
                other.showPieChart == showPieChart));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_subcategories),
      errorMessage,
      selectedIcon,
      selectedColor,
      isEditMode,
      showPieChart);

  @override
  String toString() {
    return 'SubcategoryState(status: $status, subcategories: $subcategories, errorMessage: $errorMessage, selectedIcon: $selectedIcon, selectedColor: $selectedColor, isEditMode: $isEditMode, showPieChart: $showPieChart)';
  }
}

/// @nodoc
abstract mixin class _$SubcategoryStateCopyWith<$Res>
    implements $SubcategoryStateCopyWith<$Res> {
  factory _$SubcategoryStateCopyWith(
          _SubcategoryState value, $Res Function(_SubcategoryState) _then) =
      __$SubcategoryStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SubcategoryStatus status,
      List<Subcategory> subcategories,
      String? errorMessage,
      String selectedIcon,
      String selectedColor,
      bool isEditMode,
      bool showPieChart});
}

/// @nodoc
class __$SubcategoryStateCopyWithImpl<$Res>
    implements _$SubcategoryStateCopyWith<$Res> {
  __$SubcategoryStateCopyWithImpl(this._self, this._then);

  final _SubcategoryState _self;
  final $Res Function(_SubcategoryState) _then;

  /// Create a copy of SubcategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? subcategories = null,
    Object? errorMessage = freezed,
    Object? selectedIcon = null,
    Object? selectedColor = null,
    Object? isEditMode = null,
    Object? showPieChart = null,
  }) {
    return _then(_SubcategoryState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubcategoryStatus,
      subcategories: null == subcategories
          ? _self._subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<Subcategory>,
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
      isEditMode: null == isEditMode
          ? _self.isEditMode
          : isEditMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showPieChart: null == showPieChart
          ? _self.showPieChart
          : showPieChart // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
