import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'modules/category/presentation/cubits/category_cubit.dart';
import 'modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'modules/user_info/presentation/cubits/setting_cubit.dart';
import 'modules/user_info/presentation/screens/setup_profile_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<CategoryCubit>()..fetchCategories(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<SubcategoryCubit>()..fetchSubcategories(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<SettingCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Budget Buddy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: SetupProfileScreen(),
      ),
    );
  }
}
