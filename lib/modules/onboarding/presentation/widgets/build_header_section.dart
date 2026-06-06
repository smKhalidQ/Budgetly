import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
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
          margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
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
              Text(
                t.distributeYourBudget,
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$symbol$monthlySalary',
                    style: GoogleFonts.poppins(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                      height: 1,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: remainingBg,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '$symbol$remaining ${t.remaining}',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
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
                  backgroundColor: AppColor.dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOver ? AppColor.expenseColor : AppColor.accentColor,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}% ${t.allocated}',
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
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
