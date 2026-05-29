import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'l10n/app_localizations.dart';
import 'modules/category/presentation/cubits/category_cubit.dart';
import 'modules/category/presentation/screens/explore_screen.dart';
import 'modules/onboarding/presentation/screens/onboarding_screen.dart';
import 'modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'modules/user_info/data/data_sources/cache_helper.dart';
import 'modules/user_info/presentation/cubits/setting_cubit.dart';
import 'modules/user_info/presentation/screens/setup_profile_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  Widget _initialScreen() {
    final onboardingSeen = CacheHelper.getData(key: 'onboarding_seen') as bool? ?? false;
    final setupDone = CacheHelper.getData(key: 'setup_done') as bool? ?? false;

    if (!onboardingSeen) return const OnboardingScreen();
    if (!setupDone) return SetupProfileScreen();
    return ExploreScreen();
  }

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
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: _initialScreen(),
      ),
    );
  }
}