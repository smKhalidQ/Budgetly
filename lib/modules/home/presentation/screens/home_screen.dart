import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/home/presentation/widgets/home_header_widget.dart';
import 'package:budget_buddy/modules/home/presentation/widgets/main_categories_list_widget.dart';
import 'package:budget_buddy/modules/home/presentation/widgets/transactions_tab_widget.dart';
import 'package:budget_buddy/modules/settings/presentation/screens/settings_screen.dart';
import 'package:budget_buddy/modules/transaction/presentation/cubits/transaction_cubit.dart';
import 'package:budget_buddy/modules/transaction/presentation/widgets/add_transaction_sheet.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _openAddTransactionSheet() {
    AddTransactionSheet.show(
      context,
      onSuccess: () => context.read<CategoryCubit>().fetchCategories(),
    );
  }

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
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          boxShadow: [
            BoxShadow(
              color: AppColor.backgroundCardShadow,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
                GestureDetector(
                  onTap: _openAddTransactionSheet,
                  child: Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      color: AppColor.accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.accentColor.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                ),
                _NavItem(
                  icon: Icons.settings_rounded,
                  label: t.settings,
                  isSelected: _currentIndex == 2,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: false,
          backgroundColor: AppColor.primaryColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 20.w,
          title: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _greeting(),
                      style: GoogleFonts.cairo(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                    if (name.isNotEmpty)
                      Text(
                        name,
                        style: GoogleFonts.cairo(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                // 60% of card visual height (card margin-top 12.h + 60% of ~152.h inner)
                height: 160.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.r),
                      bottomRight: Radius.circular(32.r),
                    ),
                  ),
                ),
              ),
              const HomeHeaderWidget(),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
            child: Text(
              context.tr.categories,
              style: GoogleFonts.cairo(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.textPrimary,
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: const SliverToBoxAdapter(child: MainCategoriesListWidget()),
        ),
      ],
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
            fontSize: 18.sp,
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => GetIt.I<TransactionCubit>()..initialize(),
        child: const TransactionsTabWidget(),
      ),
    );
  }
}


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
        width: 64.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 22.sp,
                color:
                    isSelected ? AppColor.primaryColor : AppColor.textSecondary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                color:
                    isSelected ? AppColor.primaryColor : AppColor.textSecondary,
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
