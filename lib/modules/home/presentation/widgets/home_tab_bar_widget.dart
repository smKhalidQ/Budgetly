import 'package:budget_buddy/modules/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'main_categories_list_widget.dart';

class HomeTabBarWidget extends StatelessWidget {
  const HomeTabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: MainCategoriesListWidget(),
        ),
        SettingsScreen(),
      ],
    );
  }
}
