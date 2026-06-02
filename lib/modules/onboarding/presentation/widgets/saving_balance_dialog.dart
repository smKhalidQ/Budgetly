import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/home/presentation/screens/home_screen.dart';
import 'package:budget_buddy/core/utilities/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SavingBalanceDialog extends StatelessWidget {
  const SavingBalanceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    final cubit = CategoryCubit.get(context);
    final remaining = cubit.state.remainingBudget;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColor.accentColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.savings_rounded,
                color: AppColor.accentColor,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              t.remainingBalance,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            // Subtitle
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppColor.textSecondary,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: '${t.youHaveRemainingOf} '),
                  TextSpan(
                    text: remaining.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColor.accentColor,
                    ),
                  ),
                  TextSpan(text: ' ${t.unallocated}'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: AppColor.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      t.adjustBudget,
                      style: GoogleFonts.cairo(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _addToSavings(cubit, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      t.addToSavings,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
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

  Future<void> _addToSavings(
      CategoryCubit cubit, BuildContext context) async {
    final index = cubit.state.categories
        .indexWhere((c) => c.name == 'Saving');
    if (index != -1 && cubit.state.remainingBudget > 0) {
      cubit.allocatedBudgetMap[index] =
          cubit.state.remainingBudget.round();
      final saving = cubit.state.categories[index];
      cubit.updateLocalCategory(
        saving.id!,
        saving.copyWith(
          allocatedAmount: cubit.state.remainingBudget.toDouble(),
        ),
      );
    }

    await cubit.initializeCategoriesStage(cubit.state.categories);
    await CacheHelper.saveData(key: 'setup_done', value: true);

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (_) => false,
      );
    }
  }
}
