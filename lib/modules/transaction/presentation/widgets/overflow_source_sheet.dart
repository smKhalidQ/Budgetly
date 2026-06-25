import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_state.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// The conscious-decision view: when an expense exceeds a category's balance,
/// the user deliberately chooses which other envelopes cover the difference.
/// Embedded inline inside [AddTransactionSheet] (no nested modal) — [onBack]
/// returns to the entry view, confirmation is handled by the parent sheet.
class OverflowDecisionView extends StatelessWidget {
  final VoidCallback onBack;

  const OverflowDecisionView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Header(currencySymbol: currencySymbol, onBack: onBack),
        _DeficitMeter(currencySymbol: currencySymbol),
        SizedBox(height: 8.h),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _SplitList(currencySymbol: currencySymbol),
                const _IncomeSourceRow(),
              ],
            ),
          ),
        ),
        const _ConfirmRow(),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
      ],
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String currencySymbol;
  final VoidCallback onBack;

  const _Header({required this.currencySymbol, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final deficit = context.select<AddTransactionCubit, double>(
      (c) => c.state.overflowDeficit ?? 0,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 0, 20.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColor.textSecondary,
                    size: 20.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.balance_rounded,
                  color: AppColor.primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Cover the difference',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Text(
              'You need $currencySymbol${deficit.toStringAsFixed(2)} more. '
              'Choose which categories it comes from — you\'ll feel it there later.',
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                color: AppColor.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Deficit Meter ────────────────────────────────────────────────────────────

class _DeficitMeter extends StatelessWidget {
  final String currencySymbol;

  const _DeficitMeter({required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AddTransactionCubit>().state;
    final amount = state.parsedAmount;
    final deficit = state.overflowDeficit ?? 0;
    final covered = state.overflowCovered;
    final isFull = state.overflowFullyCovered;

    final primaryColor = state.selectedCategory != null
        ? parseColorFromString(state.selectedCategory!.color)
        : AppColor.primaryColor;
    final primaryName = state.selectedCategory?.name ?? 'category';
    final primaryPart = amount - deficit;
    final remaining = deficit - covered;
    final remainingColor =
        isFull ? AppColor.incomeColor : AppColor.accentColor;
    final remainingLabel = isFull
        ? 'All covered'
        : 'Remaining: $currencySymbol${remaining.toStringAsFixed(0)}';

    final parts = <(int, Color)>[];
    if (primaryPart > 0) parts.add(((primaryPart * 100).round(), primaryColor));
    for (final split in state.overflowSplits) {
      if (split.amount > 0) {
        parts.add((
          (split.amount * 100).round(),
          parseColorFromString(split.category.color),
        ));
      }
    }
    if (state.overflowIncome > 0) {
      parts.add(((state.overflowIncome * 100).round(), AppColor.incomeColor));
    }
    final rf = (remaining < 0 ? 0.0 : remaining * 100).round();

    final barChildren = <Widget>[];
    for (var i = 0; i < parts.length; i++) {
      if (i > 0) {
        barChildren.add(Container(width: 1.5.w, color: AppColor.cardBackground));
      }
      barChildren.add(
        Expanded(flex: parts[i].$1, child: Container(color: parts[i].$2)),
      );
    }
    if (rf > 0) {
      if (barChildren.isNotEmpty) {
        barChildren.add(Container(width: 1.5.w, color: AppColor.cardBackground));
      }
      barChildren.add(
        Expanded(flex: rf, child: Container(color: AppColor.borderColor)),
      );
    }
    if (barChildren.isEmpty) {
      barChildren.add(Expanded(child: Container(color: AppColor.borderColor)));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isFull
                ? AppColor.incomeColor.withValues(alpha: 0.4)
                : AppColor.dividerColor,
          ),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: SizedBox(height: 7.h, child: Row(children: barChildren)),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  'From $primaryName: $currencySymbol${primaryPart.toStringAsFixed(0)}',
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
          ],
        ),
      ),
    );
  }
}

// ─── Split List ───────────────────────────────────────────────────────────────

class _SplitList extends StatelessWidget {
  final String currencySymbol;

  const _SplitList({required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final splits = context.select<AddTransactionCubit, List<OverflowSplit>>(
      (c) => c.state.overflowSplits,
    );

    if (splits.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        for (final split in splits)
          _SplitRow(split: split, currencySymbol: currencySymbol),
        SizedBox(height: 8.h),
      ],
    );
  }
}

