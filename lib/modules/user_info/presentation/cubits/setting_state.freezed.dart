// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingState {
  SettingStatus get status;
  String? get selectedCurrency;
  int get monthlySalary;
  String get userName;
  String? get errorMessage;

  /// Create a copy of SettingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SettingStateCopyWith<SettingState> get copyWith =>
      _$SettingStateCopyWithImpl<SettingState>(
          this as SettingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SettingState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.selectedCurrency, selectedCurrency) ||
                other.selectedCurrency == selectedCurrency) &&
            (identical(other.monthlySalary, monthlySalary) ||
                other.monthlySalary == monthlySalary) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, selectedCurrency,
      monthlySalary, userName, errorMessage);

  @override
  String toString() {
    return 'SettingState(status: $status, selectedCurrency: $selectedCurrency, monthlySalary: $monthlySalary, userName: $userName, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $SettingStateCopyWith<$Res> {
  factory $SettingStateCopyWith(
          SettingState value, $Res Function(SettingState) _then) =
      _$SettingStateCopyWithImpl;
  @useResult
  $Res call(
      {SettingStatus status,
      String? selectedCurrency,
      int monthlySalary,
      String userName,
      String? errorMessage});
}

/// @nodoc
class _$SettingStateCopyWithImpl<$Res> implements $SettingStateCopyWith<$Res> {
  _$SettingStateCopyWithImpl(this._self, this._then);

  final SettingState _self;
  final $Res Function(SettingState) _then;

  /// Create a copy of SettingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? selectedCurrency = freezed,
    Object? monthlySalary = null,
    Object? userName = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SettingStatus,
      selectedCurrency: freezed == selectedCurrency
          ? _self.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      monthlySalary: null == monthlySalary
          ? _self.monthlySalary
          : monthlySalary // ignore: cast_nullable_to_non_nullable
              as int,
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SettingState].
extension SettingStatePatterns on SettingState {
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
    TResult Function(_SettingState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SettingState() when $default != null:
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
    TResult Function(_SettingState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SettingState():
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
    TResult? Function(_SettingState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SettingState() when $default != null:
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
    TResult Function(SettingStatus status, String? selectedCurrency,
            int monthlySalary, String userName, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SettingState() when $default != null:
        return $default(_that.status, _that.selectedCurrency,
            _that.monthlySalary, _that.userName, _that.errorMessage);
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
    TResult Function(SettingStatus status, String? selectedCurrency,
            int monthlySalary, String userName, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SettingState():
        return $default(_that.status, _that.selectedCurrency,
            _that.monthlySalary, _that.userName, _that.errorMessage);
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
    TResult? Function(SettingStatus status, String? selectedCurrency,
            int monthlySalary, String userName, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SettingState() when $default != null:
        return $default(_that.status, _that.selectedCurrency,
            _that.monthlySalary, _that.userName, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SettingState implements SettingState {
  const _SettingState(
      {this.status = SettingStatus.initial,
      this.selectedCurrency,
      this.monthlySalary = 0,
      this.userName = '',
      this.errorMessage});

  @override
  @JsonKey()
  final SettingStatus status;
  @override
  final String? selectedCurrency;
  @override
  @JsonKey()
  final int monthlySalary;
  @override
  @JsonKey()
  final String userName;
  @override
  final String? errorMessage;

  /// Create a copy of SettingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SettingStateCopyWith<_SettingState> get copyWith =>
      __$SettingStateCopyWithImpl<_SettingState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SettingState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.selectedCurrency, selectedCurrency) ||
                other.selectedCurrency == selectedCurrency) &&
            (identical(other.monthlySalary, monthlySalary) ||
                other.monthlySalary == monthlySalary) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, selectedCurrency,
      monthlySalary, userName, errorMessage);

  @override
  String toString() {
    return 'SettingState(status: $status, selectedCurrency: $selectedCurrency, monthlySalary: $monthlySalary, userName: $userName, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$SettingStateCopyWith<$Res>
    implements $SettingStateCopyWith<$Res> {
  factory _$SettingStateCopyWith(
          _SettingState value, $Res Function(_SettingState) _then) =
      __$SettingStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {SettingStatus status,
      String? selectedCurrency,
      int monthlySalary,
      String userName,
      String? errorMessage});
}

/// @nodoc
class __$SettingStateCopyWithImpl<$Res>
    implements _$SettingStateCopyWith<$Res> {
  __$SettingStateCopyWithImpl(this._self, this._then);

  final _SettingState _self;
  final $Res Function(_SettingState) _then;

  /// Create a copy of SettingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? selectedCurrency = freezed,
    Object? monthlySalary = null,
    Object? userName = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_SettingState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as SettingStatus,
      selectedCurrency: freezed == selectedCurrency
          ? _self.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as String?,
      monthlySalary: null == monthlySalary
          ? _self.monthlySalary
          : monthlySalary // ignore: cast_nullable_to_non_nullable
              as int,
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
