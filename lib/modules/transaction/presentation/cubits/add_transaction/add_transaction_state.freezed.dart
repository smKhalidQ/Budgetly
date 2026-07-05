// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_transaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddTransactionState {
  TransactionType get transactionType;
  List<Category> get categories;
  Map<int, List<Subcategory>> get subcategoriesMap;
  int? get expandedCategoryId;
  Category? get selectedCategory;
  Subcategory? get selectedSubcategory;
  bool get subcategoryChosen;
  String get amountInput;
  double? get pendingValue;
  String? get pendingOperator;
  String get expressionLog;
  String get note;
  AddTransactionStatus get status;
  double? get overflowDeficit;
  List<OverflowSplit> get overflowSplits;
  double get overflowIncome;
  Transaction? get editingTransaction;

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddTransactionStateCopyWith<AddTransactionState> get copyWith =>
      _$AddTransactionStateCopyWithImpl<AddTransactionState>(
          this as AddTransactionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddTransactionState &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            const DeepCollectionEquality()
                .equals(other.subcategoriesMap, subcategoriesMap) &&
            (identical(other.expandedCategoryId, expandedCategoryId) ||
                other.expandedCategoryId == expandedCategoryId) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedSubcategory, selectedSubcategory) ||
                other.selectedSubcategory == selectedSubcategory) &&
            (identical(other.subcategoryChosen, subcategoryChosen) ||
                other.subcategoryChosen == subcategoryChosen) &&
            (identical(other.amountInput, amountInput) ||
                other.amountInput == amountInput) &&
            (identical(other.pendingValue, pendingValue) ||
                other.pendingValue == pendingValue) &&
            (identical(other.pendingOperator, pendingOperator) ||
                other.pendingOperator == pendingOperator) &&
            (identical(other.expressionLog, expressionLog) ||
                other.expressionLog == expressionLog) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.overflowDeficit, overflowDeficit) ||
                other.overflowDeficit == overflowDeficit) &&
            const DeepCollectionEquality()
                .equals(other.overflowSplits, overflowSplits) &&
            (identical(other.overflowIncome, overflowIncome) ||
                other.overflowIncome == overflowIncome) &&
            (identical(other.editingTransaction, editingTransaction) ||
                other.editingTransaction == editingTransaction));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      transactionType,
      const DeepCollectionEquality().hash(categories),
      const DeepCollectionEquality().hash(subcategoriesMap),
      expandedCategoryId,
      selectedCategory,
      selectedSubcategory,
      subcategoryChosen,
      amountInput,
      pendingValue,
      pendingOperator,
      expressionLog,
      note,
      status,
      overflowDeficit,
      const DeepCollectionEquality().hash(overflowSplits),
      overflowIncome,
      editingTransaction);

  @override
  String toString() {
    return 'AddTransactionState(transactionType: $transactionType, categories: $categories, subcategoriesMap: $subcategoriesMap, expandedCategoryId: $expandedCategoryId, selectedCategory: $selectedCategory, selectedSubcategory: $selectedSubcategory, subcategoryChosen: $subcategoryChosen, amountInput: $amountInput, pendingValue: $pendingValue, pendingOperator: $pendingOperator, expressionLog: $expressionLog, note: $note, status: $status, overflowDeficit: $overflowDeficit, overflowSplits: $overflowSplits, overflowIncome: $overflowIncome, editingTransaction: $editingTransaction)';
  }
}

/// @nodoc
abstract mixin class $AddTransactionStateCopyWith<$Res> {
  factory $AddTransactionStateCopyWith(
          AddTransactionState value, $Res Function(AddTransactionState) _then) =
      _$AddTransactionStateCopyWithImpl;
  @useResult
  $Res call(
      {TransactionType transactionType,
      List<Category> categories,
      Map<int, List<Subcategory>> subcategoriesMap,
      int? expandedCategoryId,
      Category? selectedCategory,
      Subcategory? selectedSubcategory,
      bool subcategoryChosen,
      String amountInput,
      double? pendingValue,
      String? pendingOperator,
      String expressionLog,
      String note,
      AddTransactionStatus status,
      double? overflowDeficit,
      List<OverflowSplit> overflowSplits,
      double overflowIncome,
      Transaction? editingTransaction});

  $CategoryCopyWith<$Res>? get selectedCategory;
  $SubcategoryCopyWith<$Res>? get selectedSubcategory;
  $TransactionCopyWith<$Res>? get editingTransaction;
}

