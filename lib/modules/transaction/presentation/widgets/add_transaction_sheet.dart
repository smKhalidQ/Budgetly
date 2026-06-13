import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_state.dart';
import 'package:budget_buddy/modules/transaction/presentation/widgets/overflow_source_sheet.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTransactionSheet extends StatelessWidget {
  final VoidCallback onSuccess;

  const AddTransactionSheet({super.key, required this.onSuccess});

  static void show(BuildContext context, {required VoidCallback onSuccess}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddTransactionSheet(onSuccess: onSuccess),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AddTransactionCubit>()..initialize(),
      child: _Body(onSuccess: onSuccess),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatefulWidget {
  final VoidCallback onSuccess;

  const _Body({required this.onSuccess});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddTransactionCubit, AddTransactionState>(
      listenWhen: (prev, curr) =>
          curr.status == AddTransactionStatus.success &&
          prev.status != curr.status,
      listener: (context, state) {
        Navigator.pop(context);
        widget.onSuccess();
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              const _Handle(),
              Expanded(
                child: BlocBuilder<AddTransactionCubit, AddTransactionState>(
                  buildWhen: (prev, curr) => prev.isOverflow != curr.isOverflow,
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: state.isOverflow
                          ? OverflowDecisionView(
                              key: const ValueKey('decision'),
                              onBack: () => context
                                  .read<AddTransactionCubit>()
                                  .clearOverflow(),
                            )
                          : _EntryView(
                              key: const ValueKey('entry'),
                              noteController: _noteController,
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Entry View (type + categories + numpad) ──────────────────────────────────

class _EntryView extends StatelessWidget {
  final TextEditingController noteController;

  const _EntryView({super.key, required this.noteController});

  @override
  Widget build(BuildContext context) {
    // The numpad shows while a category is expanded and hides on collapse —
    // keeps the list uncluttered while the user is still browsing.
    final hasSelection = context.select<AddTransactionCubit, bool>(
      (c) => c.state.expandedCategoryId != null,
    );

    return Column(
      children: [
        const _TypeToggle(),
        SizedBox(height: 4.h),
        const Expanded(child: _CategoriesSection()),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: hasSelection
              ? Column(
                  key: const ValueKey('numpad'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NoteRow(controller: noteController),
                    const _BottomSection(),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('no-numpad')),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    );
  }
}

// ─── Handle ───────────────────────────────────────────────────────────────────

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Container(
        width: 36.w,
        height: 4.h,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(2.r),
        ),
      ),
    );
  }
}

// ─── Type Toggle ──────────────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  const _TypeToggle();

  @override
  Widget build(BuildContext context) {
    final type = context.select<AddTransactionCubit, TransactionType>(
      (c) => c.state.transactionType,
    );
    final cubit = context.read<AddTransactionCubit>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColor.dividerColor),
        ),
        child: Row(
          children: [
            _TypeButton(
              label: 'Expense',
              isSelected: type == TransactionType.expense,
              selectedColor: AppColor.expenseColor,
              onTap: () => cubit.setType(TransactionType.expense),
            ),
            _TypeButton(
              label: 'Income',
              isSelected: type == TransactionType.income,
              selectedColor: AppColor.incomeColor,
              onTap: () => cubit.setType(TransactionType.income),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : Colors.transparent,
            borderRadius: BorderRadius.circular(9.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColor.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Categories Section ───────────────────────────────────────────────────────

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection();

  @override
  Widget build(BuildContext context) {
    final (categories, expandedId, type) = context
        .select<AddTransactionCubit, (List<Category>, int?, TransactionType)>(
      (c) => (
        c.state.categories,
        c.state.expandedCategoryId,
        c.state.transactionType,
      ),
    );

    final isExpense = type == TransactionType.expense;
    final displayed = (isExpense && expandedId != null)
        ? categories.where((c) => c.id == expandedId).toList()
        : categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 8.h),
          child: Text(
            'Select Category',
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
        ),
        if (isExpense && expandedId == null) ...[
          const _FrequentSubcategories(),
          SizedBox(height: 8.h),
        ],
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            itemCount: displayed.length,
            itemBuilder: (_, i) => _CategoryTile(category: displayed[i]),
          ),
        ),
      ],
    );
  }
}

class _FrequentSubcategories extends StatelessWidget {
  const _FrequentSubcategories();

  @override
  Widget build(BuildContext context) {
    final subs = context.select<AddTransactionCubit, List<Subcategory>>(
      (c) => c.state.topSubcategories,
    );
    if (subs.isEmpty) return const SizedBox.shrink();
    final cubit = context.read<AddTransactionCubit>();

    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: subs.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          final sub = subs[i];
          final color = parseColorFromString(sub.color);
          return GestureDetector(
            onTap: () => cubit.selectFromTop(sub),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              alignment: Alignment.center,
              child: Text(
                sub.name,
                textAlign: TextAlign.center,
                strutStyle: StrutStyle(fontSize: 12.sp, height: 1.0, forceStrutHeight: true),
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                  height: 1.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Category Tile ────────────────────────────────────────────────────────────

class _CategoryTile extends StatelessWidget {
  final Category category;

  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    final state = context.select<AddTransactionCubit,
        (int?, Category?, Subcategory?, TransactionType)>(
      (c) => (
        c.state.expandedCategoryId,
        c.state.selectedCategory,
        c.state.selectedSubcategory,
        c.state.transactionType,
      ),
    );
    final (expandedId, selectedCat, selectedSub, transactionType) = state;
    final isExpense = transactionType == TransactionType.expense;

    final isExpanded = expandedId == category.id;
    final isSelected = selectedCat?.id == category.id;
    final color = parseColorFromString(category.color);
    final remaining = category.allocatedAmount - category.spentAmount;
    final cubit = context.read<AddTransactionCubit>();

    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              isExpanded ? cubit.collapse() : cubit.selectCategory(category),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(vertical: 3.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? color.withValues(alpha: 0.4) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    IconData(int.parse(category.icon), fontFamily: 'MaterialIcons'),
                    color: color,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      Text(
                        'Remaining: $currencySymbol${remaining.toStringAsFixed(2)}',
                        style: GoogleFonts.cairo(
                          fontSize: 11.sp,
                          color: remaining > 0 ? color : AppColor.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isExpense)
                  GestureDetector(
                    onTap: () => isExpanded
                        ? cubit.collapse()
                        : cubit.selectCategory(category),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColor.textSecondary,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded && isExpense
                ? _SubcategoryList(
                    category: category,
                    selectedSubcategory: selectedSub,
                    categoryColor: color,
                    currencySymbol: currencySymbol,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

// ─── Subcategory List ─────────────────────────────────────────────────────────

class _SubcategoryList extends StatelessWidget {
  final Category category;
  final Subcategory? selectedSubcategory;
  final Color categoryColor;
  final String currencySymbol;

  const _SubcategoryList({
    required this.category,
    required this.selectedSubcategory,
    required this.categoryColor,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final subcategories = context.select<AddTransactionCubit, List<Subcategory>>(
      (c) => c.state.subcategoriesMap[category.id] ?? [],
    );
    final cubit = context.read<AddTransactionCubit>();

    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
      child: Column(
        children: [
          _SubcategoryTile(
            label: 'General (${category.name})',
            isSelected: selectedSubcategory == null,
            color: categoryColor,
            onTap: () => cubit.selectSubcategory(null),
          ),
          for (final sub in subcategories)
            _SubcategoryTile(
              label: sub.name,
              isSelected: selectedSubcategory?.id == sub.id,
              color: parseColorFromString(sub.color),
              onTap: () => cubit.selectSubcategory(sub),
            ),
        ],
      ),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _SubcategoryTile({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          children: [
            Container(
              width: 2.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.r),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? color : AppColor.textSecondary,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: color, size: 16.sp),
          ],
        ),
      ),
    );
  }
}

// ─── Note Row ─────────────────────────────────────────────────────────────────

class _NoteRow extends StatelessWidget {
  final TextEditingController controller;

  const _NoteRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
      child: TextField(
        controller: controller,
        onChanged: context.read<AddTransactionCubit>().updateNote,
        maxLines: 1,
        style: GoogleFonts.cairo(fontSize: 13.sp, color: AppColor.textPrimary),
        decoration: InputDecoration(
          hintText: 'Add a note (optional)',
          hintStyle: GoogleFonts.cairo(
            fontSize: 13.sp,
            color: AppColor.textSecondary,
          ),
          prefixIcon: Icon(
            Icons.notes_rounded,
            size: 18.sp,
            color: AppColor.textSecondary,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColor.dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColor.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColor.accentColor),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Section (Amount + Numpad) ─────────────────────────────────────────

class _BottomSection extends StatelessWidget {
  const _BottomSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AmountDisplay(),
          _Numpad(),
        ],
      ),
    );
  }
}

// ─── Amount Display ───────────────────────────────────────────────────────────

class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay();

  @override
  Widget build(BuildContext context) {
    final (amount, selectedCat, type) =
        context.select<AddTransactionCubit, (String, Category?, TransactionType)>(
      (c) => (c.state.amountInput, c.state.selectedCategory, c.state.transactionType),
    );

    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    final displayAmount = amount.isEmpty ? '0' : amount;
    final typeColor = type == TransactionType.expense
        ? AppColor.expenseColor
        : AppColor.incomeColor;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedCat != null)
                  Text(
                    selectedCat.name,
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      currencySymbol,
                      style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: typeColor,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      displayAmount,
                      style: GoogleFonts.cairo(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Numpad ───────────────────────────────────────────────────────────────────

class _Numpad extends StatelessWidget {
  const _Numpad();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddTransactionCubit>();
    final canSubmit = context.select<AddTransactionCubit, bool>(
      (c) => c.state.canSubmit,
    );
    final type = context.select<AddTransactionCubit, TransactionType>(
      (c) => c.state.transactionType,
    );

    final activeColor = type == TransactionType.expense
        ? AppColor.expenseColor
        : AppColor.incomeColor;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 8.h),
      child: Column(
        children: [
          Row(children: [
            _NumKey('1', onTap: () => cubit.appendDigit('1')),
            _NumKey('2', onTap: () => cubit.appendDigit('2')),
            _NumKey('3', onTap: () => cubit.appendDigit('3')),
            _NumKey(
              '',
              icon: Icons.backspace_outlined,
              onTap: cubit.removeDigit,
              onLongPress: () => cubit.removeDigit(),
            ),
          ]),
          Row(children: [
            _NumKey('4', onTap: () => cubit.appendDigit('4')),
            _NumKey('5', onTap: () => cubit.appendDigit('5')),
            _NumKey('6', onTap: () => cubit.appendDigit('6')),
            _NumKey('.', onTap: cubit.appendDecimal),
          ]),
          Row(children: [
            _NumKey('7', onTap: () => cubit.appendDigit('7')),
            _NumKey('8', onTap: () => cubit.appendDigit('8')),
            _NumKey('9', onTap: () => cubit.appendDigit('9')),
            _NumKey('00', onTap: () {
              cubit.appendDigit('0');
              cubit.appendDigit('0');
            }),
          ]),
          Row(children: [
            const Spacer(),
            _NumKey('0', onTap: () => cubit.appendDigit('0')),
            const Spacer(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: GestureDetector(
                  onTap: canSubmit ? cubit.submit : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: canSubmit
                          ? activeColor
                          : activeColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _NumKey(
    this.label, {
    this.icon,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColor.dividerColor),
            ),
            alignment: Alignment.center,
            child: icon != null
                ? Icon(icon, size: 20.sp, color: AppColor.textPrimary)
                : Text(
                    label,
                    style: GoogleFonts.cairo(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
