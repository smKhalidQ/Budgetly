import 'package:budget_buddy/modules/reconcile/domain/services/reconcile_service.dart';
import 'package:budget_buddy/modules/reconcile/presentation/cubits/reconcile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReconcileCubit extends Cubit<ReconcileState> {
  final ReconcileService _service;

  ReconcileCubit(this._service) : super(const ReconcileState());

  Future<void> initialize() async {
    emit(state.copyWith(status: ReconcileStatus.loading));
    try {
      final categories = await _service.categories();
      emit(state.copyWith(
        status: ReconcileStatus.ready,
        categories: categories,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ReconcileStatus.error,
        errorMessage: 'Failed to load balance.',
      ));
    }
  }

  void setActual(double value) => emit(state.copyWith(actual: value));

  Future<void> applySpending(Map<int, double> amounts) =>
      _run(() => _service.applySpending(amounts));

  Future<void> applyIncome(Map<int, double> amounts) =>
      _run(() => _service.applyIncome(amounts));

  Future<void> freshStart() => _run(() => _service.freshStart(state.actual));

  Future<void> _run(Future<void> Function() action) async {
    emit(state.copyWith(status: ReconcileStatus.loading));
    try {
      await action();
      emit(state.copyWith(status: ReconcileStatus.done));
    } catch (_) {
      emit(state.copyWith(
        status: ReconcileStatus.error,
        errorMessage: 'Reconcile failed.',
      ));
    }
  }
}
