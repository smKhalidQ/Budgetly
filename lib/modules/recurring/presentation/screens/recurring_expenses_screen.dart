import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/recurring/domain/models/recurring_expense.dart';
import 'package:budget_buddy/modules/recurring/presentation/cubits/recurring_cubit.dart';
import 'package:budget_buddy/modules/recurring/presentation/cubits/recurring_state.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class RecurringExpensesScreen extends StatelessWidget {
  const RecurringExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<RecurringCubit>()..initialize(),
      child: const _RecurringView(),
    );
  }
}

class _RecurringView extends StatelessWidget {
  const _RecurringView();

  void _openEditor(BuildContext context, {RecurringExpense? existing}) {
    final cubit = context.read<RecurringCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ExpenseEditorSheet(existing: existing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Fixed Expenses',
          style: GoogleFonts.cairo(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.accentColor,
        onPressed: () => _openEditor(context),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: BlocBuilder<RecurringCubit, RecurringState>(
        builder: (context, state) {
          if (state.isLoading && state.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isEmpty) {
            return const _EmptyState();
          }

          final symbol = _currencySymbol(context);
          final byId = state.categoriesById;
          final subById = state.subcategoriesById;

          return ListView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
            children: [
              _TotalBanner(total: state.activeTotal, symbol: symbol),
              SizedBox(height: 12.h),
              for (final item in state.items)
                _ExpenseRow(
                  item: item,
                  category: byId[item.categoryId],
                  subcategoryName: item.subcategoryId == null
                      ? null
                      : subById[item.subcategoryId!]?.name,
                  symbol: symbol,
                  onTap: () => _openEditor(context, existing: item),
                ),
            ],
          );
        },
      ),
    );
  }
}

String _currencySymbol(BuildContext context) {
  final key = context.read<SettingCubit>().state.selectedCurrency ??
      currencies.keys.first;
  return currencies[key]?['currencySymbol'] ?? '';
}

// ─── Total Banner ─────────────────────────────────────────────────────────────

class _TotalBanner extends StatelessWidget {
  final double total;
  final String symbol;

