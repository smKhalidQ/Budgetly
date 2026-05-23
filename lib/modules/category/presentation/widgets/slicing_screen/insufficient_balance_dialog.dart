import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';

class InsufficientBalanceDialog extends StatelessWidget {
  final int monthlySalary;
  final int totalAllocatedBudgetBasedOnMap;
  final CategoryCubit categoryCubit;
  final TextEditingController controller;
  final int index;

  const InsufficientBalanceDialog({
    Key? key,
    required this.monthlySalary,
    required this.totalAllocatedBudgetBasedOnMap,
    required this.controller,
    required this.categoryCubit,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColor.backgroundColor,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 32,
              ),
            ),
            const Gap(16),
            Text(
              "Insufficient Balance",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            const Gap(8),
            Text(
              "Your remaining balance is",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: AppColor.textPrimary,
                fontSize: 16,
              ),
            ),
            const Gap(8),
            Text(
              "\$${(monthlySalary + totalAllocatedBudgetBasedOnMap).toString()}",
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Gap(24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      controller.clear();
                      categoryCubit.allocatedBudgetMap[index] = 0;
                      categoryCubit.setRemainingBudget(
                          monthlySalary + totalAllocatedBudgetBasedOnMap);
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColor.primaryColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                    child: Text(
                      "Adjust Categories",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final theOnChangedNewSetValue =
                          monthlySalary + totalAllocatedBudgetBasedOnMap;
                      theOnChangedNewSetValue == 0
                          ? controller.clear()
                          : controller.text = theOnChangedNewSetValue.toString();
                      categoryCubit.allocatedBudgetMap[index] =
                          -theOnChangedNewSetValue;
                      categoryCubit.setRemainingBudget(0);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Set \$${(monthlySalary + totalAllocatedBudgetBasedOnMap).toString()}",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
