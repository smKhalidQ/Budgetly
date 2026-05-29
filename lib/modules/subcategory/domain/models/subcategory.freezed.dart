// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subcategory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Subcategory {
  int? get id;
  int? get parentCategoryId;
  String get name;
  String get color;
  String get icon;
  String? get spentAmount;

  /// Create a copy of Subcategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubcategoryCopyWith<Subcategory> get copyWith =>
      _$SubcategoryCopyWithImpl<Subcategory>(this as Subcategory, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Subcategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentCategoryId, parentCategoryId) ||
                other.parentCategoryId == parentCategoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.spentAmount, spentAmount) ||
                other.spentAmount == spentAmount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, parentCategoryId, name, color, icon, spentAmount);

  @override
  String toString() {
    return 'Subcategory(id: $id, parentCategoryId: $parentCategoryId, name: $name, color: $color, icon: $icon, spentAmount: $spentAmount)';
  }
}

/// @nodoc
abstract mixin class $SubcategoryCopyWith<$Res> {
  factory $SubcategoryCopyWith(
          Subcategory value, $Res Function(Subcategory) _then) =
      _$SubcategoryCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      int? parentCategoryId,
      String name,
      String color,
      String icon,
      String? spentAmount});
}

/// @nodoc
class _$SubcategoryCopyWithImpl<$Res> implements $SubcategoryCopyWith<$Res> {
  _$SubcategoryCopyWithImpl(this._self, this._then);

  final Subcategory _self;
  final $Res Function(Subcategory) _then;

  /// Create a copy of Subcategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? parentCategoryId = freezed,
    Object? name = null,
    Object? color = null,
    Object? icon = null,
    Object? spentAmount = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      parentCategoryId: freezed == parentCategoryId
          ? _self.parentCategoryId
          : parentCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      spentAmount: freezed == spentAmount
          ? _self.spentAmount
          : spentAmount // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Subcategory].
extension SubcategoryPatterns on Subcategory {
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
    TResult Function(_Subcategory value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Subcategory() when $default != null:
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
    TResult Function(_Subcategory value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subcategory():
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
    TResult? Function(_Subcategory value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subcategory() when $default != null:
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
    TResult Function(int? id, int? parentCategoryId, String name, String color,
            String icon, String? spentAmount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Subcategory() when $default != null:
        return $default(_that.id, _that.parentCategoryId, _that.name,
            _that.color, _that.icon, _that.spentAmount);
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
    TResult Function(int? id, int? parentCategoryId, String name, String color,
            String icon, String? spentAmount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subcategory():
        return $default(_that.id, _that.parentCategoryId, _that.name,
            _that.color, _that.icon, _that.spentAmount);
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
    TResult? Function(int? id, int? parentCategoryId, String name, String color,
            String icon, String? spentAmount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Subcategory() when $default != null:
        return $default(_that.id, _that.parentCategoryId, _that.name,
            _that.color, _that.icon, _that.spentAmount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Subcategory implements Subcategory {
  const _Subcategory(
      {this.id,
      this.parentCategoryId,
      required this.name,
      required this.color,
      required this.icon,
      this.spentAmount});

  @override
  final int? id;
  @override
  final int? parentCategoryId;
  @override
  final String name;
  @override
  final String color;
  @override
  final String icon;
  @override
  final String? spentAmount;

  /// Create a copy of Subcategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubcategoryCopyWith<_Subcategory> get copyWith =>
      __$SubcategoryCopyWithImpl<_Subcategory>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Subcategory &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentCategoryId, parentCategoryId) ||
                other.parentCategoryId == parentCategoryId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.spentAmount, spentAmount) ||
                other.spentAmount == spentAmount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, parentCategoryId, name, color, icon, spentAmount);

  @override
  String toString() {
    return 'Subcategory(id: $id, parentCategoryId: $parentCategoryId, name: $name, color: $color, icon: $icon, spentAmount: $spentAmount)';
  }
}

/// @nodoc
abstract mixin class _$SubcategoryCopyWith<$Res>
    implements $SubcategoryCopyWith<$Res> {
  factory _$SubcategoryCopyWith(
          _Subcategory value, $Res Function(_Subcategory) _then) =
      __$SubcategoryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      int? parentCategoryId,
      String name,
      String color,
      String icon,
      String? spentAmount});
}

/// @nodoc
class __$SubcategoryCopyWithImpl<$Res> implements _$SubcategoryCopyWith<$Res> {
  __$SubcategoryCopyWithImpl(this._self, this._then);

  final _Subcategory _self;
  final $Res Function(_Subcategory) _then;

  /// Create a copy of Subcategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? parentCategoryId = freezed,
    Object? name = null,
    Object? color = null,
    Object? icon = null,
    Object? spentAmount = freezed,
  }) {
    return _then(_Subcategory(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      parentCategoryId: freezed == parentCategoryId
          ? _self.parentCategoryId
          : parentCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      spentAmount: freezed == spentAmount
          ? _self.spentAmount
          : spentAmount // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
