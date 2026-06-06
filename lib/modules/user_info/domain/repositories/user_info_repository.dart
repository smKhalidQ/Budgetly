import 'package:budget_buddy/modules/user_info/data/data_sources/user_info_data_source.dart';
import 'package:budget_buddy/modules/user_info/domain/models/user_info.dart';

class UserInfoRepository {
  final UserInfoDataSource _dataSource;

  UserInfoRepository(this._dataSource);

  Future<List<UserInfo>> getAll() async {
    final rows = await _dataSource.getUserData();
    return rows.map(_fromRow).toList();
  }

  Future<void> insert(UserInfo user) async {
    await _dataSource.insertUserData(
      userName: user.name,
      userImg: user.imageUrl ?? '',
      monthlySalary: user.monthlySalary,
      currency: user.currency,
    );
  }

  Future<void> update(UserInfo user) async {
    await _dataSource.updateUserData(
      userId: user.id!,
      userName: user.name,
      userImg: user.imageUrl ?? '',
      monthlySalary: user.monthlySalary,
      currency: user.currency,
      spentAmount: user.spentAmount,
    );
  }

  Future<void> delete(int id) async {
    await _dataSource.deleteUserData(id);
  }

  UserInfo _fromRow(Map<String, dynamic> row) => UserInfo(
        id: row['userId'] as int?,
        name: row['userName'] as String? ?? 'There',
        imageUrl: row['userImg'] as String?,
        currency: row['currency'] as String? ?? '',
        monthlySalary: row['monthlySalary'] as String? ?? '0',
        spentAmount: row['spentAmount'] as String? ?? '0',
      );
}
