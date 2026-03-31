import 'package:budget_buddy/core/data/models/category_model.dart';
import 'package:budget_buddy/core/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../cubit/category_cubit.dart';
import '../../screens/explore_screen.dart';


class SavingBalanceDialog extends StatelessWidget {
  const SavingBalanceDialog({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    CategoryCubit categoryCubit=CategoryCubit.get(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.savings_rounded,
                color: Colors.blue,
                size: 32,
              ),
            ),
            const Gap(16),
            Text(
              "Remaining Balance",
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Gap(8),
            Text(
              "You have remaining balance of",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Gap(8),
            Text(
              "\$${categoryCubit.remainingBudget.toStringAsFixed(2)}",
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Gap(24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'update_categories');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: Colors.blue.withOpacity(0.5),
                        ),
                      ),
                    ),
                    child: Text(
                      "Adjust Budget",
                      style: GoogleFonts.roboto(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 15, // تعديل حجم الخط
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async{
                      _manageSavingBudget(categoryCubit,context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Add to Savings",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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

  void _manageSavingBudget(CategoryCubit categoryCubit, context) async {
    int index = categoryCubit.fetchedCategoriesList
        .indexWhere((category) => category.categoryName == "Saving");

    categoryCubit.remainingBudget > 0
        ? categoryCubit.mappedAllocatedCategoryAmount[index] =
        categoryCubit.remainingBudget
        : null;

    CategoryEntity oldCategory=categoryCubit.fetchedCategoriesList[index];
    final updatedCategory = CategoryModel(
      categoryId: oldCategory.categoryId,
      categoryName: oldCategory.categoryName,
      categoryIcon: oldCategory.categoryIcon,
      categoryColor: oldCategory.categoryColor,
      allocatedAmount: categoryCubit.mappedAllocatedCategoryAmount[index]!.toDouble(),
      storedSpentAmount: oldCategory.storedSpentAmount,
    );
    categoryCubit.fetchedCategoriesList[index] = updatedCategory;


    await categoryCubit.initializeCategoriesStage(categoryCubit.fetchedCategoriesList);

    Navigator.push(
        context, MaterialPageRoute(builder: (ctx) =>  ExploreScreen()));
  }
}