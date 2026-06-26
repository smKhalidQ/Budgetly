// run build_runner
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';

part 'reconcile_state.freezed.dart';

enum ReconcileStatus { initial, loading, ready, done, error }

@freezed
sealed class ReconcileState with _$ReconcileState {
  const factory ReconcileState({
    @Default(ReconcileStatus.initial) ReconcileStatus status,
    @Default([]) List<Category> categories,
    @Default(0.0) double actual,
    String? errorMessage,
  }) = _ReconcileState;
}

extension ReconcileStateX on ReconcileState {
  double remainingOf(Category c) {
    final r = c.allocatedAmount - c.spentAmount;
    return r > 0 ? r : 0;
  }

  double get expected =>
      categories.fold<double>(0.0, (sum, c) => sum + remainingOf(c));

  double get diff => expected - actual;
  bool get isLoading => status == ReconcileStatus.loading;
  bool get hasActual => actual > 0;
  bool get isUnloggedSpending => diff > 0.01;
  bool get isExtra => diff < -0.01;
  bool get isMatched => diff.abs() <= 0.01;
}
