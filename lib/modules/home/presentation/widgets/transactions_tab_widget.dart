import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction_coverage.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_state.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionsTabWidget extends StatefulWidget {
  const TransactionsTabWidget({super.key});

  @override
  State<TransactionsTabWidget> createState() => _TransactionsTabWidgetState();
}

class _TransactionsTabWidgetState extends State<TransactionsTabWidget> {
  int? _editingId;

  void _startEdit(int id) => setState(() => _editingId = id);
  void _stopEdit() => setState(() => _editingId = null);

  String? _subName(TransactionState state, Transaction t) =>
      t.subcategoryId == null
          ? null
          : state.subcategoriesById[t.subcategoryId!]?.name;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (prev, curr) =>
          prev.transactions != curr.transactions ||
          prev.categoriesById != curr.categoriesById ||
          prev.subcategoriesById != curr.subcategoriesById ||
          prev.status != curr.status,
      builder: (context, state) {
        if (state.isEmpty && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.isEmpty) {
          return const _EmptyState();
        }

        final currencySymbol = context.select<SettingCubit, String>((c) {
          final key = c.state.selectedCurrency ?? currencies.keys.first;
          return currencies[key]?['currencySymbol'] ?? '';
        });

        if (_editingId != null) {
          Transaction? editing;
          for (final t in state.transactions) {
            if (t.id == _editingId) {
              editing = t;
              break;
            }
          }
          if (editing != null) {
            return ListView(
              padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
              children: [
                _TransactionRow(
                  transaction: editing,
                  category: state.categoriesById[editing.categoryId],
                  categoriesById: state.categoriesById,
                  subcategoryName: _subName(state, editing),
                  currencySymbol: currencySymbol,
                  isEditing: true,
                  onStartEdit: _startEdit,
                  onStopEdit: _stopEdit,
                ),
              ],
            );
          }
        }

        final groups = state.groupedByDay;

        return CustomScrollView(
          slivers: [
            for (final group in groups) ...[
              SliverToBoxAdapter(
                child: _DayHeader(day: group.key),
              ),
              SliverList.builder(
                itemCount: group.value.length,
                itemBuilder: (_, i) {
                  final transaction = group.value[i];
                  return _TransactionRow(
                    transaction: transaction,
                    category: state.categoriesById[transaction.categoryId],
                    categoriesById: state.categoriesById,
                    subcategoryName: _subName(state, transaction),
                    currencySymbol: currencySymbol,
                    isEditing: false,
                    onStartEdit: _startEdit,
                    onStopEdit: _stopEdit,
                  );
                },
              ),
            ],
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          ],
        );
      },
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 72.sp,
            color: AppColor.primaryColor.withValues(alpha: 0.15),
          ),
          SizedBox(height: 16.h),
          Text(
            t.noTransactionsYet,
            style: GoogleFonts.cairo(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            t.startTracking,
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: AppColor.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Day Header ───────────────────────────────────────────────────────────────

class _DayHeader extends StatelessWidget {
  final DateTime day;

  const _DayHeader({required this.day});

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${day.day}/${day.month}/${day.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      child: Text(
        _label(),
        style: GoogleFonts.cairo(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.textSecondary,
        ),
      ),
    );
  }
}

// ─── Transaction Row ──────────────────────────────────────────────────────────

class _TransactionRow extends StatefulWidget {
  final Transaction transaction;
  final Category? category;
  final Map<int, Category> categoriesById;
  final String? subcategoryName;
  final String currencySymbol;
  final bool isEditing;
  final ValueChanged<int> onStartEdit;
  final VoidCallback onStopEdit;

  const _TransactionRow({
    required this.transaction,
    required this.category,
    required this.categoriesById,
    required this.subcategoryName,
    required this.currencySymbol,
    required this.isEditing,
    required this.onStartEdit,
    required this.onStopEdit,
  });

  @override
  State<_TransactionRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<_TransactionRow> {
  bool _expanded = false;

  Transaction get _txn => widget.transaction;

  void _startEdit() => widget.onStartEdit(_txn.id!);

  void _cancelEdit() => widget.onStopEdit();

  void _toggleExpand() => setState(() => _expanded = !_expanded);

  void _saveExpense(double amount, Map<int, double> sources, double income) {
    final categoryCubit = context.read<CategoryCubit>();
    context
        .read<TransactionCubit>()
        .editExpenseCoverage(_txn, amount, sources, income)
        .then((_) => categoryCubit.fetchCategories());
    widget.onStopEdit();
  }

  void _saveIncome(double amount) {
    final categoryCubit = context.read<CategoryCubit>();
    context
        .read<TransactionCubit>()
        .editIncomeAmount(_txn, amount)
        .then((_) => categoryCubit.fetchCategories());
    widget.onStopEdit();
  }

  void _deleteWithUndo() {
    final transactionCubit = context.read<TransactionCubit>();
    final categoryCubit = context.read<CategoryCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final removed = _txn;

    transactionCubit
        .deleteTransaction(removed)
        .then((_) => categoryCubit.fetchCategories());

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Transaction deleted',
            style: GoogleFonts.cairo(fontSize: 12.sp),
          ),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => transactionCubit
                .restoreTransaction(removed)
                .then((_) => categoryCubit.fetchCategories()),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_txn.type == TransactionType.rollover) {
      return _RolloverRow(
        transaction: _txn,
        currencySymbol: widget.currencySymbol,
      );
    }

    final isIncome = _txn.type == TransactionType.income;
    final color = widget.category != null
        ? parseColorFromString(widget.category!.color)
        : AppColor.categoryOthers;
    final amountColor = isIncome ? AppColor.incomeColor : AppColor.expenseColor;
    final sign = isIncome ? '+' : '-';

    final title = widget.subcategoryName ?? widget.category?.name ?? 'Unknown';
    final subtitle = _txn.note;
    final coverage = TransactionCoverage.parse(_txn.coverage);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        children: [
          Slidable(
            key: ValueKey('txn-${_txn.id}'),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.5,
              children: [
                SlidableAction(
                  onPressed: (_) => _startEdit(),
                  backgroundColor: AppColor.accentColor,
                  foregroundColor: Colors.white,
                  icon: Icons.edit_rounded,
                  label: 'Edit',
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(AppRadius.md.r)),
                ),
                SlidableAction(
                  onPressed: (_) => _deleteWithUndo(),
                  backgroundColor: AppColor.expenseColor,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_rounded,
                  label: 'Delete',
                  borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(AppRadius.md.r)),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: widget.isEditing ? null : _toggleExpand,
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColor.cardBackground,
                  borderRadius: (_expanded || widget.isEditing)
                      ? BorderRadius.vertical(top: Radius.circular(AppRadius.md.r))
                      : BorderRadius.circular(AppRadius.md.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.category != null
                            ? IconData(int.parse(widget.category!.icon),
                                fontFamily: 'MaterialIcons')
                            : Icons.help_outline_rounded,
                        color: color,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.cairo(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          if (subtitle != null && subtitle.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                fontSize: 11.sp,
                                color: AppColor.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '$sign${widget.currencySymbol}${_txn.amount.toStringAsFixed(2)}',
                      style: AppTextStyle.number(
                        size: 14.sp,
                        weight: FontWeight.bold,
                        color: amountColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    AnimatedRotation(
                      turns: (_expanded || widget.isEditing) ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18.sp,
                        color: AppColor.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: widget.isEditing
                  ? _InlineEditor(
                      transaction: _txn,
                      primaryCategory: widget.category,
                      coverage: coverage,
                      categoriesById: widget.categoriesById,
                      currencySymbol: widget.currencySymbol,
                      onSaveExpense: _saveExpense,
                      onSaveIncome: _saveIncome,
                      onCancel: _cancelEdit,
                    )
                  : _expanded
                      ? _ExpandedDetails(
                          transaction: _txn,
                          coverage: coverage,
                          categoriesById: widget.categoriesById,
                          currencySymbol: widget.currencySymbol,
                        )
                      : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Expanded Details ─────────────────────────────────────────────────────────

class _ExpandedDetails extends StatelessWidget {
  final Transaction transaction;
  final TransactionCoverage? coverage;
  final Map<int, Category> categoriesById;
  final String currencySymbol;

  const _ExpandedDetails({
    required this.transaction,
    required this.coverage,
    required this.categoriesById,
    required this.currencySymbol,
  });

  String _dateLabel() {
    final d = transaction.date;
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day}/${d.month}/${d.year} · $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final cov = coverage;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.surfaceMuted,
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(AppRadius.md.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailLine(label: 'Date', value: _dateLabel()),
          if (transaction.note != null && transaction.note!.isNotEmpty)
            _DetailLine(label: 'Note', value: transaction.note!),
          if (cov != null && (cov.sources.isNotEmpty || cov.income > 0)) ...[
            SizedBox(height: 8.h),
            Text(
              'Covered from',
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textSecondary,
              ),
            ),
            SizedBox(height: 6.h),
            for (final source in cov.sources)
              _CoverageSourceRow(
                category: categoriesById[source.categoryId],
                amount: source.amount,
                currencySymbol: currencySymbol,
              ),
            if (cov.income > 0)
              _CoverageSourceRow(
                category: null,
                label: 'New income',
                amount: cov.income,
                currencySymbol: currencySymbol,
              ),
          ],
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48.w,
            child: Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                color: AppColor.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverageSourceRow extends StatelessWidget {
  final Category? category;
  final String? label;
  final double amount;
  final String currencySymbol;

  const _CoverageSourceRow({
    required this.category,
    this.label,
    required this.amount,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final color = category != null
        ? parseColorFromString(category!.color)
        : AppColor.incomeColor;
    final name = category?.name ?? label ?? 'Unknown';

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
      ),
      child: Row(
        children: [
          Container(
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              category != null
                  ? IconData(int.parse(category!.icon),
                      fontFamily: 'MaterialIcons')
                  : Icons.add_card_rounded,
              color: color,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
          ),
          Text(
            '$currencySymbol${amount.toStringAsFixed(2)}',
            style: AppTextStyle.number(
              size: 13.sp,
              weight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Inline Editor ────────────────────────────────────────────────────────────

/// Edits a transaction below its card. For an expense it re-records against the
/// baseline (as if the original never happened): the primary covers what it
/// can, and the remaining deficit is taken from other categories via fields.
class _InlineEditor extends StatefulWidget {
  final Transaction transaction;
  final Category? primaryCategory;
  final TransactionCoverage? coverage;
  final Map<int, Category> categoriesById;
  final String currencySymbol;
  final void Function(double amount, Map<int, double> sources, double income)
      onSaveExpense;
  final ValueChanged<double> onSaveIncome;
  final VoidCallback onCancel;

  const _InlineEditor({
    required this.transaction,
    required this.primaryCategory,
    required this.coverage,
    required this.categoriesById,
    required this.currencySymbol,
    required this.onSaveExpense,
    required this.onSaveIncome,
    required this.onCancel,
  });

  @override
  State<_InlineEditor> createState() => _InlineEditorState();
}

class _InlineEditorState extends State<_InlineEditor> {
  late final TextEditingController _amountController;
  late final bool _isIncome;
  late final double _baselinePrimaryAvailable;
  late final Map<int, double> _initialLent;
  late final List<Category> _candidates;
  late final TextEditingController _incomeController;
  late final double _initialIncome;
  final Map<int, double> _lenderAmounts = {};
  final Map<int, TextEditingController> _lenderControllers = {};

  double _amount = 0;
  double _income = 0;

  @override
  void initState() {
    super.initState();
    final txn = widget.transaction;
    _isIncome = txn.type == TransactionType.income;
    _amount = txn.amount;
    _amountController = TextEditingController(text: _fmt(txn.amount));

    final borrowed = widget.coverage?.borrowed ?? 0;
    final primaryRemaining = widget.primaryCategory == null
        ? 0.0
        : widget.primaryCategory!.allocatedAmount -
            widget.primaryCategory!.spentAmount;
    _baselinePrimaryAvailable = primaryRemaining + txn.amount - borrowed;

    _initialIncome = widget.coverage?.income ?? 0;
    _income = _initialIncome;
    _incomeController = TextEditingController(text: _fmt(_income));

    _initialLent = {
      for (final s in widget.coverage?.sources ?? const []) s.categoryId: s.amount,
    };

    _candidates = _isIncome
        ? const []
        : widget.categoriesById.values.where((c) {
            if (c.id == null || c.id == txn.categoryId) return false;
            return _maxFor(c) > 0;
          }).toList();

    for (final c in _candidates) {
      final value = _initialLent[c.id] ?? 0;
      _lenderAmounts[c.id!] = value;
      _lenderControllers[c.id!] = TextEditingController(text: _fmt(value));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _incomeController.dispose();
    for (final controller in _lenderControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _fmt(double v) => v <= 0
      ? ''
      : (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2));

  double _maxFor(Category c) =>
      (c.allocatedAmount - c.spentAmount) + (_initialLent[c.id] ?? 0);

  double get _deficit {
    final d = _amount - _baselinePrimaryAvailable;
    return d > 0 ? d : 0;
  }

  double get _lenderSum => _lenderAmounts.values.fold(0.0, (a, b) => a + b);
  double get _coveredSum => _lenderSum + _income;

  bool get _balanced {
    if (_amount <= 0) return false;
    if (_isIncome || _deficit == 0) return true;
    return (_coveredSum - _deficit).abs() < 0.01;
  }

  void _onAmountChanged(String text) {
    setState(() {
      _amount = double.tryParse(text) ?? 0;
      _recomputeFromOriginal();
    });
  }

  void _recomputeFromOriginal() {
    final deficit = _deficit;

    var income = _initialIncome;
    if (income > deficit) income = deficit;
    _income = income;
    _incomeController.text = _fmt(income);

    var need = deficit - income;
    if (need < 0) need = 0;

    final amounts = {
      for (final c in _candidates) c.id!: (_initialLent[c.id] ?? 0),
    };
    var reduction = amounts.values.fold(0.0, (a, b) => a + b) - need;
    if (reduction > 0) {
      for (final c in _candidates) {
        if (reduction <= 0.001) break;
        final current = amounts[c.id!]!;
        if (current <= 0) continue;
        final cut = current <= reduction ? current : reduction;
        amounts[c.id!] = current - cut;
        reduction -= cut;
      }
    }

    for (final c in _candidates) {
      _lenderAmounts[c.id!] = amounts[c.id!]!;
      _lenderControllers[c.id!]!.text = _fmt(amounts[c.id!]!);
    }
  }

  void _onIncomeChanged(String text) {
    var value = double.tryParse(text) ?? 0;
    if (value < 0) value = 0;
    var cap = _deficit - _lenderSum;
    if (cap < 0) cap = 0;
    if (value > cap) {
      value = cap;
      final clamped = _fmt(value);
      _incomeController.value = TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: clamped.length),
      );
    }
    setState(() => _income = value);
  }

  void _onLenderChanged(Category c, String text) {
    var value = double.tryParse(text) ?? 0;
    if (value < 0) value = 0;
    final id = c.id!;
    final othersCovered = _coveredSum - (_lenderAmounts[id] ?? 0);
    var cap = _deficit - othersCovered;
    if (cap < 0) cap = 0;
    final max = _maxFor(c);
    if (max < cap) cap = max;
    if (value > cap) {
      value = cap;
      final clamped = _fmt(value);
      _lenderControllers[id]!.value = TextEditingValue(
        text: clamped,
        selection: TextSelection.collapsed(offset: clamped.length),
      );
    }
    setState(() => _lenderAmounts[id] = value);
  }

  void _save() {
    if (!_balanced) return;
    if (_isIncome) {
      widget.onSaveIncome(_amount);
    } else {
      final sources = _deficit == 0
          ? <int, double>{}
          : Map<int, double>.from(_lenderAmounts);
      final income = _deficit == 0 ? 0.0 : _income;
      widget.onSaveExpense(_amount, sources, income);
    }
  }

  @override
  Widget build(BuildContext context) {
    final symbol = widget.currencySymbol;
    final showLenders = !_isIncome && _deficit > 0;
    final remaining = _deficit - _coveredSum;
    final balancedNow = remaining.abs() < 0.01;
    final overCovered = remaining < -0.01;
    final remainingColor = balancedNow
        ? AppColor.incomeColor
        : (overCovered ? AppColor.expenseColor : AppColor.accentColor);
    final remainingLabel = balancedNow
        ? 'All covered'
        : (overCovered
            ? 'Over by $symbol${(-remaining).toStringAsFixed(0)}'
            : 'Remaining: $symbol${remaining.toStringAsFixed(0)}');
    final primaryPart = _amount - _deficit;
    final primaryColor = widget.primaryCategory != null
        ? parseColorFromString(widget.primaryCategory!.color)
        : AppColor.primaryColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.surfaceMuted,
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(AppRadius.md.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Total amount',
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textSecondary,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 124.w,
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: AppTextStyle.number(
                    size: 15.sp,
                    weight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                  onChanged: _onAmountChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColor.cardBackground,
                    prefixText: symbol,
                    prefixStyle: AppTextStyle.number(
                      size: 13.sp,
                      weight: FontWeight.w600,
                      color: AppColor.textSecondary,
                    ),
                    suffixIcon: Icon(
                      Icons.edit_rounded,
                      size: 15.sp,
                      color: AppColor.accentColor,
                    ),
                    suffixIconConstraints:
                        BoxConstraints(minWidth: 30.w, minHeight: 0),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm.r),
                      borderSide: BorderSide(
                        color: AppColor.accentColor.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm.r),
                      borderSide:
                          const BorderSide(color: AppColor.accentColor, width: 1.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (showLenders) ...[
            SizedBox(height: 12.h),
            _coverageBar(primaryPart, primaryColor),
            SizedBox(height: 6.h),
            Row(
              children: [
                Text(
                  'From ${widget.primaryCategory?.name ?? 'category'}: $symbol${primaryPart.toStringAsFixed(0)}',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                const Spacer(),
                Text(
                  remainingLabel,
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: remainingColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              'Take from',
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textSecondary,
              ),
            ),
            SizedBox(height: 6.h),
            for (final c in _candidates) _lenderRow(c, symbol),
            _incomeRow(symbol),
          ],
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.onCancel,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColor.cardBackground,
                      borderRadius: BorderRadius.circular(AppRadius.sm.r),
                      border: Border.all(color: AppColor.dividerColor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: _balanced ? _save : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: _balanced
                          ? AppColor.primaryColor
                          : AppColor.primaryColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadius.sm.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Save',
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _coverageBar(double primaryPart, Color primaryColor) {
    final parts = <(int, Color)>[];
    final pf = (primaryPart * 100).round();
    if (pf > 0) parts.add((pf, primaryColor));
    for (final c in _candidates) {
      final amount = _lenderAmounts[c.id!] ?? 0;
      if (amount > 0) {
        parts.add(((amount * 100).round(), parseColorFromString(c.color)));
      }
    }
    if (_income > 0) parts.add(((_income * 100).round(), AppColor.incomeColor));

    final covered = _coveredSum > _deficit ? _deficit : _coveredSum;
    final remaining = _deficit - covered;
    final rf = (remaining < 0 ? 0.0 : remaining * 100).round();

    final children = <Widget>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0) {
        children.add(Container(width: 1.5.w, color: AppColor.cardBackground));
      }
      children.add(
        Expanded(flex: parts[i].$1, child: Container(color: parts[i].$2)),
      );
    }
    if (rf > 0) {
      if (children.isNotEmpty) {
        children.add(Container(width: 1.5.w, color: AppColor.cardBackground));
      }
      children.add(
        Expanded(flex: rf, child: Container(color: AppColor.borderColor)),
      );
    }
    if (children.isEmpty) {
      children.add(Expanded(child: Container(color: AppColor.borderColor)));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: SizedBox(height: 7.h, child: Row(children: children)),
    );
  }

  Widget _incomeRow(String symbol) {
    final color = AppColor.incomeColor;

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
      ),
      child: Row(
        children: [
          Container(
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_card_rounded, color: color, size: 14.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'From new income',
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 68.w,
            child: TextField(
              controller: _incomeController,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: AppTextStyle.number(
                size: 13.sp,
                weight: FontWeight.bold,
                color: color,
              ),
              onChanged: _onIncomeChanged,
              decoration: InputDecoration(
                isDense: true,
                hintText: '0',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  borderSide: const BorderSide(color: AppColor.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  borderSide: BorderSide(color: color, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lenderRow(Category c, String symbol) {
    final color = parseColorFromString(c.color);

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.sm.r),
      ),
      child: Row(
        children: [
          Container(
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconData(int.parse(c.icon), fontFamily: 'MaterialIcons'),
              color: color,
              size: 14.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                ),
                Text(
                  'Available: $symbol${(_maxFor(c) - (_lenderAmounts[c.id!] ?? 0)).toStringAsFixed(0)}',
                  style: GoogleFonts.cairo(
                    fontSize: 10.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          SizedBox(
            width: 68.w,
            child: TextField(
              controller: _lenderControllers[c.id!],
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: AppTextStyle.number(
                size: 13.sp,
                weight: FontWeight.bold,
                color: color,
              ),
              onChanged: (text) => _onLenderChanged(c, text),
              decoration: InputDecoration(
                isDense: true,
                hintText: '0',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  borderSide: const BorderSide(color: AppColor.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  borderSide: BorderSide(color: color, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Rollover Row ─────────────────────────────────────────────────────────────

class _RolloverRow extends StatelessWidget {
  final Transaction transaction;
  final String currencySymbol;

  const _RolloverRow({
    required this.transaction,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final note = transaction.note ?? 'Month-end savings';
    final parts = note.split(' · ');
    final title = parts.first;
    final subtitle = parts.length > 1 ? parts[1] : null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
        border: Border.all(color: AppColor.accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColor.accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.savings_rounded,
              color: AppColor.accentColor,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.accentColor,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.cairo(
                      fontSize: 11.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '+$currencySymbol${transaction.amount.toStringAsFixed(2)}',
            style: AppTextStyle.number(
              size: 14.sp,
              weight: FontWeight.bold,
              color: AppColor.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
