import 'package:budget_buddy/core/domain/entities/category_entity.dart';
import 'package:budget_buddy/core/data/models/category_model.dart';
import 'package:budget_buddy/core/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/category/presentation/cubit/category_cubit.dart';
import '../../../features/category/presentation/cubit/category_states.dart';
import '../../../features/subcategory/presentation/cubit/subcategory_cubit.dart';
import '../../../features/subcategory/presentation/cubit/subcategory_states.dart';
import '../../data/models/subcategory_model.dart';
import '../../domain/entities/subcategory-entity.dart';
import 'color_picker_widget.dart';
import 'icon_picker_widget.dart';

class PickerDialogHelpers {

  static Future<Map<String, dynamic>?> showCategoryPickerDialog({
    required BuildContext context,
    required String title,
    required Function (CategoryEntity) pickerFunction,
  }) async {

    TextEditingController nameController = TextEditingController();
    final PageController pageController = PageController();
    final categoryCubit = CategoryCubit.get(context);
    bool hasValidationError = false;
    String validationErrorMessage = '';
    int currentPage = 0;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: categoryCubit,
          child: StatefulBuilder(
              builder: (context, setState) {
                return BlocBuilder<CategoryCubit, CategoryStates>(
                  builder: (context, state) {
                    return _buildDialogContent(
                      context: context,
                      title: title,
                      nameController: nameController,
                      hasValidationError: hasValidationError,
                      validationErrorMessage: validationErrorMessage,
                      pageController: pageController,
                      currentPage: currentPage,
                      isCategory: true,
                      categoryCubit: categoryCubit,
                      onIconSelected: (icon) {
                        String updatedCategoryIcon = icon.codePoint.toString();
                        categoryCubit.updateCategoryIcon(updatedCategoryIcon);
                      },

                      onColorSelected: (color) {
                        categoryCubit.updateCategoryColor(color);
                      },

                      onSavePressed: () {
                        if (nameController.text.isEmpty) {
                          setState(() {
                            hasValidationError = true;
                            validationErrorMessage = 'Name is required';
                          });
                          return;
                        }
                        int listLength=categoryCubit.fetchedCategoriesList.length;

                        CategoryEntity newCategory = CategoryModel(
                          categoryId:listLength ,
                          categoryName: nameController.text,
                          allocatedAmount: 0.0,
                          storedSpentAmount: 0.0,
                          categoryColor: categoryCubit.categoryColor.value.toRadixString(16),
                          categoryIcon: categoryCubit.categoryIcon,
                        );
                        print("The Category  ID When It is added by settingUp screen is ${newCategory.categoryId} ");

                        pickerFunction(newCategory);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }
          ),
        );
      },
    );

    return result;
  }




/// Show dialog to edit color and icon for subcategories
static Future<Map<String, dynamic>?> showSubcategoryPickerDialog({
  required BuildContext context,
  required String title,
  required int parentCategoryId,
  required Function( SubcategoryEntity newSubcategory) pickerFunction,
}) async {

  final TextEditingController nameController = TextEditingController();
  final PageController pageController = PageController();
  SubcategoryCubit subcategoryCubit = SubcategoryCubit.get(context);
  int currentPage = 0;

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (BuildContext context) {
      return BlocBuilder<SubcategoryCubit, SubcategoryStates>(
        builder: (context, state) {
          return _buildDialogContent(

            context: context,
            title: title,
            nameController: nameController,
            pageController: pageController,
            currentPage: currentPage,
            isCategory: false,
            subcategoryCubit: subcategoryCubit,
            onIconSelected: (icon) {
              subcategoryCubit.subcategoryIcon = icon.codePoint.toString();
              subcategoryCubit.emit(ChangeSubcategoryAppearanceState(items: subcategoryCubit.fetchedSubcategories));
            },
            onColorSelected: (color) {
              subcategoryCubit.updateSubcategoryColor(color);
            },
            onSavePressed: () {
              if (nameController.text.trim().isNotEmpty) {
                // IconData selectedIcon = IconData(
                //     int.tryParse(subcategoryCubit.subcategoryIcon) ?? 0xe000,
                //     fontFamily: 'MaterialIcons'
                // );

                // إنشاء كائن فئة فرعية جديدة
                SubcategoryEntity newSubcategory = SubcategoryModel(
                  subcategoryName: nameController.text,
                  subcategoryColor:subcategoryCubit.subcategoryColor.value.toRadixString(16),
                  subcategoryIcon:  subcategoryCubit.subcategoryIcon,
                  parentCategoryId: parentCategoryId,
                );

                pickerFunction(newSubcategory);

                Navigator.pop(context);
              }
            },
          );
        },
      );
    },
  );

  return result;
}


  static Widget _buildDialogContent({
    required BuildContext context,
    required String title,
    required TextEditingController nameController,
    required PageController pageController,
    required int currentPage,
    required bool isCategory,
    bool hasValidationError = false,
    String validationErrorMessage = '',

    CategoryCubit? categoryCubit,
    SubcategoryCubit? subcategoryCubit,
    required Function(IconData) onIconSelected,
    required Function(Color) onColorSelected,
    required VoidCallback onSavePressed,
  }) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: const OutlineInputBorder(),
                errorText: hasValidationError ? validationErrorMessage : null,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (int page) {
                  currentPage = page;
                  // إعادة بناء الواجهة
                  if (isCategory && categoryCubit != null) {
                    categoryCubit.emit(ChangeCategoryAppearanceState(items: categoryCubit.fetchedCategoriesList));
                  } else if (!isCategory && subcategoryCubit != null) {
                    subcategoryCubit.emit(ChangeSubcategoryAppearanceState(items: subcategoryCubit.fetchedSubcategories));
                  }
                },
                children: [
                  // Icon Selection Page
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Select Icon",
                            style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        IconPickerWidget(
                          currentIcon: IconData(
                              int.tryParse(
                                  isCategory && categoryCubit != null ?
                                  categoryCubit.categoryIcon :
                                  subcategoryCubit?.subcategoryIcon ?? '0xe000') ?? 0xe000,
                              fontFamily: 'MaterialIcons'
                          ),
                          currentColor: isCategory && categoryCubit != null ?
                          categoryCubit.categoryColor :
                          subcategoryCubit?.subcategoryColor ?? Colors.blue,
                          onIconSelected: onIconSelected,
                        ),
                      ],
                    ),
                  ),

                  // Color Selection Page
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Select Color",
                            style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        ColorPickerWidget(
                          currentColor: isCategory && categoryCubit != null ?
                          categoryCubit.categoryColor :
                          subcategoryCubit?.subcategoryColor ?? Colors.blue,
                          onColorSelected: onColorSelected,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 2; i++)
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == i
                          ? AppColor.primaryColor
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: onSavePressed,
          child: Text(title.contains("Add") ? "Add" : "Save"),
        ),
      ],
    );
  }

}