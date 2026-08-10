import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'core/responsive/adaptive_layout.dart';
import 'core/responsive/responsive_manager.dart';
import 'core/router/app_router.dart';
import 'core/theming/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'modules/category/presentation/cubits/category_cubit.dart';
import 'modules/settings/presentation/cubits/locale_cubit.dart';
import 'modules/settings/presentation/cubits/locale_state.dart';
import 'modules/user_info/presentation/cubits/setting_cubit.dart';
import 'modules/subcategory/presentation/cubits/subcategory_cubit.dart';

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
          create: (_) => GetIt.I<SettingCubit>()..loadUserInfo(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<LocaleCubit>()..initialize(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Slice Pay',
            builder: (context, child) {
              if (ResponsiveManager.isInitialized) {
                ResponsiveManager.instance.forceRecalculate(context);
              } else {
                ResponsiveManager.initialize(context);
              }
              return AdaptiveLayout(child: child!);
            },
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeState.locale,
            theme: appTheme,
            home: AppRouter.initialScreen(),
          );
        },
      ),
    );
  }
}
