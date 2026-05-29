import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/widgets/pickers/picker_dialog_helpers.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/screens/explore_screen.dart';
import 'package:budget_buddy/modules/user_info/data/data_sources/cache_helper.dart';
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
        child: Row(
          children: [
            // + Add category
            InkWell(
              onTap: () {
                final cubit = BlocProvider.of<CategoryCubit>(context);
                _showAddCategoryDialog(categoryCubit: cubit, context: context);
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColor.primaryColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Confirm button
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final cubit = CategoryCubit.get(context);
                    if (cubit.state.remainingBudget > 0) {
                      _showBudgetAlertDialog(context, cubit);
                    } else {
                      await cubit
                          .initializeCategoriesStage(cubit.state.categories);
                      await CacheHelper.saveData(
                          key: 'setup_done', value: true);
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => ExploreScreen()),
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
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog({
    required CategoryCubit categoryCubit,
    required BuildContext context,
  }) async {
    await PickerDialogHelpers.showCategoryPickerDialog(
      pickerFunction: (newCategory) {
        categoryCubit.addNewSettingUpCategory(newCategory);
      },
      context: context,
      title: context.tr.addCategory,
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