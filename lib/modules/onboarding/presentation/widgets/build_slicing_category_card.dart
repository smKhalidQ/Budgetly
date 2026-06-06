import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'insufficient_balance_dialog.dart';

class BuildSlicingCategoryCard extends StatelessWidget {
  final Category category;
  final TextEditingController controller;
  final int index;
  final int monthlySalary;
  final String currency;
  final Map<int, int> previousValue;
  final Function(CategoryCubit, Category, int) onUpdateCategory;

  const BuildSlicingCategoryCard({
    super.key,
    required this.category,
    required this.controller,
    required this.index,
    required this.monthlySalary,
    required this.currency,
    required this.previousValue,
    required this.onUpdateCategory,
  });

  @override
  Widget build(BuildContext context) {
    final categoryCubit = CategoryCubit.get(context);
    final categoryColor = parseColorFromString(category.color);
    final currencySymbol = currencies[currency]?['currencySymbol'] ?? '';

    return InkWell(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconData(int.parse(category.icon), fontFamily: 'MaterialIcons'),
                color: categoryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                category.name,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF263238),
                ),
              ),
            ),
            SizedBox(
              width: 116,
              child: TextField(
                controller: controller,
                onTap: () => controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                ),
                textAlign: TextAlign.end,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: categoryColor,
                ),
                decoration: InputDecoration(
                  prefixText: '$currencySymbol ',
                  prefixStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: categoryColor.withValues(alpha: 0.7),
                  ),
                  hintText: '0',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 15,
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: categoryColor, width: 1.5),
                  ),
                  filled: true,
                  fillColor: categoryColor.withValues(alpha: 0.04),
                ),
                onChanged: (v) => _handleValueChange(v, categoryCubit, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleValueChange(
    String value,
    CategoryCubit categoryCubit,
    BuildContext context,
  ) {
    if (value.isEmpty) {
      // Read from map (not previousValue) to avoid stale values after dialog reset
      final currentAlloc = -(categoryCubit.allocatedBudgetMap[index] ?? 0);
      if (currentAlloc > 0) {
        categoryCubit.updateRemainingBudgetForProgressBarInSettingUpstage(currentAlloc);
        categoryCubit.allocatedBudgetMap[index] = 0;
        previousValue[index] = 0;
        onUpdateCategory(categoryCubit, category, 0);
      }
      return;
    }

    try {
      final newAllocation = int.parse(value);
      if (newAllocation < 0) return;

      final previousAllocation = -(categoryCubit.allocatedBudgetMap[index] ?? 0);
      final difference = previousAllocation - newAllocation;

      // Guard: check BEFORE touching state — remaining must never go negative
      if (categoryCubit.state.remainingBudget + difference < 0) {
        _showBudgetAlertDialog(context, categoryCubit);
        return;
      }

      // Valid — update state
      categoryCubit.updateCategoryAllocationAndTotalBudgetInSettingUpstage(index, difference);
      categoryCubit.updateRemainingBudgetForProgressBarInSettingUpstage(difference);
      previousValue[index] = newAllocation;
      onUpdateCategory(categoryCubit, category, newAllocation);
    } catch (e) {
      debugPrint('Invalid number in field $index: $e');
    }
  }

  void _showBudgetAlertDialog(
      BuildContext context, CategoryCubit categoryCubit) {
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
              value: categoryCubit,
              child: InsufficientBalanceDialog(
                categoryCubit: categoryCubit,
                index: index,
                monthlySalary: monthlySalary,
                controller: controller,
                totalAllocatedBudgetBasedOnMap:
                    categoryCubit.totalAllocatedBudgetBasedOnMap,
              ),
            ),
          ),
        );
      },
    );
  }
}