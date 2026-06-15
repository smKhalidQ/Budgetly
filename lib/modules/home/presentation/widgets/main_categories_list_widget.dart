import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';
import 'package:budget_buddy/modules/category/presentation/screens/category_detail_screen.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MainCategoriesListWidget extends StatelessWidget {
  const MainCategoriesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      buildWhen: (prev, curr) =>
          prev.selectedCurrency != curr.selectedCurrency,
      builder: (context, settingState) {
        final currency = settingState.selectedCurrency ?? currencies.keys.first;
        final symbol = currencies[currency]?['currencySymbol'] ?? '';

        return BlocBuilder<CategoryCubit, CategoryState>(
          buildWhen: (prev, curr) =>
              prev.categories != curr.categories ||
              prev.status != curr.status,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.hasError) {
              return Center(child: Text(state.errorMessage ?? ''));
            }

            final categories = state.categories;
            if (categories.isEmpty) {
              return Center(
                child: Text(
                  context.tr.noCategoriesFound,
                  style: GoogleFonts.cairo(color: AppColor.textSecondary),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
              child: Column(
                children: [
                  for (int index = 0; index < categories.length; index++) ...[
                    if (index > 0) SizedBox(height: 12.h),
                    Builder(builder: (context) {
                      final category = categories[index];
                      final color = parseColorFromString(category.color);
                      final progress = category.allocatedAmount == 0
                          ? 0.0
                          : (category.spentAmount / category.allocatedAmount)
                              .clamp(0.0, 1.0);
                      final remaining =
                          category.allocatedAmount - category.spentAmount;
                      return Material(
                        color: AppColor.cardBackground,
                        borderRadius: BorderRadius.circular(AppRadius.lg.r),
                        shadowColor: AppColor.backgroundCardShadow,
                        elevation: 3,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.lg.r),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryDetailScreen(category: category),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 5.w,
                                height: 76.h,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(AppRadius.lg.r),
                                    bottomLeft: Radius.circular(AppRadius.lg.r),
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Container(
                                width: 42.w,
                                height: 42.w,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  IconData(
                                    int.parse(category.icon),
                                    fontFamily: 'MaterialIcons',
                                  ),
                                  color: color,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8.h),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4.r),
                                        child: LinearProgressIndicator(
                                          value: progress,
                                          minHeight: 4.h,
                                          backgroundColor: AppColor.surfaceMuted,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                              color),
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          _AmountChip(
                                            label: context.tr.spent,
                                            value:
                                                '$symbol${category.spentAmount.toStringAsFixed(0)}',
                                            color: AppColor.textSecondary,
                                          ),
                                          Container(
                                            width: 1.w,
                                            height: 14.h,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8.w),
                                            color: AppColor.dividerColor,
                                          ),
                                          _AmountChip(
                                            label: context.tr.remaining,
                                            value:
                                                '$symbol${remaining.toStringAsFixed(0)}',
                                            color: remaining == 0
                                                ? AppColor.textSecondary
                                                : color,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColor.textSecondary.withValues(alpha: 0.4),
                                  size: 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: GoogleFonts.cairo(
              fontSize: 11.sp,
              color: AppColor.textSecondary,
            ),
          ),
          TextSpan(
            text: value,
            style: AppTextStyle.number(
              size: 11.sp,
              weight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
