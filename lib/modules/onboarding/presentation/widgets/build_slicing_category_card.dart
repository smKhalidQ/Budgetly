import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'insufficient_balance_dialog.dart';

class SlicingCategoryCard extends StatelessWidget {
  final Category category;
  final TextEditingController controller;
  final int index;
  final int monthlySalary;
  final String currency;

  const SlicingCategoryCard({
    super.key,
    required this.category,
    required this.controller,
    required this.index,
    required this.monthlySalary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = parseColorFromString(category.color);
    final currencySymbol = currencies[currency]?['currencySymbol'] ?? '';

    return InkWell(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconData(int.parse(category.icon), fontFamily: 'MaterialIcons'),
                color: categoryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                category.name,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF263238),
                ),
              ),
            ),
            SizedBox(
              width: 116.w,
              child: TextField(
                controller: controller,
                onTap: () => controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                ),
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: categoryColor,
                ),
                decoration: InputDecoration(
                  prefixText: '$currencySymbol ',
                  prefixStyle: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: categoryColor.withValues(alpha: 0.7),
                  ),
                  hintText: '0',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 15.sp,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: categoryColor, width: 1.5),
                  ),
                  filled: true,
                  fillColor: categoryColor.withValues(alpha: 0.04),
                ),
                onChanged: (v) => _handleValueChange(v, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleValueChange(String value, BuildContext context) {
    final cubit = context.read<CategoryCubit>();

    if (value.isEmpty) {
      cubit.clearAllocation(index);
      return;
    }

    try {
      final newAllocation = int.parse(value);
      if (newAllocation < 0) return;

      final success = cubit.updateAllocation(index, newAllocation, category);
      if (!success) _showInsufficientBudgetDialog(context, cubit);
    } catch (_) {}
  }

  void _showInsufficientBudgetDialog(BuildContext context, CategoryCubit cubit) {
    final currentAllocation = cubit.state.allocations[index] ?? 0;
    final maxAvailable = cubit.state.remainingBudget + currentAllocation;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => Container(),
      transitionBuilder: (context, animation, _, __) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: animation,
            child: BlocProvider.value(
              value: cubit,
              child: InsufficientBalanceDialog(
                index: index,
                maxAvailable: maxAvailable,
                controller: controller,
              ),
            ),
          ),
        );
      },
    );
  }
}
