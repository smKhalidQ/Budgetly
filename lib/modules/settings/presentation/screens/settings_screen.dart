import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/reconcile/presentation/screens/reconcile_screen.dart';
import 'package:budget_buddy/modules/recurring/presentation/screens/recurring_expenses_screen.dart';
import 'package:budget_buddy/modules/settings/presentation/screens/manage_categories_screen.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/settings_cubit.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<SettingsCubit>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  void _confirmReset(BuildContext context) {
    final cubit = context.read<SettingsCubit>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Reset to initial state?',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'All transactions will be deleted and spending will be zeroed. '
          'Your salary, category allocations, and fixed expenses are kept.',
          style: GoogleFonts.cairo(
            fontSize: 13.sp,
            color: AppColor.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.cairo(color: AppColor.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.resetToPostSetup();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _onResetDone(BuildContext context, SettingsState state) {
    context.read<CategoryCubit>().fetchCategories();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reset complete — back to post-setup state',
          style: GoogleFonts.cairo(fontSize: 12.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.cairo(
            color: AppColor.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status &&
            curr.status == SettingsStatus.success &&
            curr.wasReset,
        listener: _onResetDone,
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            children: [
              _SectionLabel('Categories'),
              _SettingsTile(
                icon: Icons.category_rounded,
                iconColor: AppColor.primaryColor,
                title: 'Manage categories',
                subtitle: 'Redistribute budget or add a new category',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor.textSecondary.withValues(alpha: 0.4),
                  size: 22.sp,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageCategoriesScreen(),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _SectionLabel('Fixed expenses'),
              _SettingsTile(
                icon: Icons.push_pin_rounded,
                iconColor: AppColor.primaryColor,
                title: 'Manage fixed expenses',
                subtitle: 'Bills & start a new month',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor.textSecondary.withValues(alpha: 0.4),
                  size: 22.sp,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecurringExpensesScreen(),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _SectionLabel('Balance'),
              _SettingsTile(
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColor.accentColor,
                title: 'Reconcile balance',
                subtitle: 'Match the app to the money you actually have',
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor.textSecondary.withValues(alpha: 0.4),
                  size: 22.sp,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReconcileScreen(),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _SectionLabel('Debug'),
              _SettingsTile(
                icon: Icons.restart_alt_rounded,
                iconColor: Colors.red,
                title: 'Reset to post-setup state',
                subtitle:
                    'Wipe all transactions & spending — keeps salary and allocations',
                trailing: state.isLoading
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.chevron_right_rounded,
                        color: AppColor.textSecondary.withValues(alpha: 0.4),
                        size: 22.sp,
                      ),
                onTap: state.isLoading ? null : () => _confirmReset(context),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 8.h, 4.w, 8.h),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.textSecondary,
        ),
      ),
    );
  }
}

// ─── Settings Tile ────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.cardBackground,
      borderRadius: BorderRadius.circular(AppRadius.lg.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 11.sp,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
