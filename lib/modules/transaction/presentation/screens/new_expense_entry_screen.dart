import 'dart:ui';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/widgets/pickers/picker_dialog_helpers.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/screens/explore_screen.dart';
import 'package:budget_buddy/modules/category/presentation/widgets/selected_category_header.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';
import 'package:budget_buddy/modules/subcategory/presentation/widgets/subcategories_list_widget.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class NewExpenseEntryScreen extends StatelessWidget {
  final Category category;

  const NewExpenseEntryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final subcategoryCubit = context.watch<SubcategoryCubit>();
    final Color categoryColor = parseColorFromString(category.color);
    final double remainingAmount = category.allocatedAmount - category.spentAmount;

    return BlocProvider(
      create: (_) => GetIt.I<TransactionCubit>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExploreScreen()),
            ),
            icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          ),
          title: Text(
            category.name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SelectedCategoryHeaderWidget(
              category: category,
              categoryColor: categoryColor,
              remainingAmount: remainingAmount,
              showPieChart: subcategoryCubit.state.showPieChart,
              onTogglePieChart: () => subcategoryCubit.togglePieChart(),
              onEditCategory: () {},
            ),
            Expanded(
              child: SubcategoriesListWidget(
                parentCategoryId: category.id!,
                onSubcategoryTap: (Subcategory subcategory) {},
              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<SubcategoryCubit, SubcategoryState>(
          builder: (context, state) {
            if (state.isEditMode) {
              return FloatingActionButton(
                onPressed: () => _showAddSubcategoryDialog(context),
                backgroundColor: AppColor.primaryColor,
                child: const Icon(Icons.add),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showAddSubcategoryDialog(BuildContext context) async {
    await PickerDialogHelpers.showSubcategoryPickerDialog(
      context: context,
      title: "Add New Subcategory",
      parentCategoryId: category.id!,
      pickerFunction: (Subcategory newSubcategory) {
        SubcategoryCubit.get(context).insertNewSubcategory(newSubcategory);
      },
    );
  }
}
