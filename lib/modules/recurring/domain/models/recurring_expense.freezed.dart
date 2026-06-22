// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringExpense {
  int? get id;
  int get categoryId;
  int? get subcategoryId;
  double get amount;
  String? get note;
  bool get isActive;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurringExpenseCopyWith<RecurringExpense> get copyWith =>
      _$RecurringExpenseCopyWithImpl<RecurringExpense>(
          this as RecurringExpense, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurringExpense &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, categoryId, subcategoryId, amount, note, isActive);

  @override
  String toString() {
    return 'RecurringExpense(id: $id, categoryId: $categoryId, subcategoryId: $subcategoryId, amount: $amount, note: $note, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class $RecurringExpenseCopyWith<$Res> {
  factory $RecurringExpenseCopyWith(
          RecurringExpense value, $Res Function(RecurringExpense) _then) =
      _$RecurringExpenseCopyWithImpl;
  @useResult
  $Res call(
      {int? id,
      int categoryId,
      int? subcategoryId,
      double amount,
      String? note,
      bool isActive});
}

/// @nodoc
class _$RecurringExpenseCopyWithImpl<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  _$RecurringExpenseCopyWithImpl(this._self, this._then);

  final RecurringExpense _self;
  final $Res Function(RecurringExpense) _then;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? categoryId = null,
    Object? subcategoryId = freezed,
    Object? amount = null,
    Object? note = freezed,
    Object? isActive = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      subcategoryId: freezed == subcategoryId
          ? _self.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecurringExpense].
extension RecurringExpensePatterns on RecurringExpense {
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
    TResult Function(_RecurringExpense value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringExpense() when $default != null:
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
    TResult Function(_RecurringExpense value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringExpense():
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
    TResult? Function(_RecurringExpense value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringExpense() when $default != null:
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
    TResult Function(int? id, int categoryId, int? subcategoryId, double amount,
            String? note, bool isActive)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringExpense() when $default != null:
        return $default(_that.id, _that.categoryId, _that.subcategoryId,
            _that.amount, _that.note, _that.isActive);
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
    TResult Function(int? id, int categoryId, int? subcategoryId, double amount,
            String? note, bool isActive)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringExpense():
        return $default(_that.id, _that.categoryId, _that.subcategoryId,
            _that.amount, _that.note, _that.isActive);
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
    TResult? Function(int? id, int categoryId, int? subcategoryId,
            double amount, String? note, bool isActive)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringExpense() when $default != null:
        return $default(_that.id, _that.categoryId, _that.subcategoryId,
            _that.amount, _that.note, _that.isActive);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _RecurringExpense implements RecurringExpense {
  const _RecurringExpense(
      {this.id,
      required this.categoryId,
      this.subcategoryId,
      required this.amount,
      this.note,
      this.isActive = true});

  @override
  final int? id;
  @override
  final int categoryId;
  @override
  final int? subcategoryId;
  @override
  final double amount;
  @override
  final String? note;
  @override
  @JsonKey()
  final bool isActive;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurringExpenseCopyWith<_RecurringExpense> get copyWith =>
      __$RecurringExpenseCopyWithImpl<_RecurringExpense>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurringExpense &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, categoryId, subcategoryId, amount, note, isActive);

  @override
  String toString() {
    return 'RecurringExpense(id: $id, categoryId: $categoryId, subcategoryId: $subcategoryId, amount: $amount, note: $note, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$RecurringExpenseCopyWith<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  factory _$RecurringExpenseCopyWith(
          _RecurringExpense value, $Res Function(_RecurringExpense) _then) =
      __$RecurringExpenseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? id,
      int categoryId,
      int? subcategoryId,
      double amount,
      String? note,
      bool isActive});
}

/// @nodoc
class __$RecurringExpenseCopyWithImpl<$Res>
    implements _$RecurringExpenseCopyWith<$Res> {
  __$RecurringExpenseCopyWithImpl(this._self, this._then);

  final _RecurringExpense _self;
  final $Res Function(_RecurringExpense) _then;

  /// Create a copy of RecurringExpense
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? categoryId = null,
    Object? subcategoryId = freezed,
    Object? amount = null,
    Object? note = freezed,
    Object? isActive = null,
  }) {
    return _then(_RecurringExpense(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      subcategoryId: freezed == subcategoryId
          ? _self.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
