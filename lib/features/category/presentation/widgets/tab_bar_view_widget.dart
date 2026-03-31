import 'package:flutter/material.dart';

import '../../../settings_screen.dart';
import 'explore_screen/main_categories_list_widget.dart';

class TabBarViewWidget extends StatelessWidget {
  const TabBarViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: [
        // Remove SingleChildScrollView here
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: MainCategoriesListWidget(),
        ),
        SettingsScreen(),
      ],
    );
  }
}
