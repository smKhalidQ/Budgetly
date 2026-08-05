// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlySummary {
  int get year;
  int get month;
  double get expense;
  double get income;
  int get txCount;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MonthlySummaryCopyWith<MonthlySummary> get copyWith =>
      _$MonthlySummaryCopyWithImpl<MonthlySummary>(
          this as MonthlySummary, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MonthlySummary &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.txCount, txCount) || other.txCount == txCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, year, month, expense, income, txCount);

  @override
  String toString() {
    return 'MonthlySummary(year: $year, month: $month, expense: $expense, income: $income, txCount: $txCount)';
  }
}

/// @nodoc
abstract mixin class $MonthlySummaryCopyWith<$Res> {
  factory $MonthlySummaryCopyWith(
          MonthlySummary value, $Res Function(MonthlySummary) _then) =
      _$MonthlySummaryCopyWithImpl;
  @useResult
  $Res call({int year, int month, double expense, double income, int txCount});
}

/// @nodoc
class _$MonthlySummaryCopyWithImpl<$Res>
    implements $MonthlySummaryCopyWith<$Res> {
  _$MonthlySummaryCopyWithImpl(this._self, this._then);

  final MonthlySummary _self;
  final $Res Function(MonthlySummary) _then;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? expense = null,
    Object? income = null,
    Object? txCount = null,
  }) {
    return _then(_self.copyWith(
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      expense: null == expense
          ? _self.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      income: null == income
          ? _self.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      txCount: null == txCount
          ? _self.txCount
          : txCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [MonthlySummary].
extension MonthlySummaryPatterns on MonthlySummary {
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
    TResult Function(_MonthlySummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlySummary() when $default != null:
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
    TResult Function(_MonthlySummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlySummary():
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
    TResult? Function(_MonthlySummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlySummary() when $default != null:
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
            int year, int month, double expense, double income, int txCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MonthlySummary() when $default != null:
        return $default(_that.year, _that.month, _that.expense, _that.income,
            _that.txCount);
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
            int year, int month, double expense, double income, int txCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlySummary():
        return $default(_that.year, _that.month, _that.expense, _that.income,
            _that.txCount);
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
            int year, int month, double expense, double income, int txCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MonthlySummary() when $default != null:
        return $default(_that.year, _that.month, _that.expense, _that.income,
            _that.txCount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MonthlySummary implements MonthlySummary {
  const _MonthlySummary(
      {required this.year,
      required this.month,
      this.expense = 0,
      this.income = 0,
      this.txCount = 0});

  @override
  final int year;
  @override
  final int month;
  @override
  @JsonKey()
  final double expense;
  @override
  @JsonKey()
  final double income;
  @override
  @JsonKey()
  final int txCount;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MonthlySummaryCopyWith<_MonthlySummary> get copyWith =>
      __$MonthlySummaryCopyWithImpl<_MonthlySummary>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MonthlySummary &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.txCount, txCount) || other.txCount == txCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, year, month, expense, income, txCount);

  @override
  String toString() {
    return 'MonthlySummary(year: $year, month: $month, expense: $expense, income: $income, txCount: $txCount)';
  }
}

/// @nodoc
abstract mixin class _$MonthlySummaryCopyWith<$Res>
    implements $MonthlySummaryCopyWith<$Res> {
  factory _$MonthlySummaryCopyWith(
          _MonthlySummary value, $Res Function(_MonthlySummary) _then) =
      __$MonthlySummaryCopyWithImpl;
  @override
  @useResult
  $Res call({int year, int month, double expense, double income, int txCount});
}

/// @nodoc
class __$MonthlySummaryCopyWithImpl<$Res>
    implements _$MonthlySummaryCopyWith<$Res> {
  __$MonthlySummaryCopyWithImpl(this._self, this._then);

  final _MonthlySummary _self;
  final $Res Function(_MonthlySummary) _then;

  /// Create a copy of MonthlySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? year = null,
    Object? month = null,
    Object? expense = null,
    Object? income = null,
    Object? txCount = null,
  }) {
    return _then(_MonthlySummary(
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      expense: null == expense
          ? _self.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      income: null == income
          ? _self.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      txCount: null == txCount
          ? _self.txCount
          : txCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
