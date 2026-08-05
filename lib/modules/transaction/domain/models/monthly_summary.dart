// run build_runner
import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_summary.freezed.dart';

@freezed
sealed class MonthlySummary with _$MonthlySummary {
  const factory MonthlySummary({
    required int year,
    required int month,
    @Default(0) double expense,
    @Default(0) double income,
    @Default(0) int txCount,
  }) = _MonthlySummary;
}

extension MonthlySummaryX on MonthlySummary {
  double get saved => income - expense;

  bool get isCurrentMonth {
    final now = DateTime.now();
    return now.year == year && now.month == month;
  }
}
