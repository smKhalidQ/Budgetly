import 'dart:async';
import 'package:budget_buddy/modules/category/data/data_sources/category_data_source.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';

class CategoryChangedEvent {
  const CategoryChangedEvent();
}

class CategoryRepository {
  final CategoryManagementDataSource _dataSource;

  CategoryRepository(this._dataSource);

  final _changedController = StreamController<CategoryChangedEvent>.broadcast();
  Stream<CategoryChangedEvent> get onCategoryChanged => _changedController.stream;

  Future<List<Category>> getAll() async {
    final rows = await _dataSource.getCategoriesData();
    return rows.map(_fromRow).toList();
  }

  Future<void> insert(Category item) async {
    await _dataSource.insertNewCategory(
      categoryId: item.id!,
      categoryName: item.name,
      categoryColor: item.color,
      categoryIcon: item.icon,
      allocatedAmount: item.allocatedAmount,
      baseAllocation: item.baseAllocation,
    );
    _changedController.add(const CategoryChangedEvent());
  }

  Future<void> update(int id, Category item) async {
    await _dataSource.updateCategoryData(
      categoryId: id,
      updatedFields: {
        'categoryName': item.name,
        'categoryColor': item.color,
        'categoryIcon': item.icon,
        'allocatedAmount': item.allocatedAmount,
        'baseAllocation': item.baseAllocation,
      },
    );
    _changedController.add(const CategoryChangedEvent());
  }

  Future<void> delete(int id) async {
    await _dataSource.deleteCategoryData(id);
    _changedController.add(const CategoryChangedEvent());
  }

  Future<void> initializeAll(List<Category> categories) async {
    await _dataSource.initializeCategoriesData(
      categories: categories
          .map((c) => {
                'categoryId': c.id,
                'categoryName': c.name,
                'categoryColor': c.color,
                'categoryIcon': c.icon,
                'allocatedAmount': c.allocatedAmount,
                'baseAllocation': c.baseAllocation,
                'storedSpentAmount': c.spentAmount,
              })
          .toList(),
    );
    _changedController.add(const CategoryChangedEvent());
  }

  Future<void> clearAll() async {
    await _dataSource.clearAll();
    _changedController.add(const CategoryChangedEvent());
  }

  Future<void> updateSpentAmount(int id, double spentAmount) async {
    await _dataSource.updateSpentAmount(
      categoryId: id,
      storedSpentAmount: spentAmount,
    );
  }

  Future<void> resetAllSpentAmounts() async {
    await _dataSource.resetAllSpentAmounts();
    _changedController.add(const CategoryChangedEvent());
  }

  Category _fromRow(Map<String, dynamic> row) {
    final allocated = (row['allocatedAmount'] as num?)?.toDouble() ?? 0.0;
    return Category(
      id: row['categoryId'] as int?,
      name: row['categoryName'] as String? ?? '',
      color: row['categoryColor'] as String? ?? '',
      icon: row['categoryIcon'] as String? ?? '',
      allocatedAmount: allocated,
      baseAllocation: (row['baseAllocation'] as num?)?.toDouble() ?? allocated,
      spentAmount: (row['storedSpentAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
