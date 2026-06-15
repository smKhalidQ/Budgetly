import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';

/// Summary for the budget-slicing screen: salary, how much is still
/// unallocated, a progress bar, and a one-line hint telling the user the
/// screen's purpose — split the salary across the categories below.
class BuildHeaderSection extends StatelessWidget {
  const BuildHeaderSection({
    super.key,
    required this.monthlySalary,
    required this.currency,
  });

  final int monthlySalary;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    final symbol = currencies[currency]?['currencySymbol'] ?? '';

    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (prev, curr) => prev.remainingBudget != curr.remainingBudget,
      builder: (context, state) {
        final remaining = state.remainingBudget;
        final allocated = monthlySalary - remaining;
        final progress = (allocated / monthlySalary).clamp(0.0, 1.0);
        final isOver = remaining < 0;
        final isDone = remaining == 0 && monthlySalary > 0;
        final remainingColor =
            isOver ? AppColor.expenseColor : AppColor.incomeColor;

        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.monthlySalary,
                          style: GoogleFonts.cairo(
                            fontSize: 12.sp,
                            color: AppColor.textSecondary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$symbol$monthlySalary',
                          style: AppTextStyle.number(
                            size: 28.sp,
                            weight: FontWeight.bold,
                            color: AppColor.primaryColor,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: remainingColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '$symbol$remaining ${t.remaining}',
                      style: AppTextStyle.number(
                        size: 12.sp,
                        weight: FontWeight.w600,
                        color: remainingColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
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
                  '${(progress * 100).toStringAsFixed(0)}% ${t.allocated}',
                  style: GoogleFonts.cairo(
                    fontSize: 11.sp,
                    color: AppColor.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              _Hint(
                done: isDone,
                text: isDone
                    ? 'Every $symbol has a job — you\'re ready to go.'
                    : 'Split your $symbol$monthlySalary across the categories below.',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Hint extends StatelessWidget {
  final bool done;
  final String text;

  const _Hint({required this.done, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColor.incomeColor : AppColor.primaryColor;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.lightbulb_outline_rounded,
            size: 16.sp,
            color: color,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