// ─── Split Row ────────────────────────────────────────────────────────────────

class _SplitRow extends StatelessWidget {
  final OverflowSplit split;
  final String currencySymbol;

  const _SplitRow({
    required this.split,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final color = parseColorFromString(split.category.color);
    final cubit = context.read<AddTransactionCubit>();
    final (covered, deficit) =
        context.select<AddTransactionCubit, (double, double)>(
      (c) => (c.state.overflowCovered, c.state.overflowDeficit ?? 0),
    );
    final remainingNeed =
        (deficit - (covered - split.amount)).clamp(0.0, deficit);
    final maxTake =
        remainingNeed < split.available ? remainingNeed : split.available;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: split.amount > 0
              ? color.withValues(alpha: 0.4)
              : AppColor.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconData(
                int.parse(split.category.icon),
                fontFamily: 'MaterialIcons',
              ),
              color: color,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  split.category.name,
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                ),
                Text(
                  'Available: $currencySymbol${(split.available - split.amount).toStringAsFixed(2)}',
                  style: AppTextStyle.number(
                    size: 11.sp,
                    weight: FontWeight.w400,
                    color: AppColor.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _SourceAmountField(
            value: split.amount,
            max: maxTake,
            color: color,
            onChanged: (v) =>
                cubit.updateOverflowSplit(split.category.id!, v),
          ),
        ],
      ),
    );
  }
}

class _IncomeSourceRow extends StatelessWidget {
  const _IncomeSourceRow();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddTransactionCubit>();
    final (income, covered, deficit) =
        context.select<AddTransactionCubit, (double, double, double)>(
      (c) => (
        c.state.overflowIncome,
        c.state.overflowCovered,
        c.state.overflowDeficit ?? 0,
      ),
    );
    final color = AppColor.incomeColor;
    final incomeMax = (deficit - (covered - income)).clamp(0.0, deficit);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: income > 0
              ? color.withValues(alpha: 0.4)
              : AppColor.dividerColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_card_rounded, color: color, size: 16.sp),
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
          _SourceAmountField(
            value: income,
            max: incomeMax,
            color: color,
            onChanged: cubit.updateOverflowIncome,
          ),
        ],
      ),
    );
  }
}

class _SourceAmountField extends StatefulWidget {
  final double value;
  final double max;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SourceAmountField({
    required this.value,
    required this.max,
    required this.color,
    required this.onChanged,
  });

  @override
  State<_SourceAmountField> createState() => _SourceAmountFieldState();
}

class _SourceAmountFieldState extends State<_SourceAmountField> {
  late final TextEditingController _controller;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.value));
    _focus.addListener(() {
      if (_focus.hasFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant _SourceAmountField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focus.hasFocus &&
        (double.tryParse(_controller.text) ?? 0.0) != widget.value) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  String _format(double v) => v <= 0
      ? ''
      : (v == v.roundToDouble()
          ? v.toStringAsFixed(0)
          : v.toStringAsFixed(2));

  void _onChanged(String text) {
    var value = double.tryParse(text) ?? 0.0;
    if (value < 0) value = 0;
    if (value > widget.max) {
      value = widget.max;
      final clamped = _format(value);
      _controller.value = TextEditingValue(
        text: clamped,
        selection: TextSelection(baseOffset: 0, extentOffset: clamped.length),
      );
    }
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74.w,
      child: TextField(
        controller: _controller,
        focusNode: _focus,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: AppTextStyle.number(
          size: 13.sp,
          weight: FontWeight.bold,
          color: widget.color,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColor.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: widget.color, width: 1.5),
          ),
        ),
        onChanged: _onChanged,
      ),
    );
  }
}

// ─── Confirm Row ──────────────────────────────────────────────────────────────

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow();

  @override
  Widget build(BuildContext context) {
    final (canConfirm, isLoading) =
        context.select<AddTransactionCubit, (bool, bool)>(
      (c) => (c.state.overflowFullyCovered, c.state.isLoading),
    );
    final cubit = context.read<AddTransactionCubit>();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: GestureDetector(
        onTap: canConfirm && !isLoading ? cubit.confirmOverflow : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50.h,
          decoration: BoxDecoration(
            color: canConfirm
                ? AppColor.primaryColor
                : AppColor.primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Confirm spend',
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
