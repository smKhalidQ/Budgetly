import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../subcategory/presentation/cubit/subcategory_cubit.dart';
import '../cubit/category_cubit.dart';
import '../widgets/explore_screen/explore_header_widget.dart';
import '../widgets/tab_bar_view_widget.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 260.0,
                pinned: true,
                backgroundColor: const Color(0xFF1E3B70),
                flexibleSpace: LayoutBuilder(
                  builder:
                      (BuildContext context, BoxConstraints constraints) {
                    // Calculate visibility based on scroll position
                    final double appBarHeight = constraints.biggest.height;
                    const double appBarMaxHeight =
                        260.0; // Same as expandedHeight
                    final double scrollProgress =
                        (appBarMaxHeight - appBarHeight) /
                            (appBarMaxHeight - kToolbarHeight);

                    return FlexibleSpaceBar(
                      centerTitle: true, // Center the title horizontally
                      title: scrollProgress > 0.5
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: const Text(
                                "عَنْ مَالِه فِيمَ أَنْفَقَه",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : null,
                      background: ExploreHeaderWidget(),
                      collapseMode: CollapseMode.parallax,
                    );
                  },
                ),
              ),
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                  const TabBar(
                    indicatorColor: Color(0xFF1E3B70),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Categories"),
                      Tab(text: "Transactions"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: const TabBarViewWidget(),
        ),
      ),
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF5F7F8),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
