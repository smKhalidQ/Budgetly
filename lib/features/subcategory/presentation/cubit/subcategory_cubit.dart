import 'package:budget_buddy/core/data/database/subcategory_datasource.dart';
import 'package:budget_buddy/core/data/models/subcategory_model.dart';
import 'package:budget_buddy/core/data/repositories/sub_categories_repository_impl.dart';
import 'package:budget_buddy/features/subcategory/presentation/cubit/subcategory_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/subcategory-entity.dart';
import '../../domain/usecases/delete_subcategory_data_usecase.dart';
import '../../domain/usecases/edit_subcategory_data_usecase.dart';
import '../../domain/usecases/get_subcategories_data_usecase.dart';
import '../../domain/usecases/insert_new_subcategory_usecase.dart';

class SubcategoryCubit extends Cubit<SubcategoryStates> {
  SubcategoryCubit() : super(SubcategoryManagementInitialStates());

  static SubcategoryCubit get(context) => BlocProvider.of(context);
  List<SubcategoryEntity> fetchedSubcategories = [];

  Future<void> fetchSubcategories() async {
    print("fetchedSubcategories method is toggled");

    emit(GetSubcategoryDataLoadingState());
    final response = await GetSubCategoriesDataUseCase(
      subcategoryRepository: SubcategoryRepositoryImpl(localDataSource: SubcategoryDataSource()),
    ).call();

    response.fold(
          (failure) {
        print(failure.message);
        emit(GetSubcategoryDataErrorState(errorMessage: failure.message));
      },
          (data) {
        fetchedSubcategories = data;
        print("fetchedSubcategories is ${data.length}");

        print("fetchedSubcategories is ${data[0]}");
        emit(GetSubcategoryDataSuccessState(subcategories: data));
      },
    );
    print("=====================Alhamdulillah===============================");
  }

  Future<void> insertNewSubcategory(SubcategoryEntity newSubCategory) async {
    emit(SubcategoryInsertionLoadingState());

    final newSubcategory = SubcategoryModel(
      subcategoryName: newSubCategory.subcategoryName,
      subcategoryColor: newSubCategory.subcategoryColor,
      subcategoryIcon: newSubCategory.subcategoryIcon,
      parentCategoryId: newSubCategory.parentCategoryId
    );
    print("Subcategory Name ${newSubcategory.subcategoryName}");
    print("Subcategory parentCategoryId ${newSubcategory.parentCategoryId}");
    fetchedSubcategories.add(newSubcategory);
    emit(SubcategoryInsertedState());

    final useCase = InsertSubcategoryDataUseCase(
      subcategoryRepository: SubcategoryRepositoryImpl(localDataSource: SubcategoryDataSource()),
    );

    final result = await useCase.call(newSubCategory);

    result.fold(
          (failure) {
        print('Error occurred: ${failure.message}');
        emit(SubcategoryInsertionErrorState(failure.message));
        //
        // fetchedSubcategories.removeWhere((category) =>
        // category.parentCategoryId == newSubcategory.parentCategoryId);

        emit(ChangeSubcategoryAppearanceState(items: fetchedSubcategories));
      },
          (_) {
        print('Subcategory inserted successfully');
        fetchSubcategories();
      },
    );
  }

  Future<void> removeSubcategory(int categoryId) async {
    emit(SubcategoryDeleteLoadingState());

    int index = fetchedSubcategories.indexWhere((subcategory) =>
    subcategory.parentCategoryId == categoryId);
    SubcategoryEntity? removedSubcategory;

    if (index != -1) {
      removedSubcategory = fetchedSubcategories.removeAt(index);
      emit(ChangeSubcategoryAppearanceState(items: fetchedSubcategories));
    }

    final useCase = DeleteSubcategoryDataUseCase(
      subcategoryRepository: SubcategoryRepositoryImpl(
        localDataSource: SubcategoryDataSource(),
      ),
      categoryId: categoryId,
    );

    final result = await useCase.call(categoryId);
    result.fold(
          (failure) {
        print('Error occurred: ${failure.message}');
        emit(SubcategoryDeleteErrorState(failure.message));
        if (removedSubcategory != null) {
          fetchedSubcategories.insert(index, removedSubcategory);
          emit(ChangeSubcategoryAppearanceState(items: fetchedSubcategories));
        }
      },
          (_) {
        print('Category deleted successfully');
        emit(SubcategoryDeletedState());
      },
    );
  }

  Future<void> updateSubcategoryData(
      SubcategoryEntity item, int parentCategoryId) async {
    emit(SubcategoryUpdateLoadingState());

    int index = fetchedSubcategories.indexWhere(
            (category) => category.parentCategoryId == parentCategoryId);
    SubcategoryEntity? oldCategory;

    if (index != -1) {
      oldCategory = fetchedSubcategories[index];
      fetchedSubcategories[index] = item;
      emit(ChangeSubcategoryAppearanceState(items: fetchedSubcategories));
    }

    final useCase = UpdateSubcategoryDataUseCase(
      subcategoryRepository: SubcategoryRepositoryImpl(
        localDataSource: SubcategoryDataSource(),
      ),
    );

    final result = await useCase.call(item, parentCategoryId);
    result.fold(
          (failure) {
        print('Error occurred: ${failure.message}');
        emit(SubcategoryUpdateErrorState(failure.message));
        if (oldCategory != null && index != -1) {
          fetchedSubcategories[index] = oldCategory;
          emit(ChangeSubcategoryAppearanceState(items: fetchedSubcategories));
        }
      },
          (_) {
        print('Category updated successfully');
        emit(SubcategoryUpdatedState());
      },
    );
  }

  // Icon Management
  String? _subcategoryIcon;
  String get subcategoryIcon => _subcategoryIcon ?? Icons.category.codePoint.toString();
  set subcategoryIcon(String value) {
    _subcategoryIcon = value;
    emit(ChangeSubcategoryAppearanceState(items: fetchedSubcategories));
  }

  // Color Management
  Color subcategoryColor = Colors.blueAccent;
  void updateSubcategoryColor(Color color) {
    subcategoryColor = color;
    emit(ChangeSubcategoryAppearanceState(items: fetchedSubcategories));
  }

  // Edit Mode Toggle
  bool isEditMode = false;
  void toggleSubCategoryEditModeState() {
    isEditMode = !isEditMode;
    emit(ToggleSubCategoryEditModeState());
  }

  // Pie Chart Toggle
  bool showPieChart = false;
  void togglePieChart() {
    showPieChart = !showPieChart;
    emit(TogglePieChartState());
  }
}
