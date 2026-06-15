import 'package:get_it/get_it.dart';

import 'package:budget_buddy/modules/category/data/data_sources/category_data_source.dart';
import 'package:budget_buddy/modules/subcategory/data/data_sources/subcategory_data_source.dart';
import 'package:budget_buddy/modules/transaction/data/data_sources/transaction_data_source.dart';
import 'package:budget_buddy/modules/user_info/data/data_sources/user_info_data_source.dart';

import 'package:budget_buddy/modules/category/domain/repositories/category_repository.dart';
import 'package:budget_buddy/modules/subcategory/domain/repositories/subcategory_repository.dart';
import 'package:budget_buddy/modules/transaction/domain/repositories/transaction_repository.dart';
import 'package:budget_buddy/modules/user_info/domain/repositories/user_info_repository.dart';

import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/settings_cubit.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/add_transaction/add_transaction_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_cubit.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';

void initializeDependencies() {
  GetIt.I.registerLazySingleton(() => CategoryManagementDataSource());
  GetIt.I.registerLazySingleton(() => SubcategoryDataSource());
  GetIt.I.registerLazySingleton(() => TransactionDataSource());
  GetIt.I.registerLazySingleton(() => UserInfoDataSource());

  GetIt.I.registerLazySingleton(() => CategoryRepository(GetIt.I()));
  GetIt.I.registerLazySingleton(() => SubcategoryRepository(GetIt.I()));
  GetIt.I.registerLazySingleton(() => TransactionRepository(GetIt.I()));
  GetIt.I.registerLazySingleton(() => UserInfoRepository(GetIt.I()));

  GetIt.I.registerFactory(() => CategoryCubit(GetIt.I()));
  GetIt.I.registerFactory(() => SubcategoryCubit(GetIt.I(), GetIt.I()));
  GetIt.I.registerFactory(() => TransactionCubit(GetIt.I(), GetIt.I()));
  GetIt.I.registerFactory(() => AddTransactionCubit(GetIt.I(), GetIt.I(), GetIt.I()));
  GetIt.I.registerFactory(() => SettingCubit(GetIt.I()));
  GetIt.I.registerFactory(() => SettingsCubit(GetIt.I(), GetIt.I()));
}
