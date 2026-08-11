import 'package:slice_pay/core/extensions/icon_extensions.dart';
import 'package:slice_pay/core/responsive/responsive_manager.dart';
import 'package:slice_pay/core/theming/app_color.dart';
import 'package:slice_pay/core/theming/app_radius.dart';
import 'package:slice_pay/core/theming/app_text_style.dart';
import 'package:slice_pay/core/utilities/constants.dart';
import 'package:slice_pay/l10n/app_localizations.dart';
import 'package:slice_pay/l10n/translation.dart';
import 'package:slice_pay/modules/category/domain/models/category_localization.dart';
import 'package:slice_pay/modules/category/presentation/cubits/category_cubit.dart';
import 'package:slice_pay/modules/category/presentation/cubits/category_state.dart';
import 'package:slice_pay/modules/category/presentation/screens/category_detail_screen.dart';
import 'package:slice_pay/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:slice_pay/modules/user_info/presentation/cubits/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

String _errorText(AppLocalizations t, CategoryError? error) {
  return switch (error) {
    CategoryError.loadFailed => t.failedToLoadCategories,
    CategoryError.initializeFailed => t.failedToInitializeCategories,
    null => '',
  };
}

class MainCategoriesListWidget extends StatelessWidget {
  const MainCategoriesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      buildWhen: (prev, curr) => prev.selectedCurrency != curr.selectedCurrency,
      builder: (context, settingState) {
        final currency = settingState.selectedCurrency ?? currencies.keys.first;
        final symbol = currencies[currency]?['currencySymbol'] ?? '';

        return BlocBuilder<CategoryCubit, CategoryState>(
          buildWhen: (prev, curr) =>
              prev.categories != curr.categories || prev.status != curr.status,
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.hasError) {
              return Center(child: Text(_errorText(context.tr, state.error)));
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
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.lg.r),
                        child: Material(
                          color: AppColor.cardBackground,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CategoryDetailScreen(category: category),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 38.w,
                                    height: 38.w,
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      category.icon.toIconData(),
                                      color: color,
                                      size: 18.sp,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                category.localizedName(context.tr),
                                                style: GoogleFonts.cairo(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColor.textPrimary,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '$symbol${remaining.toStringAsFixed(0)} ',
                                              style: AppTextStyle.number(
                                                size: 14.sp,
                                                weight: FontWeight.bold,
                                                color: remaining == 0
                                                    ? AppColor.textSecondary
                                                    : color,
                                              ),
                                            ),
                                            Text(
                                              context.tr.remaining,
                                              style: GoogleFonts.cairo(
                                                fontSize: 10.sp,
                                                color: AppColor.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.h),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4.r),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 4.h,
                                            backgroundColor:
                                                AppColor.surfaceMuted,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    color),
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          '${context.tr.spent}: $symbol${category.spentAmount.toStringAsFixed(0)}',
                                          style: GoogleFonts.cairo(
                                            fontSize: 10.sp,
                                            color: AppColor.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: color.withValues(alpha: 0.6),
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
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
