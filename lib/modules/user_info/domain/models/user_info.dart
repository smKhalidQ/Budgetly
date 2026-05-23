import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';

@freezed
sealed class UserInfo with _$UserInfo {
  const factory UserInfo({
    int? id,
    @Default('There') String name,
    String? imageUrl,
    @Default('') String currency,
    @Default('0') String monthlySalary,
    @Default('0') String spentAmount,
  }) = _UserInfo;
}
