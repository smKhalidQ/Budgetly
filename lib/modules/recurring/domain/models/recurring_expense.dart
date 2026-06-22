// run build_runner
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_expense.freezed.dart';

/// A fixed expense the user pays every cycle (rent, subscriptions…). It is
/// posted automatically against its category when the user starts a new month.
@freezed
sealed class RecurringExpense with _$RecurringExpense {
  const factory RecurringExpense({
    int? id,
    required int categoryId,
    int? subcategoryId,
    required double amount,
    String? note,
    @Default(true) bool isActive,
  }) = _RecurringExpense;
}
