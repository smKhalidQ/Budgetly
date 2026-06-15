import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_state.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionsTabWidget extends StatelessWidget {
  const TransactionsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      buildWhen: (prev, curr) =>
          prev.transactions != curr.transactions ||
          prev.categoriesById != curr.categoriesById ||
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
                    currencySymbol: currencySymbol,
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

class _TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final Category? category;
  final String currencySymbol;

  const _TransactionRow({
    required this.transaction,
    required this.category,
    required this.currencySymbol,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final color =
        category != null ? parseColorFromString(category!.color) : AppColor.categoryOthers;
    final amountColor = isIncome ? AppColor.incomeColor : AppColor.expenseColor;
    final sign = isIncome ? '+' : '-';

    final title = category?.name ?? 'Unknown';
    final subtitle = transaction.note;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
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
              category != null
                  ? IconData(int.parse(category!.icon), fontFamily: 'MaterialIcons')
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
            '$sign$currencySymbol${transaction.amount.toStringAsFixed(2)}',
            style: AppTextStyle.number(
              size: 14.sp,
              weight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
