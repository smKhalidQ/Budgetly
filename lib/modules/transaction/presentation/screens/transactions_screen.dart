import 'package:slice_pay/core/responsive/responsive_manager.dart';
import 'package:slice_pay/core/theming/app_color.dart';
import 'package:slice_pay/core/theming/app_radius.dart';
import 'package:slice_pay/core/theming/app_text_style.dart';
import 'package:slice_pay/core/utilities/constants.dart';
import 'package:slice_pay/l10n/app_localizations.dart';
import 'package:slice_pay/l10n/translation.dart';
import 'package:slice_pay/modules/category/domain/models/category.dart';
import 'package:slice_pay/modules/category/domain/models/category_localization.dart';
import 'package:slice_pay/modules/category/presentation/cubits/category_cubit.dart';
import 'package:slice_pay/modules/transaction/domain/models/transaction.dart';
import 'package:slice_pay/modules/transaction/domain/models/transaction_coverage.dart';
import 'package:slice_pay/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:slice_pay/modules/transaction/domain/services/transaction_balance_service.dart';
import 'package:slice_pay/modules/transaction/presentation/cubits/transaction_cubit.dart';
import 'package:slice_pay/modules/transaction/presentation/cubits/transaction_state.dart';
import 'package:slice_pay/modules/transaction/presentation/screens/add_transaction_screen.dart';
import 'package:slice_pay/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

// â”€â”€â”€ Screen â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late final TransactionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = GetIt.I<TransactionCubit>()..initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Container(
        color: AppColor.backgroundColor,
        child: Column(
          children: [
            CustomScrollView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverOverlapInjector(
                    handle:
                        NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context)),
                const SliverToBoxAdapter(
                  child: Column(
                    children: [_FilterBar(), _SummaryStrip()],
                  ),
                ),
              ],
            ),
            const Expanded(child: _Body()),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Filter Bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  static String _periodLabel(AppLocalizations t, TransactionPeriod period) {
    return switch (period) {
      TransactionPeriod.today => t.today,
      TransactionPeriod.week => t.thisWeek,
      TransactionPeriod.month => t.thisMonth,
    };
  }

  void _showPeriodDropdown(
      BuildContext context, TransactionPeriod current, TransactionCubit cubit) {
    final t = context.tr;
    final button = context.findRenderObject() as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<TransactionPeriod>(
      context: context,
      position: position,
      color: AppColor.cardBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md.r)),
      elevation: 4,
      items: TransactionPeriod.values
          .map((p) => PopupMenuItem(
                value: p,
                height: 42.h,
                child: Row(
                  children: [
                    Icon(
                      p == TransactionPeriod.today
                          ? Icons.today_rounded
                          : p == TransactionPeriod.week
                              ? Icons.date_range_rounded
                              : Icons.calendar_month_rounded,
                      size: 16.sp,
                      color: p == current
                          ? AppColor.primaryColor
                          : AppColor.textSecondary,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      _periodLabel(t, p),
                      style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight:
                            p == current ? FontWeight.w700 : FontWeight.w500,
                        color: p == current
                            ? AppColor.primaryColor
                            : AppColor.textPrimary,
                      ),
                    ),
                    if (p == current) ...[
                      const Spacer(),
                      Icon(Icons.check_rounded,
                          size: 14.sp, color: AppColor.primaryColor),
                    ],
                  ],
                ),
              ))
          .toList(),
    ).then((selected) {
      if (selected != null) cubit.setPeriod(selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    final (period, grouping) = context
        .select<TransactionCubit, (TransactionPeriod, TransactionGrouping)>(
            (c) => (c.state.period, c.state.grouping));
    final cubit = context.read<TransactionCubit>();
    final t = context.tr;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 10.h),
      child: Row(
        children: [
          Builder(
            builder: (btnCtx) => GestureDetector(
              onTap: () => _showPeriodDropdown(btnCtx, period, cubit),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColor.borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event_rounded,
                        size: 14.sp, color: AppColor.primaryColor),
                    SizedBox(width: 6.w),
                    Text(
                      _periodLabel(t, period),
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        size: 16.sp, color: AppColor.textSecondary),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          _GroupingTabs(grouping: grouping, onChanged: cubit.setGrouping),
        ],
      ),
    );
  }
}

class _GroupingTabs extends StatelessWidget {
  final TransactionGrouping grouping;
  final ValueChanged<TransactionGrouping> onChanged;

  const _GroupingTabs({required this.grouping, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    final tabs = [
      (TransactionGrouping.byDate, Icons.event_rounded, t.dateLabel),
      (TransactionGrouping.byCategory, Icons.grid_view_rounded, t.categoryLabel),
    ];

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColor.surfaceMuted,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (value, icon, label) in tabs)
            _GroupingTabIcon(
              icon: icon,
              label: label,
              isSelected: grouping == value,
              onTap: () => onChanged(value),
            ),
        ],
      ),
    );
  }
}

