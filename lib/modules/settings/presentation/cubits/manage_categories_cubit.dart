import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/manage_categories_state.dart';
import 'package:budget_buddy/modules/user_info/domain/models/user_info.dart';
import 'package:budget_buddy/modules/user_info/domain/repositories/user_info_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageCategoriesCubit extends Cubit<ManageCategoriesState> {
  final CategoryRepository _categoryRepository;
  final UserInfoRepository _userInfoRepository;

  ManageCategoriesCubit(this._categoryRepository, this._userInfoRepository)
      : super(const ManageCategoriesState());

  Future<void> initialize() async {
    emit(state.copyWith(status: ManageCategoriesStatus.loading));
    try {
      final categories = await _categoryRepository.getAll();
      final users = await _userInfoRepository.getAll();
      final salary = users.isNotEmpty
          ? (double.tryParse(users.first.monthlySalary) ?? 0.0)
          : categories.fold(0.0, (s, c) => s + c.baseAllocation);
      final newBases = {
        for (final c in categories)
          if (c.id != null) c.id!: c.baseAllocation,
      };
      emit(state.copyWith(
        status: ManageCategoriesStatus.success,
        categories: categories,
        newBases: newBases,
        newSalary: salary,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ManageCategoriesStatus.error,
        errorMessage: 'Failed to load categories.',
      ));
    }
  }

  void updateSalary(double value) {
    emit(state.copyWith(newSalary: value));
  }

  void updateBase(int categoryId, double value) {
    final updated = Map<int, double>.from(state.newBases)..[categoryId] = value;
    emit(state.copyWith(newBases: updated));
  }

  Future<void> save() async {
    if (!state.canSave) return;
    emit(state.copyWith(status: ManageCategoriesStatus.saving));

    final deferred = <String>[];

    try {
      // save salary if changed
      final users = await _userInfoRepository.getAll();
      if (users.isNotEmpty) {
        final user = users.first;
        final oldSalary = double.tryParse(user.monthlySalary) ?? 0.0;
        if ((state.newSalary - oldSalary).abs() > 0.01) {
          await _userInfoRepository.update(
            user.copyWith(monthlySalary: state.newSalary.toStringAsFixed(0)),
          );
        }
      }

      for (final category in state.categories) {
        if (category.id == null) continue;
        final newBase = state.newBases[category.id!] ?? category.baseAllocation;
        if ((newBase - category.baseAllocation).abs() < 0.01) continue;

        final Category updated;
        if (newBase >= category.spentAmount) {
          updated = category.copyWith(
            baseAllocation: newBase,
            allocatedAmount: newBase,
          );
        } else {
          updated = category.copyWith(baseAllocation: newBase);
          deferred.add(category.name);
        }
        await _categoryRepository.update(category.id!, updated);
      }

      emit(state.copyWith(
        status: ManageCategoriesStatus.success,
        deferredNames: deferred,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ManageCategoriesStatus.error,
        errorMessage: 'Failed to save changes.',
      ));
    }
  }

  Future<void> saveWithRemainderToSaving() async {
    final saving = state.categories.firstWhere(
      (c) => c.name == 'Saving & Goals',
      orElse: () => state.categories.first,
    );
    if (saving.id == null) return;
    final newBase =
        (state.newBases[saving.id!] ?? saving.baseAllocation) + state.remaining;
    updateBase(saving.id!, newBase);
    await save();
  }

  Future<void> addCategory(Category category) async {
    try {
      final maxId = state.categories.fold<int>(
        0,
        (max, c) => (c.id ?? 0) > max ? (c.id ?? 0) : max,
      );
      final withId =
          category.copyWith(id: maxId + 1, baseAllocation: 0, allocatedAmount: 0);
      await _categoryRepository.insert(withId);
      final categories = await _categoryRepository.getAll();
      final newBases = Map<int, double>.from(state.newBases);
      for (final c in categories) {
        if (c.id != null && !newBases.containsKey(c.id!)) {
          newBases[c.id!] = 0;
        }
      }
      emit(state.copyWith(categories: categories, newBases: newBases));
    } catch (_) {
      emit(state.copyWith(
        status: ManageCategoriesStatus.error,
        errorMessage: 'Failed to add category.',
      ));
    }
  }
}
