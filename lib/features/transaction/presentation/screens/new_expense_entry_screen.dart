import 'dart:ui';
import 'package:budget_buddy/core/domain/entities/category_entity.dart';
import 'package:budget_buddy/core/domain/entities/subcategory-entity.dart';
import 'package:budget_buddy/features/subcategory/presentation/cubit/subcategory_cubit.dart';
import 'package:budget_buddy/features/subcategory/presentation/cubit/subcategory_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Widgets/pickers/picker_dialog_helpers.dart';
import '../../../../core/constances.dart';
import '../../../../core/themes/app_color.dart';
import '../../../category/presentation/screens/explore_screen.dart';
import '../../../category/presentation/widgets/selected_category_header.dart';
import '../../../subcategory/presentation/widgets/subcategories_list_widget.dart';
import '../cubit/transaction_cubit.dart';
import '../cubit/transaction_states.dart';


class NewExpenseEntryScreen extends StatelessWidget {
  final CategoryEntity categoryEntity;

  const NewExpenseEntryScreen({
    super.key,
    required this.categoryEntity,
  });

  @override
  Widget build(BuildContext context) {
    final subcategoryCubit = context.watch<SubcategoryCubit>();
    final Color categoryColor = parseColorFromString(categoryEntity.categoryColor ?? '#1E88E5');
    final double remainingAmount = categoryEntity.allocatedAmount! - categoryEntity.storedSpentAmount;

    return BlocProvider(
      create: (context) => TransactionCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExploreScreen()));
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white)
          ),
          title: Text(
            categoryEntity.categoryName!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          backgroundColor: AppColor.primaryColor,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SelectedCategoryHeaderWidget(
              categoryEntity: categoryEntity,
              categoryColor: categoryColor,
              remainingAmount: remainingAmount,
              showPieChart: subcategoryCubit.showPieChart,
              onTogglePieChart: () => subcategoryCubit.togglePieChart(),
              onEditCategory: () {
                // Edit category action
              },
            ),
            Expanded(
              child: SubcategoriesListWidget(
                parentCategoryId: categoryEntity.categoryId!,
                onSubcategoryTap: (SubcategoryEntity ) {  },

              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<SubcategoryCubit, SubcategoryStates>(
          builder: (context, state) {
            final subcategoryCubit = SubcategoryCubit.get(context);
            if (subcategoryCubit.isEditMode) {
              return FloatingActionButton(
                onPressed: () => _showAddSubcategoryDialog(
                  context,
                ),
                backgroundColor:AppColor.primaryColor,
                child: const Icon(Icons.add),
              );
            } else {
              return const SizedBox.shrink(); // بدل null
            }
          },
        ),

      )
    );
  }

  void _showEditSubcategoryDialog(TransactionCubit cubit, SubcategoryEntity subCat, int index, BuildContext context, Color categoryColor) async {
    // final result = await PickerDialogHelpers.showEditPickerDialog(
    //   pickerFunction: (){},
    //   context: context,
    //   title: "Edit Subcategory",
    //   initialName: subCat.name,
    //   initialColor: subCat.color,
    //   initialIcon: subCat.icon,
    //   accentColor: categoryColor,
    // );
    //
    // if (result != null) {
    //   // Here you would update the subcategory in your data model
    //   // cubit.updateSubcategory(index, resul t['name'], result['color'], result['icon']);
    // }
  }

  void _showAddSubcategoryDialog( BuildContext context) async {
    final result = await PickerDialogHelpers.showSubcategoryPickerDialog(
      context: context,
      title: "Add New Subcategory",
      parentCategoryId: categoryEntity.categoryId!,
      pickerFunction: (SubcategoryEntity newSubcategory){
        print("categoryEntity.categoryId is ${categoryEntity.categoryId!}");

        SubcategoryCubit.get(context).insertNewSubcategory( newSubcategory);


        print("Add New Subcategory");

      },
    );

    if (result != null) {
      // Here you would add the subcategory to your data model
      // cubit.addSubcategory(result['name'], result['color'], result['icon']);
    }
  }
}