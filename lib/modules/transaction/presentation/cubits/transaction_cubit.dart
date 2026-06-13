import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> with StreamListener {
  final TransactionRepository _repository;
  final CategoryRepository _categoryRepository;

  TransactionCubit(this._repository, this._categoryRepository)
      : super(const TransactionState());

  static TransactionCubit get(context) => BlocProvider.of(context);

  void initialize() {
    listen(_repository.onTransactionAdded, (_) => _load());
    listen(_categoryRepository.onCategoryChanged, (_) => _load());
    _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final transactions = await _repository.getAll();
      final categories = await _categoryRepository.getAll();

      emit(state.copyWith(
        status: TransactionStatus.success,
        transactions: transactions,
        categoriesById: {
          for (final c in categories)
            if (c.id != null) c.id!: c,
        },
      ));
    } catch (_) {
      emit(state.copyWith(
        status: TransactionStatus.error,
        errorMessage: 'Failed to load transactions.',
      ));
    }
  }

  void toggleEditMode() => emit(state.copyWith(isEditMode: !state.isEditMode));
}
