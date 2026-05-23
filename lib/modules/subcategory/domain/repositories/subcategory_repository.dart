import 'dart:async';
import 'package:budget_buddy/modules/subcategory/data/data_sources/subcategory_data_source.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';

class SubcategoryChangedEvent {
  const SubcategoryChangedEvent();
}

class SubcategoryRepository {
  final SubcategoryDataSource _dataSource;

  SubcategoryRepository(this._dataSource);

  final _changedController = StreamController<SubcategoryChangedEvent>.broadcast();
  Stream<SubcategoryChangedEvent> get onSubcategoryChanged => _changedController.stream;

  Future<List<Subcategory>> getAll() async {
    final rows = await _dataSource.getSubcategoriesData();
    return rows.map(_fromRow).toList();
  }

  Future<void> insert(Subcategory item) async {
    await _dataSource.insertNewSubcategory(
      subcategoryName: item.name,
      subcategoryColor: item.color,
      subcategoryIcon: item.icon,
      parentCategoryId: item.parentCategoryId!,
    );
    _changedController.add(const SubcategoryChangedEvent());
  }

  Future<void> update(int id, Subcategory item) async {
    final fields = <String, dynamic>{
      'subcategoryName': item.name,
      'subcategoryColor': item.color,
      'subcategoryIcon': item.icon,
    };
    if (item.parentCategoryId != null) {
      fields['parentCategoryId'] = item.parentCategoryId;
    }
    await _dataSource.updateSubcategoryData(
      subcategoryId: id,
      updatedFields: fields,
    );
    _changedController.add(const SubcategoryChangedEvent());
  }

  Future<void> delete(int id) async {
    await _dataSource.deleteSubcategoryData(id);
    _changedController.add(const SubcategoryChangedEvent());
  }

  Subcategory _fromRow(Map<String, dynamic> row) => Subcategory(
        id: row['subcategoryId'] as int?,
        parentCategoryId: row['parentCategoryId'] as int?,
        name: row['subcategoryName'] as String? ?? '',
        color: row['subcategoryColor'] as String? ?? '',
        icon: row['subcategoryIcon'] as String? ?? '',
        spentAmount: row['subcategorySpentAmount'] as String?,
      );
}