/// @nodoc
class _$AddTransactionStateCopyWithImpl<$Res>
    implements $AddTransactionStateCopyWith<$Res> {
  _$AddTransactionStateCopyWithImpl(this._self, this._then);

  final AddTransactionState _self;
  final $Res Function(AddTransactionState) _then;

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionType = null,
    Object? categories = null,
    Object? subcategoriesMap = null,
    Object? expandedCategoryId = freezed,
    Object? selectedCategory = freezed,
    Object? selectedSubcategory = freezed,
    Object? subcategoryChosen = null,
    Object? amountInput = null,
    Object? pendingValue = freezed,
    Object? pendingOperator = freezed,
    Object? expressionLog = null,
    Object? note = null,
    Object? status = null,
    Object? overflowDeficit = freezed,
    Object? overflowSplits = null,
    Object? overflowIncome = null,
    Object? editingTransaction = freezed,
  }) {
    return _then(_self.copyWith(
      transactionType: null == transactionType
          ? _self.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      subcategoriesMap: null == subcategoriesMap
          ? _self.subcategoriesMap
          : subcategoriesMap // ignore: cast_nullable_to_non_nullable
              as Map<int, List<Subcategory>>,
      expandedCategoryId: freezed == expandedCategoryId
          ? _self.expandedCategoryId
          : expandedCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCategory: freezed == selectedCategory
          ? _self.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as Category?,
      selectedSubcategory: freezed == selectedSubcategory
          ? _self.selectedSubcategory
          : selectedSubcategory // ignore: cast_nullable_to_non_nullable
              as Subcategory?,
      subcategoryChosen: null == subcategoryChosen
          ? _self.subcategoryChosen
          : subcategoryChosen // ignore: cast_nullable_to_non_nullable
              as bool,
      amountInput: null == amountInput
          ? _self.amountInput
          : amountInput // ignore: cast_nullable_to_non_nullable
              as String,
      pendingValue: freezed == pendingValue
          ? _self.pendingValue
          : pendingValue // ignore: cast_nullable_to_non_nullable
              as double?,
      pendingOperator: freezed == pendingOperator
          ? _self.pendingOperator
          : pendingOperator // ignore: cast_nullable_to_non_nullable
              as String?,
      expressionLog: null == expressionLog
          ? _self.expressionLog
          : expressionLog // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as AddTransactionStatus,
      overflowDeficit: freezed == overflowDeficit
          ? _self.overflowDeficit
          : overflowDeficit // ignore: cast_nullable_to_non_nullable
              as double?,
      overflowSplits: null == overflowSplits
          ? _self.overflowSplits
          : overflowSplits // ignore: cast_nullable_to_non_nullable
              as List<OverflowSplit>,
      overflowIncome: null == overflowIncome
          ? _self.overflowIncome
          : overflowIncome // ignore: cast_nullable_to_non_nullable
              as double,
      editingTransaction: freezed == editingTransaction
          ? _self.editingTransaction
          : editingTransaction // ignore: cast_nullable_to_non_nullable
              as Transaction?,
    ));
  }

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get selectedCategory {
    if (_self.selectedCategory == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_self.selectedCategory!, (value) {
      return _then(_self.copyWith(selectedCategory: value));
    });
  }

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubcategoryCopyWith<$Res>? get selectedSubcategory {
    if (_self.selectedSubcategory == null) {
      return null;
    }

    return $SubcategoryCopyWith<$Res>(_self.selectedSubcategory!, (value) {
      return _then(_self.copyWith(selectedSubcategory: value));
    });
  }

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionCopyWith<$Res>? get editingTransaction {
    if (_self.editingTransaction == null) {
      return null;
    }

    return $TransactionCopyWith<$Res>(_self.editingTransaction!, (value) {
      return _then(_self.copyWith(editingTransaction: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AddTransactionState].
extension AddTransactionStatePatterns on AddTransactionState {
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
    TResult Function(_AddTransactionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState() when $default != null:
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
    TResult Function(_AddTransactionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState():
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
    TResult? Function(_AddTransactionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState() when $default != null:
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
            TransactionType transactionType,
            List<Category> categories,
            Map<int, List<Subcategory>> subcategoriesMap,
            int? expandedCategoryId,
            Category? selectedCategory,
            Subcategory? selectedSubcategory,
            bool subcategoryChosen,
            String amountInput,
            double? pendingValue,
            String? pendingOperator,
            String expressionLog,
            String note,
            AddTransactionStatus status,
            double? overflowDeficit,
            List<OverflowSplit> overflowSplits,
            double overflowIncome,
            Transaction? editingTransaction)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState() when $default != null:
        return $default(
            _that.transactionType,
            _that.categories,
            _that.subcategoriesMap,
            _that.expandedCategoryId,
            _that.selectedCategory,
            _that.selectedSubcategory,
            _that.subcategoryChosen,
            _that.amountInput,
            _that.pendingValue,
            _that.pendingOperator,
            _that.expressionLog,
            _that.note,
            _that.status,
            _that.overflowDeficit,
            _that.overflowSplits,
            _that.overflowIncome,
            _that.editingTransaction);
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
            TransactionType transactionType,
            List<Category> categories,
            Map<int, List<Subcategory>> subcategoriesMap,
            int? expandedCategoryId,
            Category? selectedCategory,
            Subcategory? selectedSubcategory,
            bool subcategoryChosen,
            String amountInput,
            double? pendingValue,
            String? pendingOperator,
            String expressionLog,
            String note,
            AddTransactionStatus status,
            double? overflowDeficit,
            List<OverflowSplit> overflowSplits,
            double overflowIncome,
            Transaction? editingTransaction)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState():
        return $default(
            _that.transactionType,
            _that.categories,
            _that.subcategoriesMap,
            _that.expandedCategoryId,
            _that.selectedCategory,
            _that.selectedSubcategory,
            _that.subcategoryChosen,
            _that.amountInput,
            _that.pendingValue,
            _that.pendingOperator,
            _that.expressionLog,
            _that.note,
            _that.status,
            _that.overflowDeficit,
            _that.overflowSplits,
            _that.overflowIncome,
            _that.editingTransaction);
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
            TransactionType transactionType,
            List<Category> categories,
            Map<int, List<Subcategory>> subcategoriesMap,
            int? expandedCategoryId,
            Category? selectedCategory,
            Subcategory? selectedSubcategory,
            bool subcategoryChosen,
            String amountInput,
            double? pendingValue,
            String? pendingOperator,
            String expressionLog,
            String note,
            AddTransactionStatus status,
            double? overflowDeficit,
            List<OverflowSplit> overflowSplits,
            double overflowIncome,
            Transaction? editingTransaction)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState() when $default != null:
        return $default(
            _that.transactionType,
            _that.categories,
            _that.subcategoriesMap,
            _that.expandedCategoryId,
            _that.selectedCategory,
            _that.selectedSubcategory,
            _that.subcategoryChosen,
            _that.amountInput,
            _that.pendingValue,
            _that.pendingOperator,
            _that.expressionLog,
            _that.note,
            _that.status,
            _that.overflowDeficit,
            _that.overflowSplits,
            _that.overflowIncome,
            _that.editingTransaction);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AddTransactionState implements AddTransactionState {
  const _AddTransactionState(
      {this.transactionType = TransactionType.expense,
      final List<Category> categories = const [],
      final Map<int, List<Subcategory>> subcategoriesMap = const {},
      this.expandedCategoryId,
      this.selectedCategory,
      this.selectedSubcategory,
      this.subcategoryChosen = false,
      this.amountInput = '',
      this.pendingValue,
      this.pendingOperator,
      this.expressionLog = '',
      this.note = '',
      this.status = AddTransactionStatus.idle,
      this.overflowDeficit,
      final List<OverflowSplit> overflowSplits = const [],
      this.overflowIncome = 0.0,
      this.editingTransaction})
      : _categories = categories,
        _subcategoriesMap = subcategoriesMap,
        _overflowSplits = overflowSplits;

  @override
  @JsonKey()
  final TransactionType transactionType;
  final List<Category> _categories;
  @override
  @JsonKey()
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final Map<int, List<Subcategory>> _subcategoriesMap;
  @override
  @JsonKey()
  Map<int, List<Subcategory>> get subcategoriesMap {
    if (_subcategoriesMap is EqualUnmodifiableMapView) return _subcategoriesMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_subcategoriesMap);
  }

  @override
  final int? expandedCategoryId;
  @override
  final Category? selectedCategory;
  @override
  final Subcategory? selectedSubcategory;
  @override
  @JsonKey()
  final bool subcategoryChosen;
  @override
  @JsonKey()
  final String amountInput;
  @override
  final double? pendingValue;
  @override
  final String? pendingOperator;
  @override
  @JsonKey()
  final String expressionLog;
  @override
  @JsonKey()
  final String note;
  @override
  @JsonKey()
  final AddTransactionStatus status;
  @override
  final double? overflowDeficit;
  final List<OverflowSplit> _overflowSplits;
  @override
  @JsonKey()
  List<OverflowSplit> get overflowSplits {
    if (_overflowSplits is EqualUnmodifiableListView) return _overflowSplits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_overflowSplits);
  }

  @override
  @JsonKey()
  final double overflowIncome;
  @override
  final Transaction? editingTransaction;

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddTransactionStateCopyWith<_AddTransactionState> get copyWith =>
      __$AddTransactionStateCopyWithImpl<_AddTransactionState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddTransactionState &&
            (identical(other.transactionType, transactionType) ||
                other.transactionType == transactionType) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._subcategoriesMap, _subcategoriesMap) &&
            (identical(other.expandedCategoryId, expandedCategoryId) ||
                other.expandedCategoryId == expandedCategoryId) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedSubcategory, selectedSubcategory) ||
                other.selectedSubcategory == selectedSubcategory) &&
            (identical(other.subcategoryChosen, subcategoryChosen) ||
                other.subcategoryChosen == subcategoryChosen) &&
            (identical(other.amountInput, amountInput) ||
                other.amountInput == amountInput) &&
            (identical(other.pendingValue, pendingValue) ||
                other.pendingValue == pendingValue) &&
            (identical(other.pendingOperator, pendingOperator) ||
                other.pendingOperator == pendingOperator) &&
            (identical(other.expressionLog, expressionLog) ||
                other.expressionLog == expressionLog) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.overflowDeficit, overflowDeficit) ||
                other.overflowDeficit == overflowDeficit) &&
            const DeepCollectionEquality()
                .equals(other._overflowSplits, _overflowSplits) &&
            (identical(other.overflowIncome, overflowIncome) ||
                other.overflowIncome == overflowIncome) &&
            (identical(other.editingTransaction, editingTransaction) ||
                other.editingTransaction == editingTransaction));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      transactionType,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_subcategoriesMap),
      expandedCategoryId,
      selectedCategory,
      selectedSubcategory,
      subcategoryChosen,
      amountInput,
      pendingValue,
      pendingOperator,
      expressionLog,
      note,
      status,
      overflowDeficit,
      const DeepCollectionEquality().hash(_overflowSplits),
      overflowIncome,
      editingTransaction);

  @override
  String toString() {
    return 'AddTransactionState(transactionType: $transactionType, categories: $categories, subcategoriesMap: $subcategoriesMap, expandedCategoryId: $expandedCategoryId, selectedCategory: $selectedCategory, selectedSubcategory: $selectedSubcategory, subcategoryChosen: $subcategoryChosen, amountInput: $amountInput, pendingValue: $pendingValue, pendingOperator: $pendingOperator, expressionLog: $expressionLog, note: $note, status: $status, overflowDeficit: $overflowDeficit, overflowSplits: $overflowSplits, overflowIncome: $overflowIncome, editingTransaction: $editingTransaction)';
  }
}

