import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_state.dart';
import 'package:budget_buddy/modules/transaction/presentation/widgets/overflow_source_sheet.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTransactionScreen extends StatelessWidget {
  final VoidCallback onSuccess;
  final Transaction? editing;
  final int? initialCategoryId;
  final int? initialSubcategoryId;
  final bool subcategoryPreselected;
  final TransactionType? initialType;
  final Animation<double> animation;

  const AddTransactionScreen({
    super.key,
    required this.onSuccess,
    required this.animation,
    this.editing,
    this.initialCategoryId,
    this.initialSubcategoryId,
    this.subcategoryPreselected = false,
    this.initialType,
  });

  static void show(
    BuildContext context, {
    required VoidCallback onSuccess,
    Transaction? editing,
    int? initialCategoryId,
    int? initialSubcategoryId,
    bool subcategoryPreselected = false,
    TransactionType? initialType,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        reverseTransitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, animation, __) => AddTransactionScreen(
          onSuccess: onSuccess,
          editing: editing,
          initialCategoryId: initialCategoryId,
          initialSubcategoryId: initialSubcategoryId,
          subcategoryPreselected: subcategoryPreselected,
          initialType: initialType,
          animation: animation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = GetIt.I<AddTransactionCubit>();
        if (editing != null) {
          cubit.initializeForEdit(editing!);
        } else {
          if (initialType != null) cubit.setType(initialType!);
          cubit.initialize(
            initialCategoryId: initialCategoryId,
            initialSubcategoryId: initialSubcategoryId,
            subcategoryPreselected: subcategoryPreselected,
          );
        }
        return cubit;
      },
      child: _Body(
        onSuccess: onSuccess,
        editing: editing,
        animation: animation,
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatefulWidget {
  final VoidCallback onSuccess;
  final Transaction? editing;
  final Animation<double> animation;

  const _Body({
    required this.onSuccess,
    required this.animation,
    this.editing,
  });

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.editing?.note ?? '');
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
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: AppColor.backgroundColor,
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: BlocBuilder<AddTransactionCubit, AddTransactionState>(
              buildWhen: (prev, curr) => prev.isOverflow != curr.isOverflow,
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: state.isOverflow
                      ? SafeArea(
                          key: const ValueKey('decision'),
                          child: OverflowDecisionView(
                            onBack: () => context
                                .read<AddTransactionCubit>()
                                .clearOverflow(),
                          ),
                        )
                      : _EntryView(
                          key: const ValueKey('entry'),
                          animation: widget.animation,
                          noteController: _noteController,
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Entry View (split halves) ────────────────────────────────────────────────

class _EntryView extends StatelessWidget {
  final Animation<double> animation;
  final TextEditingController noteController;

  const _EntryView({
    super.key,
    required this.animation,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
    final topSlide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(curved);
    final bottomSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(curved);

    return Column(
      children: [
        const _EntryAppBar(),
        Expanded(
          child: ClipRect(
            child: SlideTransition(
              position: topSlide,
              child: const _TopHalf(),
            ),
          ),
        ),
        ClipRect(
          child: SlideTransition(
            position: bottomSlide,
            child: _BottomHalf(noteController: noteController),
          ),
        ),
      ],
    );
  }
}

// ─── Top Half (category context) ──────────────────────────────────────────────

class _TopHalf extends StatelessWidget {
  const _TopHalf();

  @override
  Widget build(BuildContext context) {
    final isIncome = context.select<AddTransactionCubit, bool>(
      (c) => c.state.transactionType == TransactionType.income,
    );

    return Column(
      children: [
        SizedBox(height: 8.h),
        Expanded(
          child: isIncome ? const _IncomeTop() : const _ExpenseTop(),
        ),
      ],
    );
  }
}

class _EntryAppBar extends StatelessWidget {
  const _EntryAppBar();

  @override
  Widget build(BuildContext context) {
    final (isIncome, isEditing) =
        context.select<AddTransactionCubit, (bool, bool)>(
      (c) => (
        c.state.transactionType == TransactionType.income,
        c.state.isEditing,
      ),
    );

    final title = isIncome
        ? (isEditing ? 'Edit Income' : 'Add Income')
        : (isEditing ? 'Edit Expense' : 'Add Expense');

    return AppBar(
      backgroundColor: AppColor.primaryColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: GoogleFonts.cairo(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
      ],
    );
  }
}

// ─── Expense Top (single category) ────────────────────────────────────────────

class _ExpenseTop extends StatelessWidget {
  const _ExpenseTop();

  @override
  Widget build(BuildContext context) {
    final category = context.select<AddTransactionCubit, Category?>(
      (c) => c.state.selectedCategory,
    );
    if (category == null) return const SizedBox.shrink();

    return Column(
      children: [
        _CategoryHeader(category: category),
        SizedBox(height: 12.h),
        _SubcategoryChips(category: category),
        SizedBox(height: 10.h),
        Divider(height: 1, indent: 20.w, endIndent: 20.w),
        const Spacer(),
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final Category category;

  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = parseColorFromString(category.color);
    final remaining = category.allocatedAmount - category.spentAmount;

    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconData(int.parse(category.icon), fontFamily: 'MaterialIcons'),
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
                  category.name,
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
                Text(
                  'Remaining: $currencySymbol${remaining.toStringAsFixed(2)}',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: remaining > 0 ? color : AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubcategoryChips extends StatelessWidget {
  final Category category;

  const _SubcategoryChips({required this.category});

  @override
  Widget build(BuildContext context) {
    final subcategories =
        context.select<AddTransactionCubit, List<Subcategory>>(
      (c) => c.state.subcategoriesMap[category.id] ?? [],
    );
    final (selectedSub, subChosen) =
        context.select<AddTransactionCubit, (Subcategory?, bool)>(
      (c) => (c.state.selectedSubcategory, c.state.subcategoryChosen),
    );
    final cubit = context.read<AddTransactionCubit>();
    final categoryColor = parseColorFromString(category.color);

    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: subcategories.length + 1,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, i) {
          if (i == 0) {
            return _SubcategoryChip(
              label: 'General',
              color: categoryColor,
              isSelected: subChosen && selectedSub == null,
              onTap: () => cubit.selectSubcategory(null),
            );
          }
          final sub = subcategories[i - 1];
          return _SubcategoryChip(
            label: sub.name,
            color: parseColorFromString(sub.color),
            isSelected: selectedSub?.id == sub.id,
            onTap: () => cubit.selectSubcategory(sub),
          );
        },
      ),
    );
  }
}

class _SubcategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _SubcategoryChip({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          strutStyle:
              StrutStyle(fontSize: 12.sp, height: 1.0, forceStrutHeight: true),
          style: GoogleFonts.cairo(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : color,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

// ─── Income Top (category list) ───────────────────────────────────────────────

class _IncomeTop extends StatelessWidget {
  const _IncomeTop();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Add to which budget?',
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textSecondary,
              ),
            ),
          ),
        ),
        const Expanded(child: _IncomeCategoryList()),
      ],
    );
  }
}

class _IncomeCategoryList extends StatelessWidget {
  const _IncomeCategoryList();

  @override
  Widget build(BuildContext context) {
    final (categories, selectedId) =
        context.select<AddTransactionCubit, (List<Category>, int?)>(
      (c) => (c.state.categories, c.state.selectedCategory?.id),
    );

    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      itemCount: categories.length,
      itemBuilder: (_, i) => _IncomeCategoryTile(
        category: categories[i],
        isSelected: categories[i].id == selectedId,
        currencySymbol: currencySymbol,
      ),
    );
  }
}

class _IncomeCategoryTile extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final String currencySymbol;

  const _IncomeCategoryTile({
    required this.category,
    required this.isSelected,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final color = parseColorFromString(category.color);
    final remaining = category.allocatedAmount - category.spentAmount;

    return GestureDetector(
      onTap: () =>
          context.read<AddTransactionCubit>().selectCategory(category),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.08)
              : AppColor.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                isSelected ? color.withValues(alpha: 0.4) : Colors.transparent,
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
                IconData(int.parse(category.icon),
                    fontFamily: 'MaterialIcons'),
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
            if (isSelected)
              Icon(Icons.check_rounded, color: color, size: 18.sp),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Half (note + amount + numpad) ─────────────────────────────────────

class _BottomHalf extends StatelessWidget {
  final TextEditingController noteController;

  const _BottomHalf({required this.noteController});

  @override
  Widget build(BuildContext context) {
    final showNumpad = context.select<AddTransactionCubit, bool>(
      (c) => c.state.showNumpad,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: showNumpad
          ? Column(
              key: const ValueKey('numpad'),
              mainAxisSize: MainAxisSize.min,
              children: [
                _NoteRow(controller: noteController),
                const _BottomSection(),
              ],
            )
          : const SizedBox.shrink(key: ValueKey('no-numpad')),
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
          fillColor: AppColor.cardBackground,
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
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: AppColor.backgroundCardShadow,
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
    final (displayTotal, expression, hasPending, selectedCat, selectedSub, type) =
        context.select<
            AddTransactionCubit,
            (String, String, bool, Category?, Subcategory?, TransactionType)>(
      (c) => (
        c.state.displayTotal,
        c.state.amountExpression,
        c.state.hasPendingOperation,
        c.state.selectedCategory,
        c.state.selectedSubcategory,
        c.state.transactionType,
      ),
    );

    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    final isExpense = type == TransactionType.expense;
    final typeColor =
        isExpense ? AppColor.expenseColor : AppColor.incomeColor;
    final label = selectedCat == null
        ? null
        : isExpense
            ? '${selectedCat.name} · ${selectedSub?.name ?? 'General'}'
            : selectedCat.name;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (label != null)
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.cairo(
                      fontSize: 12.sp,
                      color: AppColor.textSecondary,
                    ),
                  ),
                ),
              if (hasPending)
                Text(
                  expression,
                  style: AppTextStyle.number(
                    size: 14.sp,
                    weight: FontWeight.w500,
                    color: AppColor.textSecondary,
                  ),
                ),
            ],
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
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
                    displayTotal,
                    style: AppTextStyle.number(
                      size: 34.sp,
                      weight: FontWeight.bold,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Numpad (with arithmetic) ─────────────────────────────────────────────────

class _Numpad extends StatelessWidget {
  const _Numpad();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddTransactionCubit>();
    final canSubmit = context.select<AddTransactionCubit, bool>(
      (c) => c.state.canSubmit,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 8.h),
      child: SizedBox(
        height: 250.h,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: Row(children: [
                      _NumKey('1', onTap: () => cubit.appendDigit('1')),
                      _NumKey('2', onTap: () => cubit.appendDigit('2')),
                      _NumKey('3', onTap: () => cubit.appendDigit('3')),
                    ]),
                  ),
                  Expanded(
                    child: Row(children: [
                      _NumKey('4', onTap: () => cubit.appendDigit('4')),
                      _NumKey('5', onTap: () => cubit.appendDigit('5')),
                      _NumKey('6', onTap: () => cubit.appendDigit('6')),
                    ]),
                  ),
                  Expanded(
                    child: Row(children: [
                      _NumKey('7', onTap: () => cubit.appendDigit('7')),
                      _NumKey('8', onTap: () => cubit.appendDigit('8')),
                      _NumKey('9', onTap: () => cubit.appendDigit('9')),
                    ]),
                  ),
                  Expanded(
                    child: Row(children: [
                      _NumKey('.', onTap: cubit.appendDecimal),
                      _NumKey('0', onTap: () => cubit.appendDigit('0')),
                      _NumKey(
                        '',
                        icon: Icons.backspace_outlined,
                        onTap: cubit.removeDigit,
                        onLongPress: cubit.clearAmount,
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  _NumKey('÷',
                      isOperator: true,
                      onTap: () => cubit.appendOperator('÷')),
                  _NumKey('×',
                      isOperator: true,
                      onTap: () => cubit.appendOperator('×')),
                  _NumKey('−',
                      isOperator: true,
                      onTap: () => cubit.appendOperator('−')),
                  _NumKey('+',
                      isOperator: true,
                      onTap: () => cubit.appendOperator('+')),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: GestureDetector(
                        onTap: canSubmit ? cubit.submit : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: canSubmit
                                ? AppColor.secondaryColor
                                : AppColor.secondaryColor
                                    .withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumKey extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isOperator;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _NumKey(
    this.label, {
    this.icon,
    this.isOperator = false,
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
            decoration: BoxDecoration(
              color: isOperator
                  ? AppColor.accentColor.withValues(alpha: 0.08)
                  : AppColor.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isOperator
                    ? AppColor.accentColor.withValues(alpha: 0.3)
                    : AppColor.dividerColor,
              ),
            ),
            alignment: Alignment.center,
            child: icon != null
                ? Icon(icon, size: 20.sp, color: AppColor.textPrimary)
                : Text(
                    label,
                    style: AppTextStyle.number(
                      size: 20.sp,
                      weight: FontWeight.w500,
                      color: isOperator
                          ? AppColor.accentColor
                          : AppColor.textPrimary,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
