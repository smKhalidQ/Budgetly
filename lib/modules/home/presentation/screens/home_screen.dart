import 'package:flutter/material.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/home_tab_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 260.0,
                pinned: true,
                backgroundColor: const Color(0xFF1E3B70),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double appBarHeight = constraints.biggest.height;
                    const double appBarMaxHeight = 260.0;
                    final double scrollProgress =
                        (appBarMaxHeight - appBarHeight) /
                            (appBarMaxHeight - kToolbarHeight);
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: scrollProgress > 0.5
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      background: HomeHeaderWidget(),
                      collapseMode: CollapseMode.parallax,
                    );
                  },
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverTabBarDelegate(
                  const TabBar(
                    indicatorColor: Color(0xFF1E3B70),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Categories"),
                      Tab(text: "Settings"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: const HomeTabBarWidget(),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);
  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF5F7F8),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
