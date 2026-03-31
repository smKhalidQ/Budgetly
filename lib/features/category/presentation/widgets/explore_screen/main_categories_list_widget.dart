import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constances.dart';
import '../../../../../core/domain/entities/category_entity.dart';
import '../../../../../core/themes/app_color.dart' show AppColor;

import '../../../../subcategory/presentation/cubit/subcategory_states.dart';
import '../../../../subcategory/presentation/widgets/subcategories_list_widget.dart';
import '../../../../transaction/presentation/screens/new_expense_entry_screen.dart';

import '../../cubit/category_cubit.dart';
import '../../cubit/category_states.dart';


class MainCategoriesListWidget extends StatelessWidget {
  const MainCategoriesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryStates>(
      builder: (context, state) {
        if (state is GetCategoryDataSuccessState || state is ChangeCategoryAppearanceState) {
          final categoryCubit = CategoryCubit.get(context);
          final categories = categoryCubit.fetchedCategoriesList;
          return ListView.separated(

            padding: const EdgeInsets.only(top: 15),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final categoryEntity = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        print("The Id of categoryEntity is ${categoryEntity.categoryId}");
                        return NewExpenseEntryScreen(
                          categoryEntity: categoryEntity,
                        );
                      }
                    ),
                  );
                },
                child: _categoryListItem(categoryEntity, categoryCubit, context),
              );
            },
          );

        } else if (state is GetCategoryDataErrorState) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Center(child: Text("Loading..."));
        }
      },
    );
  }

  Widget _categoryListItem(CategoryEntity categoryEntity, CategoryCubit categoryCubit, context) {
    final double progressValue = categoryEntity.allocatedAmount == 0
        ? 0
        : categoryEntity.storedSpentAmount / categoryEntity.allocatedAmount!;
    final Color categoryColor = parseColorFromString(categoryEntity.categoryColor!);
    final int percentage = (progressValue * 100).round();
    final double remainingAmount = categoryEntity.allocatedAmount! - categoryEntity.storedSpentAmount;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side color accent
          Container(
            width: 12,
            decoration: BoxDecoration(
              color: categoryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Category icon with plus sign to indicate adding transaction
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: categoryColor,
              shape: BoxShape.circle,
            ),
            child:Icon(
              IconData(
                int.parse(categoryEntity.categoryIcon!),
                fontFamily: 'MaterialIcons',
              ),
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Main content area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Category name with remaining amount instead of percentage
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        categoryEntity.categoryName!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: remainingAmount < 0 ? Colors.red.withOpacity(0.15) : categoryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "\$${remainingAmount.toStringAsFixed(0)} left",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: remainingAmount < 0 ? Colors.red : categoryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress bar
                Stack(
                  children: [
                    // Background progress bar
                    Container(
                      height: 6,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Active progress bar
                    Container(
                      height: 6,
                      width: MediaQuery.of(context).size.width * 0.5 * progressValue, // Adjust width based on screen size
                      decoration: BoxDecoration(
                        color: progressValue >= 1 ? Colors.red : categoryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Glass-like container for financial details and indicator icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Spent/Total amount
                          Text(
                            "\$${categoryEntity.storedSpentAmount.toStringAsFixed(0)}/\$${categoryEntity.allocatedAmount!.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColor.textPrimary.withOpacity(0.8),
                            ),
                          ),
                          // Clickable indicator icon
                          Row(
                            children: [
                              // Text(
                              //   "${percentage}%",
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: progressValue >= 1 ? Colors.red : categoryColor,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              // ),/
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    // BoxShadow(
                                    //   color: categoryColor.withOpacity(0.2),
                                    //   blurRadius: 4,
                                    //   spreadRadius: 1,
                                    // ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.monetization_on_outlined,
                                  size: 14,
                                  color: categoryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}