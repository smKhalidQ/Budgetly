// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subcategory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SubcategoryState {
  SubcategoryStatus get status => throw _privateConstructorUsedError;
  List<Subcategory> get subcategories => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String get selectedIcon => throw _privateConstructorUsedError;
  String get selectedColor => throw _privateConstructorUsedError;
  bool get isEditMode => throw _privateConstructorUsedError;
  bool get showPieChart => throw _privateConstructorUsedError;

  /// Create a copy of SubcategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubcategoryStateCopyWith<SubcategoryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubcategoryStateCopyWith<$Res> {
  factory $SubcategoryStateCopyWith(
          SubcategoryState value, $Res Function(SubcategoryState) then) =
      _$SubcategoryStateCopyWithImpl<$Res, SubcategoryState>;
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
class _$SubcategoryStateCopyWithImpl<$Res, $Val extends SubcategoryState>
    implements $SubcategoryStateCopyWith<$Res> {
  _$SubcategoryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubcategoryStatus,
      subcategories: null == subcategories
          ? _value.subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<Subcategory>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedIcon: null == selectedIcon
          ? _value.selectedIcon
          : selectedIcon // ignore: cast_nullable_to_non_nullable
              as String,
      selectedColor: null == selectedColor
          ? _value.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as String,
      isEditMode: null == isEditMode
          ? _value.isEditMode
          : isEditMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showPieChart: null == showPieChart
          ? _value.showPieChart
          : showPieChart // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubcategoryStateImplCopyWith<$Res>
    implements $SubcategoryStateCopyWith<$Res> {
  factory _$$SubcategoryStateImplCopyWith(_$SubcategoryStateImpl value,
          $Res Function(_$SubcategoryStateImpl) then) =
      __$$SubcategoryStateImplCopyWithImpl<$Res>;
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
class __$$SubcategoryStateImplCopyWithImpl<$Res>
    extends _$SubcategoryStateCopyWithImpl<$Res, _$SubcategoryStateImpl>
    implements _$$SubcategoryStateImplCopyWith<$Res> {
  __$$SubcategoryStateImplCopyWithImpl(_$SubcategoryStateImpl _value,
      $Res Function(_$SubcategoryStateImpl) _then)
      : super(_value, _then);

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
    return _then(_$SubcategoryStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as SubcategoryStatus,
      subcategories: null == subcategories
          ? _value._subcategories
          : subcategories // ignore: cast_nullable_to_non_nullable
              as List<Subcategory>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedIcon: null == selectedIcon
          ? _value.selectedIcon
          : selectedIcon // ignore: cast_nullable_to_non_nullable
              as String,
      selectedColor: null == selectedColor
          ? _value.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as String,
      isEditMode: null == isEditMode
          ? _value.isEditMode
          : isEditMode // ignore: cast_nullable_to_non_nullable
              as bool,
      showPieChart: null == showPieChart
          ? _value.showPieChart
          : showPieChart // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SubcategoryStateImpl implements _SubcategoryState {
  const _$SubcategoryStateImpl(
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

  @override
  String toString() {
    return 'SubcategoryState(status: $status, subcategories: $subcategories, errorMessage: $errorMessage, selectedIcon: $selectedIcon, selectedColor: $selectedColor, isEditMode: $isEditMode, showPieChart: $showPieChart)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubcategoryStateImpl &&
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

  /// Create a copy of SubcategoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubcategoryStateImplCopyWith<_$SubcategoryStateImpl> get copyWith =>
      __$$SubcategoryStateImplCopyWithImpl<_$SubcategoryStateImpl>(
          this, _$identity);
}

abstract class _SubcategoryState implements SubcategoryState {
  const factory _SubcategoryState(
      {final SubcategoryStatus status,
      final List<Subcategory> subcategories,
      final String? errorMessage,
      final String selectedIcon,
      final String selectedColor,
      final bool isEditMode,
      final bool showPieChart}) = _$SubcategoryStateImpl;

  @override
  SubcategoryStatus get status;
  @override
  List<Subcategory> get subcategories;
  @override
  String? get errorMessage;
  @override
  String get selectedIcon;
  @override
  String get selectedColor;
  @override
  bool get isEditMode;
  @override
  bool get showPieChart;

  /// Create a copy of SubcategoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubcategoryStateImplCopyWith<_$SubcategoryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
