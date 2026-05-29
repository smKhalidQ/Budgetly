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
      builder: (context, state) {
        final remaining = state.remainingBudget;
        final allocated = monthlySalary - remaining;
        final progress = (allocated / monthlySalary).clamp(0.0, 1.0);
        final isOver = remaining < 0;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: const BoxDecoration(
            color: AppColor.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$symbol$monthlySalary',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${t.remaining}: ',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        '$symbol${remaining.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isOver
                              ? AppColor.expenseColor
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOver ? AppColor.expenseColor : AppColor.accentColor,
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