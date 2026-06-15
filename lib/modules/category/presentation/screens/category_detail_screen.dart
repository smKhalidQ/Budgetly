import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/presentation/widgets/picker_dialog_helpers.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/widgets/selected_category_header.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';
import 'package:budget_buddy/modules/subcategory/presentation/widgets/subcategories_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Category category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late final SubcategoryCubit _subcategoryCubit;

  @override
  void initState() {
    super.initState();
    _subcategoryCubit = GetIt.I<SubcategoryCubit>()
      ..fetchAndEnsureDefault(widget.category);
  }

  @override
  void dispose() {
    _subcategoryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = parseColorFromString(widget.category.color);
    final double remainingAmount =
        widget.category.allocatedAmount - widget.category.spentAmount;

    return BlocProvider.value(
      value: _subcategoryCubit,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          title: Text(widget.category.name),
        ),
        backgroundColor: AppColor.cardBackground,
        body: BlocBuilder<SubcategoryCubit, SubcategoryState>(
          buildWhen: (prev, curr) => prev.showPieChart != curr.showPieChart,
          builder: (context, state) {
            return Column(
              children: [
                SelectedCategoryHeaderWidget(
                  category: widget.category,
                  categoryColor: categoryColor,
                  remainingAmount: remainingAmount,
                  showPieChart: state.showPieChart,
                  onTogglePieChart: () =>
                      _subcategoryCubit.togglePieChart(),
                ),
                Expanded(
                  child: SubcategoriesListWidget(
                    category: widget.category,
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: BlocBuilder<SubcategoryCubit, SubcategoryState>(
          buildWhen: (prev, curr) => prev.isEditMode != curr.isEditMode,
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
      parentCategoryId: widget.category.id!,
      pickerFunction: (Subcategory newSubcategory) {
        _subcategoryCubit.insertNewSubcategory(newSubcategory);
      },
    );
  }
}
