import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/services/month_cycle_service.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';
import 'package:budget_buddy/modules/settings/presentation/screens/settings_screen.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/presentation/screens/add_transaction_screen.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeHeaderSliver extends StatelessWidget {
  const HomeHeaderSliver({super.key});

  static const double maxExtent = 280;
  static const double minExtent = 64;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColor.headerGradientStart,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      expandedHeight: maxExtent.h,
      collapsedHeight: minExtent.h,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final shrinkRange = maxExtent.h - minExtent.h;
          final shrinkProgress = shrinkRange == 0
              ? 1.0
              : (1 - ((constraints.maxHeight - minExtent.h) / shrinkRange))
                  .clamp(0.0, 1.0);
          final titleOpacity = ((shrinkProgress - 0.85) / 0.15).clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            centerTitle: true,
            titlePadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            title: Opacity(
              opacity: titleOpacity,
              child: Text(
                'عَنْ مَالِهِ فِيمَا أَنْفَقَهُ',
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: AppColor.textWhite,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            background: const HomeHeaderWidget(),
          );
        },
      ),
    );
  }
}

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    final monthYear = DateFormat('MMMM yyyy').format(DateTime.now());

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
            final progress = totalBudget == 0
                ? 0.0
                : (totalSpent / totalBudget).clamp(0.0, 1.0);
            final statusColor = _statusColor(progress, remaining);

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColor.headerGradientStart,
                    AppColor.headerGradientEnd,
                  ],
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -60.h,
                    right: -30.w,
                    child: _DecorativeCircle(size: 160.w),
                  ),
                  Positioned(
                    top: 160.h,
                    left: -40.w,
                    child: _DecorativeCircle(size: 100.w),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 16.w, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.budgetOverview,
                              style: GoogleFonts.cairo(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const _SettingsButton(),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _BudgetRing(
                                progress: progress,
                                color: statusColor,
                                size: 64.w),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$symbol${remaining.abs().toStringAsFixed(0)}',
                                    style: AppTextStyle.number(
                                      size: 28.sp,
                                      color: statusColor,
                                      height: 1,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    remaining < 0
                                        ? '${t.remaining} · over budget'
                                        : t.remaining,
                                    style: GoogleFonts.cairo(
                                      color:
                                          Colors.white.withValues(alpha: 0.75),
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            _MonthChip(label: monthYear),
                            const Spacer(),
                            _AddIncomeButton(onSuccess: () =>
                                context.read<CategoryCubit>().fetchCategories()),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius:
                                BorderRadius.circular(AppRadius.lg.r),
                          ),
                          child: Row(
                            children: [
                              _StatItem(
                                label: t.spent,
                                value:
                                    '$symbol${totalSpent.toStringAsFixed(0)}',
                                dotColor: AppColor.expenseColor,
                              ),
                              Container(
                                width: 1,
                                height: 28.h,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              _StatItem(
                                label: 'Saving',
                                value: '$symbol${saving.toStringAsFixed(0)}',
                                dotColor: AppColor.incomeColor,
                              ),
                              Container(
                                width: 1,
                                height: 28.h,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color _statusColor(double progress, double remaining) {
    if (remaining < 0) return AppColor.expenseColor;
    if (progress >= 0.85) return AppColor.warningColor;
    return AppColor.incomeColor;
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Icon(
            Icons.settings_outlined,
            size: 18.sp,
            color: Colors.white.withValues(alpha: 0.95),
          ),
        ),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  final String label;

  const _MonthChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_rounded,
              size: 13.sp, color: Colors.white.withValues(alpha: 0.85)),
          SizedBox(width: 5.w),
          Text(
            label,
            style: GoogleFonts.cairo(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddIncomeButton extends StatelessWidget {
  final VoidCallback onSuccess;

  const _AddIncomeButton({required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.accentColor,
      borderRadius: BorderRadius.circular(AppRadius.pill.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill.r),
        onTap: () => AddTransactionScreen.show(
          context,
          initialType: TransactionType.income,
          onSuccess: onSuccess,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, size: 16.sp, color: Colors.white),
              SizedBox(width: 5.w),
              Text(
                'Add Income',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
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
                  color: Colors.white.withValues(alpha: 0.8),
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

class _DecorativeCircle extends StatelessWidget {
  final double size;

  const _DecorativeCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
      ),
    );
  }
}

class _BudgetRing extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;

  const _BudgetRing({
    required this.progress,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: AppTextStyle.number(size: 13.sp, color: color),
          ),
        ],
      ),
    );
  }
}