class _GroupingTabIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GroupingTabIcon({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.cardBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.backgroundCardShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15.sp,
              color: isSelected ? AppColor.primaryColor : AppColor.textSecondary,
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color:
                    isSelected ? AppColor.primaryColor : AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€ Summary Strip â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip();

  @override
  Widget build(BuildContext context) {
    final (expense, income) =
        context.select<TransactionCubit, (double, double)>(
            (c) => (c.state.filteredExpense, c.state.filteredIncome));
    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    final t = context.tr;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Row(
        children: [
          _StripStat(
              label: t.spentLabel,
              value: '$currencySymbol${expense.toStringAsFixed(0)}',
              color: AppColor.expenseColor),
          SizedBox(width: 16.w),
          _StripStat(
              label: t.incomeLabel,
              value: '$currencySymbol${income.toStringAsFixed(0)}',
              color: AppColor.incomeColor),
        ],
      ),
    );
  }
}

class _StripStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StripStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5.w),
        Text('$label ',
            style: GoogleFonts.cairo(
                fontSize: 12.sp, color: AppColor.textSecondary)),
        Text(value,
            style: AppTextStyle.number(
                size: 12.sp, weight: FontWeight.bold, color: color)),
      ],
    );
  }
}

// â”€â”€â”€ Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final (grouping, isLoading) =
        context.select<TransactionCubit, (TransactionGrouping, bool)>(
            (c) => (c.state.grouping, c.state.isLoading));

    if (isLoading) return const Center(child: CircularProgressIndicator());

    return switch (grouping) {
      TransactionGrouping.byDate => const _ByDateList(),
      TransactionGrouping.byCategory => const _ByCategoryList(),
    };
  }
}

// â”€â”€â”€ By Date â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ByDateList extends StatelessWidget {
  const _ByDateList();

  @override
  Widget build(BuildContext context) {
    final groups = context
        .select<TransactionCubit, List<MapEntry<DateTime, List<Transaction>>>>(
            (c) => c.state.filteredGroupedByDay);

    if (groups.isEmpty) return const _EmptyState();

    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });
    final categoriesById = context.select<TransactionCubit, Map<int, Category>>(
        (c) => c.state.categoriesById);

    return CustomScrollView(
      slivers: [
        for (final group in groups) ...[
          SliverToBoxAdapter(child: _DayHeader(day: group.key)),
          SliverList.builder(
            itemCount: group.value.length,
            itemBuilder: (_, i) => _TransactionRow(
              transaction: group.value[i],
              category: categoriesById[group.value[i].categoryId],
              categoriesById: categoriesById,
              currencySymbol: currencySymbol,
            ),
          ),
        ],
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
      ],
    );
  }
}

// â”€â”€â”€ By Category â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ByCategoryList extends StatelessWidget {
  const _ByCategoryList();

  @override
  Widget build(BuildContext context) {
    final groups = context
        .select<TransactionCubit, List<MapEntry<Category, List<Transaction>>>>(
            (c) => c.state.filteredGroupedByCategory);

    if (groups.isEmpty) return const _EmptyState();

    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });
    final categoriesById = context.select<TransactionCubit, Map<int, Category>>(
        (c) => c.state.categoriesById);

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16.h),
      itemCount: groups.length,
      itemBuilder: (_, i) {
        return _CategoryGroup(
          category: groups[i].key,
          transactions: groups[i].value,
          currencySymbol: currencySymbol,
          categoriesById: categoriesById,
        );
      },
    );
  }
}

class _CategoryGroup extends StatefulWidget {
  final Category category;
  final List<Transaction> transactions;
  final String currencySymbol;
  final Map<int, Category> categoriesById;

  const _CategoryGroup({
    required this.category,
    required this.transactions,
    required this.currencySymbol,
    required this.categoriesById,
  });

  @override
  State<_CategoryGroup> createState() => _CategoryGroupState();
}

class _CategoryGroupState extends State<_CategoryGroup> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
            child: Row(
              children: [
                Text(widget.category.localizedName(context.tr),
                    style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textSecondary)),
                SizedBox(width: 6.w),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16.sp,
                      color: AppColor.textSecondary.withValues(alpha: 0.5)),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: widget.transactions
                          .map((t) => _TransactionRow(
                                transaction: t,
                                category: widget.category,
                                categoriesById: widget.categoriesById,
                                currencySymbol: widget.currencySymbol,
                              ))
                          .toList(),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€ Day Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _DayHeader extends StatelessWidget {
  final DateTime day;
  const _DayHeader({required this.day});

  String _label(AppLocalizations t) {
    final today = DateTime.now();
    final d = DateTime(today.year, today.month, today.day);
    final diff = d.difference(day).inDays;
    if (diff == 0) return t.today;
    if (diff == 1) return t.yesterday;
    return '${day.day}/${day.month}/${day.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      child: Text(_label(context.tr),
          style: GoogleFonts.cairo(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textSecondary)),
    );
  }
}

// â”€â”€â”€ Transaction Row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TransactionRow extends StatefulWidget {
  final Transaction transaction;
  final Category? category;
  final Map<int, Category> categoriesById;
  final String currencySymbol;

  const _TransactionRow({
    required this.transaction,
    required this.category,
    required this.categoriesById,
    required this.currencySymbol,
  });

  @override
  State<_TransactionRow> createState() => _TransactionRowState();
}

