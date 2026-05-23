import 'package:budget_buddy/modules/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'explore_screen/main_categories_list_widget.dart';

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({Key? key}) : super(key: key);

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
