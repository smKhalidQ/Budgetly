import 'package:budget_buddy/features/category/presentation/cubit/category_cubit.dart';
import 'package:budget_buddy/features/subcategory/presentation/cubit/subcategory_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/data/database/database_helper.dart';
import 'core/util/bloc_obserever.dart';

import 'features/category/presentation/screens/explore_screen.dart';
import 'features/user_info/presentation/screens/setup_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.db;
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=>CategoryCubit()..fetchCategories()),
        BlocProvider(create: (context)=>SubcategoryCubit()..fetchSubcategories()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home:
        SetupProfileScreen()
        // ExploreScreen(),
      ),
    );
  }
}