class _TransactionRowState extends State<_TransactionRow> {
  bool _expanded = false;
  Transaction get _txn => widget.transaction;

  void _deleteWithUndo() {
    final t = context.tr;
    final categoryCubit = context.read<CategoryCubit>();
    final repo = GetIt.I<TransactionRepository>();
    final balanceService = GetIt.I<TransactionBalanceService>();
    final messenger = ScaffoldMessenger.of(context);
    final removed = _txn;

    repo
        .delete(removed.id!)
        .then((_) => balanceService.reverseEffect(removed))
        .then((_) => categoryCubit.fetchCategories());

    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(t.transactionDeleted,
            style: GoogleFonts.cairo(fontSize: 12.sp)),
        action: SnackBarAction(
          label: t.undo,
          onPressed: () => repo
              .add(removed.copyWith(id: null))
              .then((_) => balanceService.applyEffect(removed))
              .then((_) => categoryCubit.fetchCategories()),
        ),
      ));
  }

  void _openEdit() {
    AddTransactionScreen.show(
      context,
      editing: _txn,
      onSuccess: () => context.read<CategoryCubit>().fetchCategories(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_txn.type == TransactionType.rollover) return const SizedBox.shrink();

    final isIncome = _txn.type == TransactionType.income;
    final color = widget.category != null
        ? parseColorFromString(widget.category!.color)
        : AppColor.categoryOthers;
    final amountColor = isIncome ? AppColor.incomeColor : AppColor.expenseColor;
    final coverage = TransactionCoverage.parse(_txn.coverage);

    final rowContent = GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: _expanded
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
                    widget.category?.localizedName(context.tr) ?? context.tr.unknown,
                    style: GoogleFonts.cairo(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary),
                  ),
                  if (_txn.note != null && _txn.note!.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(_txn.note!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                            fontSize: 11.sp, color: AppColor.textSecondary)),
                  ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '${isIncome ? '+' : '-'}${widget.currencySymbol}${_txn.amount.toStringAsFixed(2)}',
              style: AppTextStyle.number(
                  size: 13.sp, weight: FontWeight.bold, color: amountColor),
            ),
            SizedBox(width: 4.w),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.keyboard_arrow_down_rounded,
                  size: 16.sp,
                  color: AppColor.textSecondary.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );

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
                  onPressed: (_) => _openEdit(),
                  backgroundColor: AppColor.accentColor,
                  foregroundColor: Colors.white,
                  icon: Icons.edit_rounded,
                  label: context.tr.editAction,
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(AppRadius.md.r)),
                ),
                SlidableAction(
                  onPressed: (_) => _deleteWithUndo(),
                  backgroundColor: AppColor.expenseColor,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_rounded,
                  label: context.tr.deleteAction,
                  borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(AppRadius.md.r)),
                ),
              ],
            ),
            child: rowContent,
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _expanded
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

// â”€â”€â”€ Expanded Details â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    final d = transaction.date;
    final dateLabel =
        '${d.day}/${d.month}/${d.year} Â· ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    final cov = coverage;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.surfaceMuted,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.md.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailLine(label: t.dateLabel, value: dateLabel),
          if (transaction.note != null && transaction.note!.isNotEmpty)
            _DetailLine(label: t.noteLabel, value: transaction.note!),
          if (cov != null && (cov.sources.isNotEmpty || cov.income > 0)) ...[
            SizedBox(height: 6.h),
            Text(t.coveredFrom,
                style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textSecondary)),
            SizedBox(height: 4.h),
            for (final s in cov.sources)
              _CoverageChip(
                  name: categoriesById[s.categoryId]?.localizedName(t) ??
                      t.unknown,
                  amount: s.amount,
                  currencySymbol: currencySymbol),
            if (cov.income > 0)
              _CoverageChip(
                  name: t.newIncome,
                  amount: cov.income,
                  currencySymbol: currencySymbol),
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
            width: 40.w,
            child: Text(label,
                style: GoogleFonts.cairo(
                    fontSize: 11.sp, color: AppColor.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary)),
          ),
        ],
      ),
    );
  }
}

class _CoverageChip extends StatelessWidget {
  final String name;
  final double amount;
  final String currencySymbol;

  const _CoverageChip(
      {required this.name, required this.amount, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Icon(Icons.arrow_right_rounded,
              size: 14.sp, color: AppColor.textSecondary),
          SizedBox(width: 4.w),
          Text(name,
              style: GoogleFonts.cairo(
                  fontSize: 11.sp, color: AppColor.textPrimary)),
          const Spacer(),
          Text('$currencySymbol${amount.toStringAsFixed(0)}',
              style: AppTextStyle.number(
                  size: 11.sp,
                  weight: FontWeight.bold,
                  color: AppColor.textSecondary)),
        ],
      ),
    );
  }
}

// â”€â”€â”€ Empty State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded,
              size: 64.sp,
              color: AppColor.primaryColor.withValues(alpha: 0.15)),
          SizedBox(height: 12.h),
          Text(context.tr.noTransactions,
              style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textSecondary)),
          SizedBox(height: 4.h),
          Text(context.tr.tryDifferentPeriod,
              style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}
