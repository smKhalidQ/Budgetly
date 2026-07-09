import 'dart:math';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/services/month_cycle_service.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/presentation/screens/add_transaction_screen.dart';
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
      buildWhen: (prev, curr) => prev.selectedCurrency != curr.selectedCurrency,
      builder: (context, settingState) {
        final currency = settingState.selectedCurrency ?? currencies.keys.first;
        final symbol = currencies[currency]?['currencySymbol'] ?? '';

        return BlocBuilder<CategoryCubit, CategoryState>(
          buildWhen: (prev, curr) => prev.categories != curr.categories,
          builder: (context, catState) {
            final spendable = catState.categories
                .where((c) => c.name != MonthCycleService.savingName);
            final totalSpent =
                spendable.fold(0.0, (sum, c) => sum + c.spentAmount);
            final totalBudget =
                spendable.fold(0.0, (sum, c) => sum + c.allocatedAmount);
            final salary = catState.categories
                .fold(0.0, (sum, c) => sum + c.baseAllocation);
            final saving = catState.categories
                .where((c) => c.name == MonthCycleService.savingName)
                .fold(0.0, (sum, c) => sum + c.allocatedAmount);
            final remaining = totalBudget - totalSpent;
            final isOver = remaining < 0;
            final progress = totalBudget == 0
                ? 0.0
                : (totalSpent / totalBudget).clamp(0.0, 1.0);

            return Container(
              margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: AppColor.secondaryColor,
                    padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.budgetOverview,
                              style: GoogleFonts.cairo(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                _Chip(
                                  label: monthYear,
                                  background:
                                      Colors.white.withValues(alpha: 0.15),
                                  foreground:
                                      Colors.white.withValues(alpha: 0.9),
                                ),
                                SizedBox(width: 6.w),
                                GestureDetector(
                                  onTap: () => AddTransactionScreen.show(
                                    context,
                                    initialType: TransactionType.income,
                                    onSuccess: () => context
                                        .read<CategoryCubit>()
                                        .fetchCategories(),
                                  ),
                                  child: _Chip(
                                    label: 'Income',
                                    background: AppColor.accentColor,
                                    foreground: Colors.white,
                                    icon: Icons.add_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$symbol${remaining.abs().toStringAsFixed(0)}',
                                    style: AppTextStyle.number(
                                      size: 28.sp,
                                      weight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    isOver ? '⚠ ${t.remaining}' : t.remaining,
                                    style: GoogleFonts.cairo(
                                      color:
                                          Colors.white.withValues(alpha: 0.7),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 14.w),
                            _BudgetRing(
                              progress: progress,
                              isOver: isOver,
                              size: 52.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: AppColor.headerGradientEnd,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Row(
                      children: [
                        _StatItem(
                          label: t.spent,
                          value: '$symbol${totalSpent.toStringAsFixed(0)}',
                          dotColor: AppColor.expenseColor,
                        ),
                        _Divider(),
                        _StatItem(
                          label: 'Saving',
                          value: '$symbol${saving.toStringAsFixed(0)}',
                          dotColor: AppColor.incomeColor,
                        ),
                        _Divider(),
                        _StatItem(
                          label: 'Salary',
                          value: '$symbol${salary.toStringAsFixed(0)}',
                          dotColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  const _Chip({
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.sp, color: foreground),
            SizedBox(width: 2.w),
          ],
          Text(
            label,
            style: GoogleFonts.cairo(
              color: foreground,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      height: 28.h,
      color: Colors.white.withValues(alpha: 0.15),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              SizedBox(width: 4.w),
              Text(
                label,
                style: GoogleFonts.cairo(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyle.number(size: 14.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _BudgetRing extends StatelessWidget {
  final double progress;
  final bool isOver;
  final double size;

  const _BudgetRing({
    required this.progress,
    required this.isOver,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final ringColor = isOver ? AppColor.expenseColor : Colors.white;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress: progress, color: ringColor),
        child: Center(
          child: Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: AppTextStyle.number(
              size: 11.sp,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 5;
    const strokeWidth = 5.0;

    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
