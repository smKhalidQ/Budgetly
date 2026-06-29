import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/widgets/picker_dialog_helpers.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/manage_categories_cubit.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/manage_categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> {
  late final ManageCategoriesCubit _cubit;
  final Map<int, TextEditingController> _controllers = {};
  late final TextEditingController _salaryCtrl;

  late final String _symbol;

  @override
  void initState() {
    super.initState();
    _salaryCtrl = TextEditingController();
    _cubit = GetIt.I<ManageCategoriesCubit>()..initialize();
    _cubit.stream.firstWhere((s) => s.newSalary > 0).then((s) {
      if (mounted) {
        _salaryCtrl.text = s.newSalary.toStringAsFixed(0);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<SettingCubit>();
    final currency = cubit.state.selectedCurrency ?? 'USD';
    _symbol = currencies[currency]?['currencySymbol'] ?? '';
  }

  @override
  void dispose() {
    _cubit.close();
    _salaryCtrl.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(int id, double base) {
    return _controllers.putIfAbsent(
      id,
      () =>
          TextEditingController(text: base > 0 ? base.toStringAsFixed(0) : ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<ManageCategoriesCubit, ManageCategoriesState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status &&
            curr.status == ManageCategoriesStatus.success &&
            prev.status == ManageCategoriesStatus.saving,
        listener: (context, state) {
          if (state.deferredNames.isNotEmpty) {
            _showDeferredDialog(context, state.deferredNames);
          } else {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.backgroundColor,
            appBar: AppBar(
              backgroundColor: AppColor.backgroundColor,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_outlined,
                    color: AppColor.primaryColor),
              ),
              title: Text(
                'Manage Categories',
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: AppColor.primaryColor,
                ),
              ),
              actions: [
                if (state.isLoading)
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  TextButton(
                    onPressed: state.isOver
                        ? null
                        : () => state.remaining > 0.01
                            ? _showSavingDialog(context, state.remaining)
                            : _cubit.save(),
                    child: Text(
                      'Save',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        color: state.isOver
                            ? AppColor.textSecondary
                            : AppColor.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _addCategory(context),
              backgroundColor: AppColor.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            body: Column(
              children: [
                _HeaderBanner(
                  salary: state.newSalary,
                  remaining: state.remaining,
                  symbol: _symbol,
                  salaryCtrl: _salaryCtrl,
                  onSalaryChanged: (v) {
                    final val = double.tryParse(v) ?? 0;
                    _cubit.updateSalary(val);
                  },
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 4.h, bottom: 80.h),
                    itemCount: state.categories.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 74.w,
                      endIndent: 20.w,
                      color: AppColor.dividerColor,
                    ),
                    itemBuilder: (context, index) {
                      final cat = state.categories[index];
                      if (cat.id == null) return const SizedBox.shrink();
                      final ctrl = _controllerFor(
                        cat.id!,
                        state.baseFor(cat),
                      );
                      return _CategoryRow(
                        category: cat,
                        controller: ctrl,
                        symbol: _symbol,
                        isDeferred: state.isDeferredFor(cat),
                        onChanged: (v) {
                          final val = double.tryParse(v) ?? 0;
                          _cubit.updateBase(cat.id!, val);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addCategory(BuildContext context) {
    PickerDialogHelpers.showCategoryPickerDialog(
      context: context,
      title: 'New Category',
      pickerFunction: (Category newCat) => _cubit.addCategory(newCat),
    );
  }

  void _showSavingDialog(BuildContext context, double remaining) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (ctx, animation, _, __) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r)),
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        color: AppColor.accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.savings_rounded,
                          color: AppColor.accentColor, size: 30.sp),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Remaining Balance',
                      style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          color: AppColor.textSecondary,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'You have '),
                          TextSpan(
                            text: '$_symbol${remaining.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColor.accentColor,
                            ),
                          ),
                          const TextSpan(text: ' unallocated'),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 13.h),
                              side: const BorderSide(
                                  color: AppColor.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Adjust',
                              style: GoogleFonts.cairo(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _cubit.saveWithRemainderToSaving();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 13.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Add to Saving',
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeferredDialog(BuildContext context, List<String> names) {
    final joined = names.join(', ');
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Partially applied',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '$joined: already spent more than the new budget — '
          'the new budget will apply from next month.',
          style: GoogleFonts.cairo(fontSize: 13.sp),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ─── Header Banner ────────────────────────────────────────────────────────────

class _HeaderBanner extends StatelessWidget {
  final double salary;
  final double remaining;
  final String symbol;
  final TextEditingController salaryCtrl;
  final ValueChanged<String> onSalaryChanged;

  const _HeaderBanner({
    required this.salary,
    required this.remaining,
    required this.symbol,
    required this.salaryCtrl,
    required this.onSalaryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isOver = remaining < -0.01;
    final allocated = salary - remaining;
    final progress = salary > 0 ? (allocated / salary).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Salary',
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 140.w,
                      child: TextField(
                        controller: salaryCtrl,
                        onTap: () => salaryCtrl.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: salaryCtrl.text.length,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryColor,
                        ),
                        decoration: InputDecoration(
                          prefixText: '$symbol ',
                          prefixStyle: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryColor.withValues(alpha: 0.7),
                          ),
                          hintText: '0',
                          hintStyle: GoogleFonts.poppins(
                            color: AppColor.textTertiary,
                            fontSize: 15.sp,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 10.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(
                              color: AppColor.borderColor,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                                color: AppColor.primaryColor, width: 1.5),
                          ),
                          filled: true,
                          fillColor:
                              AppColor.primaryColor.withValues(alpha: 0.04),
                        ),
                        onChanged: onSalaryChanged,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: (isOver ? AppColor.expenseColor : AppColor.accentColor)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  isOver
                      ? '$symbol${remaining.abs().toStringAsFixed(0)} over'
                      : remaining.abs() <= 0.01
                          ? 'Fully allocated'
                          : '$symbol${remaining.toStringAsFixed(0)} remaining',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color:
                        isOver ? AppColor.expenseColor : AppColor.accentColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: AppColor.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOver ? AppColor.expenseColor : AppColor.accentColor,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              '${(progress * 100).toStringAsFixed(0)}% allocated',
              style: GoogleFonts.cairo(
                fontSize: 11.sp,
                color: AppColor.textSecondary,
              ),
            ),
          ),
          if (isOver) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 14.sp, color: AppColor.expenseColor),
                SizedBox(width: 6.w),
                Text(
                  'Total exceeds salary — reduce some categories to save',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: AppColor.expenseColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Category Row ─────────────────────────────────────────────────────────────

class _CategoryRow extends StatelessWidget {
  final Category category;
  final TextEditingController controller;
  final String symbol;
  final bool isDeferred;
  final ValueChanged<String> onChanged;

  const _CategoryRow({
    required this.category,
    required this.controller,
    required this.symbol,
    required this.isDeferred,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = parseColorFromString(category.color);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconData(int.parse(category.icon), fontFamily: 'MaterialIcons'),
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textPrimary,
                  ),
                ),
                if (isDeferred)
                  Text(
                    'Next month · spent $symbol${category.spentAmount.toStringAsFixed(0)}',
                    style: GoogleFonts.cairo(
                      fontSize: 10.sp,
                      color: AppColor.accentColor,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: 116.w,
            child: TextField(
              controller: controller,
              onTap: () => controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              ),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              decoration: InputDecoration(
                prefixText: '$symbol ',
                prefixStyle: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: color.withValues(alpha: 0.7),
                ),
                hintText: '0',
                hintStyle: GoogleFonts.poppins(
                  color: AppColor.textTertiary,
                  fontSize: 15.sp,
                ),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(
                    color: AppColor.borderColor,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: color, width: 1.5),
                ),
                filled: true,
                fillColor: color.withValues(alpha: 0.04),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
