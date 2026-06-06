import 'package:budget_buddy/core/theming/app_color.dart';
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
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Column(
                children: [
                  for (int index = 0; index < categories.length; index++) ...[
                    if (index > 0) const SizedBox(height: 12),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  shadowColor: Colors.black.withValues(alpha: 0.05),
                  elevation: 3,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CategoryDetailScreen(category: category),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Color bar
                        Container(
                          width: 5,
                          height: 76,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Icon
                        Container(
                          width: 42,
                          height: 42,
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
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Info
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Text(
                                  category.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Progress bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 4,
                                    backgroundColor:
                                        Colors.grey.withValues(alpha: 0.12),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        color),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Spent | Remaining
                                Row(
                                  children: [
                                    _AmountChip(
                                      label: context.tr.spent,
                                      value:
                                          '$symbol${category.spentAmount.toStringAsFixed(0)}',
                                      color: AppColor.textSecondary,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 14,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      color: Colors.grey
                                          .withValues(alpha: 0.2),
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
                        // Tap indicator
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: AppColor.textSecondary.withValues(alpha: 0.4),
                            size: 20,
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
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColor.textSecondary,
            ),
          ),
          TextSpan(
            text: value,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
