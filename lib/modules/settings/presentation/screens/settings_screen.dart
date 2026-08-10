import 'package:slice_pay/core/responsive/responsive_manager.dart';
import 'package:slice_pay/core/theming/app_color.dart';
import 'package:slice_pay/core/theming/app_radius.dart';
import 'package:slice_pay/l10n/translation.dart';
import 'package:slice_pay/modules/category/presentation/cubits/category_cubit.dart';
import 'package:slice_pay/modules/reconcile/presentation/screens/reconcile_screen.dart';
import 'package:slice_pay/modules/recurring/presentation/screens/recurring_expenses_screen.dart';
import 'package:slice_pay/modules/settings/presentation/screens/language_screen.dart';
import 'package:slice_pay/modules/settings/presentation/screens/manage_categories_screen.dart';
import 'package:slice_pay/modules/settings/presentation/cubits/settings_cubit.dart';
import 'package:slice_pay/modules/settings/presentation/cubits/settings_state.dart';
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
    final t = context.tr;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          t.resetToInitialStateTitle,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          t.resetToInitialStateMsg,
          style: GoogleFonts.cairo(
            fontSize: 13.sp,
            color: AppColor.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              t.cancel,
              style: GoogleFonts.cairo(color: AppColor.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.expenseColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.resetToPostSetup();
            },
            child: Text(t.reset),
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
          context.tr.resetCompleteMsg,
          style: GoogleFonts.cairo(fontSize: 12.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          t.settings,
          style: GoogleFonts.cairo(
            color: Colors.white,
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
              _SectionLabel(t.general),
              _SettingsTile(
                icon: Icons.language_rounded,
                iconColor: AppColor.primaryColor,
                title: t.language,
                subtitle: t.changeAppLanguage,
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor.textSecondary.withValues(alpha: 0.4),
                  size: 22.sp,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                ),
              ),
              SizedBox(height: 16.h),
              _SectionLabel(t.categories),
              _SettingsTile(
                icon: Icons.category_rounded,
                iconColor: AppColor.primaryColor,
                title: t.manageCategories,
                subtitle: t.manageCategoriesSubtitle,
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
              _SectionLabel(t.fixedExpenses),
              _SettingsTile(
                icon: Icons.push_pin_rounded,
                iconColor: AppColor.primaryColor,
                title: t.manageFixedExpenses,
                subtitle: t.manageFixedExpensesSubtitle,
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
              _SectionLabel(t.balance),
              _SettingsTile(
                icon: Icons.account_balance_wallet_rounded,
                iconColor: AppColor.accentColor,
                title: t.reconcileBalance,
                subtitle: t.reconcileBalanceSubtitle,
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
              _SectionLabel(t.debug),
              _SettingsTile(
                icon: Icons.restart_alt_rounded,
                iconColor: AppColor.expenseColor,
                title: t.resetToPostSetupTitle,
                subtitle: t.resetToPostSetupSubtitle,
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

// â”€â”€â”€ Section Label â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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

// â”€â”€â”€ Settings Tile â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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
