import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/home/presentation/widgets/home_header_widget.dart';
import 'package:budget_buddy/modules/home/presentation/widgets/main_categories_list_widget.dart';
import 'package:budget_buddy/modules/home/presentation/widgets/transactions_tab_widget.dart';
import 'package:budget_buddy/modules/settings/presentation/screens/settings_screen.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _TransactionsTab(),
          _IncomeTab(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: t.categories,
                  isSelected: _currentIndex == 0,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.receipt_long_rounded,
                  label: t.transactions,
                  isSelected: _currentIndex == 1,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                // Add / Income button
                GestureDetector(
                  onTap: () => setState(() => _currentIndex = 2),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _currentIndex == 2
                          ? AppColor.primaryColor
                          : AppColor.accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.accentColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                _NavItem(
                  icon: Icons.settings_rounded,
                  label: t.settings,
                  isSelected: _currentIndex == 3,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Tabs ───────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  static String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final name = context
        .select<SettingCubit, String>((c) => c.state.userName.split(' ').first);
    final topPad = MediaQuery.of(context).padding.top;

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
      slivers: [
        // ── SliverAppBar = Greeting + Bank Card ──
        SliverAppBar(
          expandedHeight: 280,
          pinned: false,
          floating: false,
          backgroundColor: AppColor.primaryColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final collapsed = constraints.biggest.height <=
                  kToolbarHeight + topPad + 1;

              return FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                titlePadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                title: collapsed
                    ? Text(
                        name.isNotEmpty
                            ? '${_greeting()}, $name'
                            : _greeting(),
                        style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
                background: Container(
                  color: AppColor.backgroundColor,
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting row
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _greeting(),
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      color: AppColor.textSecondary,
                                    ),
                                  ),
                                  if (name.isNotEmpty)
                                    Text(
                                      name,
                                      style: GoogleFonts.cairo(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primaryColor,
                                        height: 1.1,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor
                                    .withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: AppColor.primaryColor,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bank card
                      const HomeHeaderWidget(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // ── Sticky Categories Header ──
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickyHeader(label: context.tr.categories),
        ),
        // ── Categories List ──
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(child: MainCategoriesListWidget()),
        ),
      ],
    ),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          context.tr.transactions,
          style: GoogleFonts.cairo(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: const TransactionsTabWidget(),
    );
  }
}

class _IncomeTab extends StatelessWidget {
  const _IncomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Income',
          style: GoogleFonts.cairo(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 72,
              color: AppColor.accentColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Add Income',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColor.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sticky Header Delegate ──────────────────────────────

class _StickyHeader extends SliverPersistentHeaderDelegate {
  final String label;
  static const double height = 52;

  const _StickyHeader({required this.label});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final isSticky = shrinkOffset > 0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: isSticky ? AppColor.primaryColor : AppColor.backgroundColor,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: isSticky ? Colors.white : AppColor.textPrimary,
        ),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(_StickyHeader old) => old.label != label;
}

// ─── Nav Item ────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected
                    ? AppColor.primaryColor
                    : AppColor.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.normal,
                color: isSelected
                    ? AppColor.primaryColor
                    : AppColor.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
