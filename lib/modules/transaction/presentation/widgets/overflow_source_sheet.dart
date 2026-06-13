import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
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
            child: _SplitList(currencySymbol: currencySymbol),
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
    final (deficit, covered, isFull) =
        context.select<AddTransactionCubit, (double, double, bool)>(
      (c) => (
        c.state.overflowDeficit ?? 0,
        c.state.overflowCovered,
        c.state.overflowFullyCovered,
      ),
    );

    final progress = deficit > 0 ? (covered / deficit).clamp(0.0, 1.0) : 0.0;
    final meterColor = isFull ? AppColor.incomeColor : AppColor.accentColor;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isFull
                ? AppColor.incomeColor.withValues(alpha: 0.4)
                : AppColor.dividerColor,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Covered',
                  style: GoogleFonts.cairo(
                    fontSize: 12.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
                Text(
                  '$currencySymbol${covered.toStringAsFixed(2)} / $currencySymbol${deficit.toStringAsFixed(2)}',
                  style: GoogleFonts.cairo(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: meterColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6.h,
                backgroundColor: Colors.grey.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(meterColor),
              ),
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
    final (splits, deficit) =
        context.select<AddTransactionCubit, (List<OverflowSplit>, double)>(
      (c) => (c.state.overflowSplits, c.state.overflowDeficit ?? 0),
    );

    if (splits.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Center(
          child: Text(
            'No other categories have available budget.',
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: AppColor.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final split in splits)
          _SplitRow(
            split: split,
            currencySymbol: currencySymbol,
            remainingDeficit: deficit,
          ),
        SizedBox(height: 8.h),
      ],
    );
  }
}

// ─── Split Row ────────────────────────────────────────────────────────────────

class _SplitRow extends StatelessWidget {
  final OverflowSplit split;
  final String currencySymbol;
  final double remainingDeficit;

  const _SplitRow({
    required this.split,
    required this.currencySymbol,
    required this.remainingDeficit,
  });

  @override
  Widget build(BuildContext context) {
    final color = parseColorFromString(split.category.color);
    final cubit = context.read<AddTransactionCubit>();
    final covered = context.select<AddTransactionCubit, double>(
      (c) => c.state.overflowCovered,
    );
    final uncovered = (remainingDeficit - covered).clamp(0.0, split.available);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: split.amount > 0
              ? color.withValues(alpha: 0.4)
              : AppColor.dividerColor,
        ),
      ),
      child: Column(
        children: [
          Row(
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
                      'Available: $currencySymbol${split.available.toStringAsFixed(2)}',
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Quick-fill button
              if (split.amount == 0)
                GestureDetector(
                  onTap: () => cubit.updateOverflowSplit(
                    split.category.id!,
                    uncovered.clamp(0.0, split.available),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: color.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'Use',
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (split.amount > 0) ...[
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StepButton(
                  icon: Icons.remove_rounded,
                  color: color,
                  onTap: () => cubit.updateOverflowSplit(
                    split.category.id!,
                    split.amount - 1,
                  ),
                ),
                Text(
                  '$currencySymbol${split.amount.toStringAsFixed(2)}',
                  style: GoogleFonts.cairo(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                _StepButton(
                  icon: Icons.add_rounded,
                  color: color,
                  onTap: () => cubit.updateOverflowSplit(
                    split.category.id!,
                    split.amount + 1,
                  ),
                ),
              ],
            ),
            // The "price": what this draw costs the source envelope.
            if (split.budgetFraction > 0) ...[
              SizedBox(height: 6.h),
              Text(
                '≈ ${(split.budgetFraction * 100).round()}% of ${split.category.name}\'s budget',
                style: GoogleFonts.cairo(
                  fontSize: 11.sp,
                  color: color.withValues(alpha: 0.9),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp, color: color),
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
