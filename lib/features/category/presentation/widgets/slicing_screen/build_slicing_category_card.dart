import 'package:budget_buddy/core/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../core/themes/app_color.dart';
import '../../../../../core/constances.dart';
import '../../cubit/category_cubit.dart';
import 'insufficient_balance_dialog.dart';

class BuildSlicingCategoryCard extends StatelessWidget {
  final CategoryEntity categoryEntity;
  final TextEditingController controller;
  final int index;
  final int monthlySalary;
  final Map<int, int> previousValue;
  final Function(CategoryCubit, CategoryEntity, int) onUpdateCategory;

  const BuildSlicingCategoryCard({
    super.key,
    required this.categoryEntity,
    required this.controller,
    required this.index,
    required this.monthlySalary,
    required this.previousValue,
    required this.onUpdateCategory,
  });

  @override
  Widget build(BuildContext context) {
    CategoryCubit categoryCubit = CategoryCubit.get(context);
    final categoryColor = parseColorFromString(categoryEntity.categoryColor!);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: categoryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Select all text when the card is tapped
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
              // Show keyboard
              FocusScope.of(context).requestFocus(FocusNode());
            },
            splashColor: categoryColor.withOpacity(0.1),
            highlightColor: categoryColor.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  // Category icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      IconData(
                        int.parse(categoryEntity.categoryIcon!),
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Category name
                  Expanded(
                    child: Text(
                      categoryEntity.categoryName!,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),

                  // Amount input field
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: controller,
                      onTap: () {
                        controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: controller.text.length,
                        );
                      },
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 4),
                          child: Text(
                            '﷼',
                            style: GoogleFonts.poppins(
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0
                        ),
                        hintText: '0.00',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: categoryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: categoryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: categoryColor,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: categoryColor.withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      onChanged: (value) {
                        _handleValueChange(value, categoryCubit, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      int difference = previousValue[index] ?? 0;
      categoryCubit.updateRemainingBudgetForProgressBarInSettingUpstage(difference);
      previousValue[index] = 0;
      categoryCubit.mappedAllocatedCategoryAmount[index] = 0;
      onUpdateCategory(categoryCubit, categoryEntity, 0);
      return;
    }

    try {
      int newAllocation = int.parse(value);
      int previousAllocation = -(categoryCubit.mappedAllocatedCategoryAmount[index] ?? 0);
      int difference = previousAllocation - newAllocation;
      categoryCubit.updateCategoryAllocationAndTotalBudgetInSettingUpstage(index, difference);

      if (categoryCubit.remainingBudget + difference < 0) {
        categoryCubit.updateRemainingBudgetForProgressBarInSettingUpstage(difference);
        _showBudgetAlertDialog(context,categoryCubit);
      } else {
        categoryCubit.updateRemainingBudgetForProgressBarInSettingUpstage(difference);
        previousValue[index] = newAllocation;
        onUpdateCategory(categoryCubit, categoryEntity, newAllocation);
      }
    } catch (e) {
      debugPrint('Invalid number format in field $index');
      debugPrint(' ${e.toString()}');
    }
  }
  void _showBudgetAlertDialog(
      BuildContext context, CategoryCubit categoryCubit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
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
                // onValueChange: ('',,){},
                totalAllocatedBudgetBasedOnMap: categoryCubit.totalAllocatedBudgetBasedOnMap,
              ),
            ),
          ),
        );
      },
    );
  }
}