import 'package:budget_buddy/core/utilities/listener_mixin.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionCubit extends Cubit<TransactionState> with StreamListener {
  final TransactionRepository _repository;

  TransactionCubit(this._repository) : super(const TransactionState());

  static TransactionCubit get(context) => BlocProvider.of(context);

  void toggleEditMode() => emit(state.copyWith(isEditMode: !state.isEditMode));
}
