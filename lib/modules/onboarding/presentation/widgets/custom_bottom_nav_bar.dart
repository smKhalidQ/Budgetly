import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/home/presentation/screens/home_screen.dart';
import 'package:budget_buddy/core/utilities/cache_helper.dart';
import 'saving_balance_dialog.dart';

class CustomSetUpBottomBar extends StatelessWidget {
  const CustomSetUpBottomBar({super.key, required this.categoryCubit});

  final CategoryCubit categoryCubit;

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final cubit = CategoryCubit.get(context);
                  if (cubit.state.remainingBudget > 0) {
                    _showBudgetAlertDialog(context, cubit);
                  } else {
                    await cubit
                        .initializeCategoriesStage(cubit.state.categories);
                    await CacheHelper.saveData(key: 'setup_done', value: true);
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                        (_) => false,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.check_rounded, size: 18),
                label: Text(
                  t.confirmBudget,
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.editCategoriesLater,
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: AppColor.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showBudgetAlertDialog(
      BuildContext context, CategoryCubit categoryCubit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
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
              child: const SavingBalanceDialog(),
            ),
          ),
        );
      },
    );
  }
}
