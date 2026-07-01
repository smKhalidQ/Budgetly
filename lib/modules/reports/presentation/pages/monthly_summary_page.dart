import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_state.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MonthlySummaryPage extends StatelessWidget {
  const MonthlySummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.select<SettingCubit, String>((c) {
      final key = c.state.selectedCurrency ?? currencies.keys.first;
      return currencies[key]?['currencySymbol'] ?? '';
    });

    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (prev, curr) =>
          prev.transactions != curr.transactions ||
          prev.categoriesById != curr.categoriesById,
      builder: (context, state) {
        if (state.transactions.isEmpty) {
          return _EmptyState();
        }

        final monthlySummaries = _buildMonthlySummaries(state);

        return ListView.separated(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
          itemCount: monthlySummaries.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (_, i) => _MonthCard(
            summary: monthlySummaries[i],
            currencySymbol: currencySymbol,
          ),
        );
      },
    );
  }

  List<_MonthlySummary> _buildMonthlySummaries(TransactionState state) {
    final map = <String, _MonthlySummaryBuilder>{};

    for (final t in state.transactions) {
      if (t.type == TransactionType.rollover) continue;
      final key = '${t.date.year}-${t.date.month.toString().padLeft(2, '0')}';
      map.putIfAbsent(
        key,
        () => _MonthlySummaryBuilder(
          year: t.date.year,
          month: t.date.month,
        ),
      );
      if (t.type == TransactionType.expense) {
        map[key]!.expense += t.amount;
        map[key]!.txCount++;
      } else if (t.type == TransactionType.income) {
        map[key]!.income += t.amount;
      }
    }

    return map.values
        .map((b) => _MonthlySummary(
              year: b.year,
              month: b.month,
              expense: b.expense,
              income: b.income,
              txCount: b.txCount,
            ))
        .toList()
      ..sort((a, b) {
        final cmp = b.year.compareTo(a.year);
        return cmp != 0 ? cmp : b.month.compareTo(a.month);
      });
  }
}

// ─── Data classes ─────────────────────────────────────────────────────────────

class _MonthlySummaryBuilder {
  final int year;
  final int month;
  double expense = 0;
  double income = 0;
  int txCount = 0;

  _MonthlySummaryBuilder({required this.year, required this.month});
}

class _MonthlySummary {
  final int year;
  final int month;
  final double expense;
  final double income;
  final int txCount;

  const _MonthlySummary({
    required this.year,
    required this.month,
    required this.expense,
    required this.income,
    required this.txCount,
  });

  double get saved => income - expense;
  bool get isCurrentMonth {
    final now = DateTime.now();
    return now.year == year && now.month == month;
  }
}

// ─── Month Card ───────────────────────────────────────────────────────────────

class _MonthCard extends StatelessWidget {
  final _MonthlySummary summary;
  final String currencySymbol;

  const _MonthCard({required this.summary, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM yyyy')
        .format(DateTime(summary.year, summary.month));
    final saved = summary.saved;
    final savedColor =
        saved >= 0 ? AppColor.incomeColor : AppColor.expenseColor;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        border: summary.isCurrentMonth
            ? Border.all(
                color: AppColor.accentColor.withValues(alpha: 0.4), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColor.backgroundCardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  monthLabel,
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
              if (summary.isCurrentMonth)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColor.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Current',
                    style: GoogleFonts.cairo(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.accentColor,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            '${summary.txCount} transactions',
            style: GoogleFonts.cairo(
                fontSize: 11.sp, color: AppColor.textSecondary),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Expenses',
                  value: '$currencySymbol${summary.expense.toStringAsFixed(0)}',
                  color: AppColor.expenseColor,
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatItem(
                  label: 'Income',
                  value: '$currencySymbol${summary.income.toStringAsFixed(0)}',
                  color: AppColor.incomeColor,
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _StatItem(
                  label: saved >= 0 ? 'Saved' : 'Deficit',
                  value:
                      '$currencySymbol${saved.abs().toStringAsFixed(0)}',
                  color: savedColor,
                  icon: saved >= 0
                      ? Icons.savings_rounded
                      : Icons.warning_amber_rounded,
                ),
              ),
            ],
          ),
          if (summary.expense > 0) ...[
            SizedBox(height: 14.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: summary.income > 0
                    ? (summary.expense / summary.income).clamp(0.0, 1.0)
                    : 1.0,
                minHeight: 5.h,
                backgroundColor: AppColor.surfaceMuted,
                valueColor: AlwaysStoppedAnimation<Color>(
                  summary.expense > summary.income
                      ? AppColor.expenseColor
                      : AppColor.accentColor,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              summary.income > 0
                  ? '${((summary.expense / summary.income) * 100).toStringAsFixed(0)}% of income spent'
                  : 'No income recorded',
              style: GoogleFonts.cairo(
                  fontSize: 10.sp, color: AppColor.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyle.number(
                size: 13.sp, weight: FontWeight.bold, color: color),
          ),
          Text(label,
              style: GoogleFonts.cairo(
                  fontSize: 10.sp, color: AppColor.textSecondary)),
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_rounded,
              size: 72.sp,
              color: AppColor.primaryColor.withValues(alpha: 0.15)),
          SizedBox(height: 16.h),
          Text(
            'No monthly data yet',
            style: GoogleFonts.cairo(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textSecondary),
          ),
        ],
      ),
    );
  }
}