/// @nodoc
abstract mixin class _$AddTransactionStateCopyWith<$Res>
    implements $AddTransactionStateCopyWith<$Res> {
  factory _$AddTransactionStateCopyWith(_AddTransactionState value,
          $Res Function(_AddTransactionState) _then) =
      __$AddTransactionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TransactionType transactionType,
      List<Category> categories,
      Map<int, List<Subcategory>> subcategoriesMap,
      int? expandedCategoryId,
      Category? selectedCategory,
      Subcategory? selectedSubcategory,
      bool subcategoryChosen,
      String amountInput,
      double? pendingValue,
      String? pendingOperator,
      String expressionLog,
      String note,
      AddTransactionStatus status,
      double? overflowDeficit,
      List<OverflowSplit> overflowSplits,
      double overflowIncome,
      Transaction? editingTransaction});

  @override
  $CategoryCopyWith<$Res>? get selectedCategory;
  @override
  $SubcategoryCopyWith<$Res>? get selectedSubcategory;
  @override
  $TransactionCopyWith<$Res>? get editingTransaction;
}

/// @nodoc
class __$AddTransactionStateCopyWithImpl<$Res>
    implements _$AddTransactionStateCopyWith<$Res> {
  __$AddTransactionStateCopyWithImpl(this._self, this._then);

  final _AddTransactionState _self;
  final $Res Function(_AddTransactionState) _then;

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? transactionType = null,
    Object? categories = null,
    Object? subcategoriesMap = null,
    Object? expandedCategoryId = freezed,
    Object? selectedCategory = freezed,
    Object? selectedSubcategory = freezed,
    Object? subcategoryChosen = null,
    Object? amountInput = null,
    Object? pendingValue = freezed,
    Object? pendingOperator = freezed,
    Object? expressionLog = null,
    Object? note = null,
    Object? status = null,
    Object? overflowDeficit = freezed,
    Object? overflowSplits = null,
    Object? overflowIncome = null,
    Object? editingTransaction = freezed,
  }) {
    return _then(_AddTransactionState(
      transactionType: null == transactionType
          ? _self.transactionType
          : transactionType // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      subcategoriesMap: null == subcategoriesMap
          ? _self._subcategoriesMap
          : subcategoriesMap // ignore: cast_nullable_to_non_nullable
              as Map<int, List<Subcategory>>,
      expandedCategoryId: freezed == expandedCategoryId
          ? _self.expandedCategoryId
          : expandedCategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCategory: freezed == selectedCategory
          ? _self.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as Category?,
      selectedSubcategory: freezed == selectedSubcategory
          ? _self.selectedSubcategory
          : selectedSubcategory // ignore: cast_nullable_to_non_nullable
              as Subcategory?,
      subcategoryChosen: null == subcategoryChosen
          ? _self.subcategoryChosen
          : subcategoryChosen // ignore: cast_nullable_to_non_nullable
              as bool,
      amountInput: null == amountInput
          ? _self.amountInput
          : amountInput // ignore: cast_nullable_to_non_nullable
              as String,
      pendingValue: freezed == pendingValue
          ? _self.pendingValue
          : pendingValue // ignore: cast_nullable_to_non_nullable
              as double?,
      pendingOperator: freezed == pendingOperator
          ? _self.pendingOperator
          : pendingOperator // ignore: cast_nullable_to_non_nullable
              as String?,
      expressionLog: null == expressionLog
          ? _self.expressionLog
          : expressionLog // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as AddTransactionStatus,
      overflowDeficit: freezed == overflowDeficit
          ? _self.overflowDeficit
          : overflowDeficit // ignore: cast_nullable_to_non_nullable
              as double?,
      overflowSplits: null == overflowSplits
          ? _self._overflowSplits
          : overflowSplits // ignore: cast_nullable_to_non_nullable
              as List<OverflowSplit>,
      overflowIncome: null == overflowIncome
          ? _self.overflowIncome
          : overflowIncome // ignore: cast_nullable_to_non_nullable
              as double,
      editingTransaction: freezed == editingTransaction
          ? _self.editingTransaction
          : editingTransaction // ignore: cast_nullable_to_non_nullable
              as Transaction?,
    ));
  }

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get selectedCategory {
    if (_self.selectedCategory == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_self.selectedCategory!, (value) {
      return _then(_self.copyWith(selectedCategory: value));
    });
  }

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubcategoryCopyWith<$Res>? get selectedSubcategory {
    if (_self.selectedSubcategory == null) {
      return null;
    }

    return $SubcategoryCopyWith<$Res>(_self.selectedSubcategory!, (value) {
      return _then(_self.copyWith(selectedSubcategory: value));
    });
  }

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionCopyWith<$Res>? get editingTransaction {
    if (_self.editingTransaction == null) {
      return null;
    }

    return $TransactionCopyWith<$Res>(_self.editingTransaction!, (value) {
      return _then(_self.copyWith(editingTransaction: value));
    });
  }
}

// dart format on
