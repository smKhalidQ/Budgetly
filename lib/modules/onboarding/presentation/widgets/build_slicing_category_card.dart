import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slice_pay/core/extensions/icon_extensions.dart';
import 'package:slice_pay/core/responsive/responsive_manager.dart';
import 'package:slice_pay/core/theming/app_color.dart';
import 'package:slice_pay/core/utilities/constants.dart';
import 'package:slice_pay/l10n/translation.dart';
import 'package:slice_pay/modules/category/domain/models/category.dart';
import 'package:slice_pay/modules/category/domain/models/category_localization.dart';
import 'package:slice_pay/modules/category/presentation/cubits/category_cubit.dart';
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
                category.icon.toIconData(),
                color: categoryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                category.localizedName(context.tr),
                style: GoogleFonts.cairo(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textPrimary,
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
                    color: AppColor.textTertiary,
                    fontSize: 15.sp,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(
                      color: AppColor.borderColor,
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
