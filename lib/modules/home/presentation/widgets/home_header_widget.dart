import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    final now = DateTime.now();
    final monthYear = DateFormat('MMMM yyyy').format(now);

    return BlocBuilder<SettingCubit, SettingState>(
      buildWhen: (prev, curr) =>
          prev.monthlySalary != curr.monthlySalary ||
          prev.selectedCurrency != curr.selectedCurrency,
      builder: (context, settingState) {
        final salary = settingState.monthlySalary;
        final currency =
            settingState.selectedCurrency ?? currencies.keys.first;
        final symbol = currencies[currency]?['currencySymbol'] ?? '';

        return BlocBuilder<CategoryCubit, CategoryState>(
          buildWhen: (prev, curr) => prev.categories != curr.categories,
          builder: (context, catState) {
            final totalSpent = catState.categories.fold(
              0.0,
              (sum, c) => sum + c.spentAmount,
            );
            final remaining = (salary - totalSpent).toDouble();
            final isOver = remaining < 0;
            final progress = salary == 0
                ? 0.0
                : (totalSpent / salary).clamp(0.0, 1.0);

            return Container(
              margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A5F), Color(0xFF0D2137)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A5F).withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 140.w,
                        height: 140.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: -60,
                      child: Container(
                        width: 180.w,
                        height: 180.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.03),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -40,
                      child: Container(
                        width: 120.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                t.budgetOverview,
                                style: GoogleFonts.cairo(
                                  color: Colors.white.withValues(alpha: 0.55),
                                  fontSize: 11.sp,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  monthYear,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '$symbol${remaining.abs().toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              height: 1,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            isOver ? '⚠ ${t.remaining}' : t.remaining,
                            style: GoogleFonts.cairo(
                              color: isOver
                                  ? AppColor.expenseColor
                                  : Colors.white.withValues(alpha: 0.5),
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 5.h,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.12),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isOver
                                    ? AppColor.expenseColor
                                    : AppColor.accentColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              _CardStat(
                                label: t.spent,
                                value:
                                    '$symbol${totalSpent.toStringAsFixed(0)}',
                                color: AppColor.expenseColor,
                              ),
                              Container(
                                width: 1.w,
                                height: 28.h,
                                color: Colors.white.withValues(alpha: 0.15),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16.w),
                              ),
                              _CardStat(
                                label: t.totalBudget,
                                value: '$symbol$salary',
                                color: Colors.white,
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: isOver
                                      ? AppColor.expenseColor
                                          .withValues(alpha: 0.2)
                                      : AppColor.accentColor
                                          .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  '${(progress * 100).toStringAsFixed(0)}%',
                                  style: GoogleFonts.poppins(
                                    color: isOver
                                        ? AppColor.expenseColor
                                        : AppColor.accentColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _CardStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _CardStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
