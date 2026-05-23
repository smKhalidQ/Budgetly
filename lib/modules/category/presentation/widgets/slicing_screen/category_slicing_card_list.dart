import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';
import 'build_slicing_category_card.dart';

class CategorySlicingCardList extends StatelessWidget {
  CategorySlicingCardList({super.key, required this.monthlySalary});

  final Map<int, TextEditingController> controllers = {};
  final Map<int, int> _previousValues = {};
  final int monthlySalary;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
            ),
          );
        } else if (state.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? '',
                  style: GoogleFonts.roboto(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          final fetchedCategories = state.categories;
          if (fetchedCategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: AppColor.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No categories found.\nAdd categories using the + button below.",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: fetchedCategories.length,
            itemBuilder: (context, index) {
              if (!controllers.containsKey(index)) {
                controllers[index] = TextEditingController();
                _previousValues[index] = 0;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: BuildSlicingCategoryCard(
                  category: fetchedCategories[index],
                  controller: controllers[index]!,
                  index: index,
                  monthlySalary: monthlySalary,
                  previousValue: _previousValues,
                  onUpdateCategory: _updateCategory,
                ),
              );
            },
          );
        }
      },
    );
  }

  void _updateCategory(
      CategoryCubit categoryCubit, Category oldCategory, int newAmount) {
    categoryCubit.updateLocalCategory(
      oldCategory.id!,
      oldCategory.copyWith(allocatedAmount: newAmount.toDouble()),
    );
  }
}
