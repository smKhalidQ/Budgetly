import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // needed for Bloc.observer

import 'app.dart';
import 'core/database/database_helper.dart';
import 'core/di/injection_container.dart';
import 'core/utilities/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.db;
  Bloc.observer = MyBlocObserver();
  initializeDependencies();

  runApp(const App());
}
