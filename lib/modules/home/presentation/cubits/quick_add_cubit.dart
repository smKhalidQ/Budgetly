import 'package:budget_buddy/core/services/month_cycle_service.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/home/presentation/cubits/quick_add_state.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/models/transaction.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuickAddCubit extends Cubit<QuickAddState> {
  final CategoryRepository _categoryRepository;
  final SubcategoryRepository _subcategoryRepository;
  final TransactionRepository _transactionRepository;

  static const int _minItems = 7;

  QuickAddCubit(
    this._categoryRepository,
    this._subcategoryRepository,
    this._transactionRepository,
  ) : super(const QuickAddState());

  Future<void> load() async {
    final categories = await _categoryRepository.getAll();
    final subcategories = await _subcategoryRepository.getAll();
    final transactions = await _transactionRepository.getAll();

    final categoryById = {
      for (final c in categories)
        if (c.id != null) c.id!: c,
    };
    final subcategoryById = {
      for (final s in subcategories)
        if (s.id != null) s.id!: s,
    };

    final usage = <String, int>{};
    for (final t in transactions) {
      if (t.type != TransactionType.expense) continue;
      if (!categoryById.containsKey(t.categoryId)) continue;
      final key = t.subcategoryId == null
          ? '${t.categoryId}'
          : '${t.categoryId}:${t.subcategoryId}';
      usage[key] = (usage[key] ?? 0) + 1;
    }

    final ranked = usage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final items = <QuickAddItem>[];
    final usedCategoryIds = <int>{};
    for (final entry in ranked) {
      final parts = entry.key.split(':');
      final category = categoryById[int.parse(parts[0])];
      if (category == null) continue;
      final subcategory =
          parts.length > 1 ? subcategoryById[int.parse(parts[1])] : null;
      items.add(QuickAddItem(category: category, subcategory: subcategory));
      if (category.id != null) usedCategoryIds.add(category.id!);
    }

    for (final category in categories) {
      if (items.length >= _minItems) break;
      if (category.name == MonthCycleService.savingName) continue;
      if (usedCategoryIds.contains(category.id)) continue;
      items.add(QuickAddItem(category: category));
      if (category.id != null) usedCategoryIds.add(category.id!);
    }

    emit(state.copyWith(items: items));
  }
}
