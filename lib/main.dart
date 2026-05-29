import 'package:flutter/material.dart';

import 'app.dart';
import 'core/database/database_helper.dart';
import 'core/di/injection_container.dart';
import 'modules/user_info/data/data_sources/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.db;
  await CacheHelper.init();
  // Bloc.observer = MyBlocObserver();
  initializeDependencies();

  runApp(const App());
}