  const _TotalBanner({required this.total, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      child: Row(
        children: [
          Icon(Icons.calculate_rounded, color: AppColor.primaryColor, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Posted automatically each new month',
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                color: AppColor.textSecondary,
              ),
            ),
          ),
          Text(
            '$symbol${total.toStringAsFixed(0)}',
            style: AppTextStyle.number(
              size: 16.sp,
              weight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Expense Row ──────────────────────────────────────────────────────────────

class _ExpenseRow extends StatelessWidget {
  final RecurringExpense item;
  final Category? category;
  final String? subcategoryName;
  final String symbol;
  final VoidCallback onTap;

  const _ExpenseRow({
    required this.item,
    required this.category,
    required this.subcategoryName,
    required this.symbol,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecurringCubit>();
    final color = category != null
        ? parseColorFromString(category!.color)
        : AppColor.categoryOthers;
    final catName = category?.name ?? 'Unknown';
    final note = item.note?.isNotEmpty == true ? item.note : null;
    final title = subcategoryName ?? note ?? catName;
    final subtitle = [
      if (title != catName) catName,
      if (subcategoryName != null && note != null) note,
    ].join(' · ');

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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
                    category != null
                        ? IconData(int.parse(category!.icon),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
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
                  ),
                ),
                Text(
                  '$symbol${item.amount.toStringAsFixed(0)}',
                  style: AppTextStyle.number(
                    size: 14.sp,
                    weight: FontWeight.bold,
                    color: item.isActive
                        ? AppColor.expenseColor
                        : AppColor.textTertiary,
                  ),
                ),
                SizedBox(width: 4.w),
                Switch(
                  value: item.isActive,
                  activeThumbColor: AppColor.accentColor,
                  onChanged: (_) => cubit.toggleActive(item),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.push_pin_rounded,
            size: 64.sp,
            color: AppColor.primaryColor.withValues(alpha: 0.15),
          ),
          SizedBox(height: 16.h),
          Text(
            'No fixed expenses yet',
            style: GoogleFonts.cairo(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Add bills like rent so they post each month',
            style: GoogleFonts.cairo(
              fontSize: 12.sp,
              color: AppColor.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Editor Sheet ─────────────────────────────────────────────────────────────

class _ExpenseEditorSheet extends StatefulWidget {
  final RecurringExpense? existing;

  const _ExpenseEditorSheet({this.existing});

  @override
  State<_ExpenseEditorSheet> createState() => _ExpenseEditorSheetState();
}

class _ExpenseEditorSheetState extends State<_ExpenseEditorSheet> {
  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;
  int? _categoryId;
  int? _subcategoryId;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _amountCtrl = TextEditingController(
      text: existing != null ? existing.amount.toStringAsFixed(0) : '',
    );
    _noteCtrl = TextEditingController(text: existing?.note ?? '');

    if (existing != null) {
      _categoryId = existing.categoryId;
      _subcategoryId = existing.subcategoryId;
    } else {
      final categories = context.read<RecurringCubit>().state.categories;
      if (categories.isNotEmpty) {
        _categoryId = categories.first.id;
        _subcategoryId = _firstSubId(_categoryId);
      }
    }
  }

  int? _firstSubId(int? categoryId) {
    if (categoryId == null) return null;
    final subs = context.read<RecurringCubit>().state.subcategoriesFor(categoryId);
    return subs.isEmpty ? null : subs.first.id;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (_categoryId == null || amount <= 0) return;

    final cubit = context.read<RecurringCubit>();
    final note = _noteCtrl.text.trim();
    final existing = widget.existing;

    if (existing == null) {
      cubit.addExpense(RecurringExpense(
        categoryId: _categoryId!,
        subcategoryId: _subcategoryId,
        amount: amount,
        note: note.isEmpty ? null : note,
      ));
    } else {
      cubit.updateExpense(
        existing.id!,
        existing.copyWith(
          categoryId: _categoryId!,
          subcategoryId: _subcategoryId,
          amount: amount,
          note: note.isEmpty ? null : note,
        ),
      );
    }
    Navigator.pop(context);
  }

  void _delete() {
    final existing = widget.existing;
    if (existing?.id != null) {
      context.read<RecurringCubit>().removeExpense(existing!.id!);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.select<RecurringCubit, List<Category>>(
      (c) => c.state.categories,
    );
    final canSave = _categoryId != null &&
        (double.tryParse(_amountCtrl.text.trim()) ?? 0) > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColor.borderColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                widget.existing == null ? 'New fixed expense' : 'Edit expense',
                style: GoogleFonts.cairo(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Category',
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final color = parseColorFromString(cat.color);
                    final selected = cat.id == _categoryId;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _categoryId = cat.id;
                        _subcategoryId = _firstSubId(cat.id);
                      }),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: selected
                              ? color.withValues(alpha: 0.15)
                              : AppColor.cardBackground,
                          borderRadius: BorderRadius.circular(AppRadius.md.r),
                          border: Border.all(
                            color: selected ? color : AppColor.dividerColor,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          cat.name,
                          style: GoogleFonts.cairo(
                            fontSize: 13.sp,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.normal,
                            color: selected ? color : AppColor.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_categoryId != null) ...[
                SizedBox(height: 16.h),
                Text(
                  'Subcategory',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                _SubcategorySelector(
                  categoryId: _categoryId!,
                  selectedId: _subcategoryId,
                  onSelected: (id) => setState(() => _subcategoryId = id),
                ),
              ],
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _Field(
                      label: 'Amount',
                      controller: _amountCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 3,
                    child: _Field(
                      label: 'Note (optional)',
                      controller: _noteCtrl,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  if (widget.existing != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColor.expenseColor,
                          side: const BorderSide(color: AppColor.expenseColor),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                        onPressed: _delete,
                        child: Text(
                          'Delete',
                          style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColor.primaryColor.withValues(alpha: 0.3),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                      onPressed: canSave ? _save : null,
                      child: Text(
                        'Save',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubcategorySelector extends StatelessWidget {
  final int categoryId;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const _SubcategorySelector({
    required this.categoryId,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final subs = context.select<RecurringCubit, List<Subcategory>>(
      (c) => c.state.subcategoriesFor(categoryId),
    );

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: subs.length + 1,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final isGeneral = i == 0;
          final sub = isGeneral ? null : subs[i - 1];
          final selected = isGeneral ? selectedId == null : sub!.id == selectedId;
          final color =
              isGeneral ? AppColor.primaryColor : parseColorFromString(sub!.color);
          return GestureDetector(
            onTap: () => onSelected(sub?.id),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: selected
                    ? color.withValues(alpha: 0.15)
                    : AppColor.cardBackground,
                borderRadius: BorderRadius.circular(AppRadius.md.r),
                border: Border.all(
                  color: selected ? color : AppColor.dividerColor,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                isGeneral ? 'General' : sub!.name,
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                  color: selected ? color : AppColor.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: GoogleFonts.cairo(fontSize: 14.sp, color: AppColor.textPrimary),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColor.cardBackground,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              borderSide: const BorderSide(color: AppColor.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md.r),
              borderSide: const BorderSide(color: AppColor.accentColor),
            ),
          ),
        ),
      ],
    );
  }
}
