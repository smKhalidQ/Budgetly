import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';

class SubcategoriesListWidget extends StatelessWidget {
  final Function(Subcategory) onSubcategoryTap;
  final int parentCategoryId;

  const SubcategoriesListWidget({
    super.key,
    required this.onSubcategoryTap,
    required this.parentCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoryCubit, SubcategoryState>(
      builder: (context, state) {
        final isEditMode = state.isEditMode;
        final selectedSubcategoryItems = state.subcategories
            .where((item) => item.parentCategoryId == parentCategoryId)
            .toList();

        return Column(
          children: [
            _buildSubcategoriesBar(
                context, isEditMode, SubcategoryCubit.get(context)),
            Expanded(
              child: _buildSubcategoriesList(
                  isEditMode,
                  SubcategoryCubit.get(context),
                  selectedSubcategoryItems),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubcategoriesBar(
      BuildContext context, bool isEditMode, SubcategoryCubit subcategoryCubit) {
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
            onPressed: () {
              subcategoryCubit.toggleSubCategoryEditModeState();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSubcategoriesList(bool isEditMode,
      SubcategoryCubit subcategoryCubit, List<Subcategory> selectedSubcategoryItems) {
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
          final subcategoryItem = selectedSubcategoryItems[index];
          return _buildSubcategoryItem(
              context, index, isEditMode, subcategoryItem);
        },
      ),
    );
  }

  Widget _buildSubcategoryItem(BuildContext context, int index, bool isEditMode,
      Subcategory subcategoryItem) {
    return InkWell(
      onTap: () {
        if (!isEditMode) {
          onSubcategoryTap(subcategoryItem);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: parseColorFromString(subcategoryItem.color),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                IconData(int.parse(subcategoryItem.icon),
                    fontFamily: 'MaterialIcons'),
                color: parseColorFromString(subcategoryItem.color),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                subcategoryItem.name,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
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
                    child: Icon(Icons.edit_outlined,
                        color: Colors.blueGrey, size: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
