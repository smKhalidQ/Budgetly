import 'package:budget_buddy/core/constances.dart';
import 'package:budget_buddy/core/domain/entities/subcategory-entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/themes/app_color.dart';
import '../../presentation/cubit/subcategory_cubit.dart';
import '../../presentation/cubit/subcategory_states.dart';

class SubcategoriesListWidget extends StatelessWidget {
  final Function(SubcategoryEntity) onSubcategoryTap;//to add Transaction
  final int parentCategoryId;

  const SubcategoriesListWidget({
    super.key,
    required this.onSubcategoryTap, required this.parentCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoryCubit, SubcategoryStates>(
      builder: (context, state) {
        SubcategoryCubit subcategoryCubit=SubcategoryCubit.get(context);
        final isEditMode = subcategoryCubit.isEditMode;
        final List<SubcategoryEntity> selectedSubcategoryItems =
        subcategoryCubit.fetchedSubcategories
            .where((item) => item.parentCategoryId == parentCategoryId)
            .toList();

        return Column(
          children: [
            _buildSubcategoriesBar(context, isEditMode,subcategoryCubit),
            Expanded(
              child: _buildSubcategoriesList(isEditMode,subcategoryCubit,selectedSubcategoryItems),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubcategoriesBar(BuildContext context, bool isEditMode,SubcategoryCubit subcategoryCubit) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      width: double.infinity,
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "SUBCATEGORIES",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
            ),
          ),
          IconButton(
            icon: Icon(
              isEditMode ? Icons.close : Icons.settings,
              color: Colors.blueGrey[700],
              size: 20,
            ),
            onPressed: (){
              subcategoryCubit.toggleSubCategoryEditModeState();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesList( bool isEditMode,SubcategoryCubit subcategoryCubit, List<SubcategoryEntity> selectedSubcategoryItems) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: selectedSubcategoryItems.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[200],
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          // final subcategoryItem = subcategoryCubit.fetchedSubcategories[index];
          SubcategoryEntity subcategoryItem=selectedSubcategoryItems[index];

          return _buildSubcategoryItem(context, index, isEditMode, subcategoryItem);
        },
      ),
    );
  }

  Widget _buildSubcategoryItem(BuildContext context, int index, bool isEditMode,SubcategoryEntity subcategoryItem) {
    return InkWell(
      onTap: () {
        if (isEditMode) {
          // onEditSubcategory(subcategory, index);
          print("Pressed");
        } else {
          onSubcategoryTap(subcategoryItem);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Subcategory Icon with Background
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: parseColorFromString(subcategoryItem.subcategoryColor!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                IconData(int.parse(subcategoryItem.subcategoryIcon!)),
                color: parseColorFromString(subcategoryItem.subcategoryColor!),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Subcategory Name
            Expanded(
              child: Text(
                subcategoryItem.subcategoryName!,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Edit Icon (Only in Edit Mode)
            if (isEditMode)
              Tooltip(
                message: "Edit",
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(Icons.edit_outlined, color: Colors.blueGrey, size: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
