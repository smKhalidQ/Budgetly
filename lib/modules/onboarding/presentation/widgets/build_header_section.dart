import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';

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
        final remainingColor =
            isOver ? AppColor.expenseColor : const Color(0xFF2E7D32);
        final remainingBg =
            isOver ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9);

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Text(
                t.distributeYourBudget,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: AppColor.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              // Amounts row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$symbol$monthlySalary',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                      height: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: remainingBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$symbol$remaining ${t.remaining}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: remainingColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColor.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOver ? AppColor.expenseColor : AppColor.accentColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Percentage label
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}% ${t.allocated}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColor.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
