import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/widgets/pickers/picker_dialog_helpers.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/screens/explore_screen.dart';
import 'saving_balance_dialog.dart';

class CustomSetUpBottomBar extends StatelessWidget {
  const CustomSetUpBottomBar({Key? key, required this.categoryCubit})
      : super(key: key);
  final CategoryCubit categoryCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final categoryCubit = CategoryCubit.get(context);

                  if (categoryCubit.state.remainingBudget > 0) {
                    _showBudgetAlertDialog(context, categoryCubit);
                  } else {
                    await categoryCubit
                        .initializeCategoriesStage(categoryCubit.state.categories);

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => ExploreScreen()),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 20),
                    const Gap(8),
                    Text(
                      "Confirm Budget",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Gap(12),
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  final categoryCubit = BlocProvider.of<CategoryCubit>(context);
                  _showAddCategoryDialog(
                    categoryCubit: categoryCubit,
                    context: context,
                  );
                },
                icon: const Icon(Icons.add),
                color: AppColor.primaryColor,
                iconSize: 24,
                padding: const EdgeInsets.all(12),
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
      title: "Add New Category",
    );
  }

  void _showBudgetAlertDialog(BuildContext context, CategoryCubit categoryCubit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Container(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
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
