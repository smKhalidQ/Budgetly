import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/home/presentation/screens/home_screen.dart';
import 'saving_balance_dialog.dart';

class CustomSetUpBottomBar extends StatelessWidget {
  const CustomSetUpBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: () => _onConfirm(context),
                icon: Icon(Icons.check_rounded, size: 18.sp),
                label: Text(
                  t.confirmBudget,
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              t.editCategoriesLater,
              style: GoogleFonts.cairo(
                fontSize: 12.sp,
                color: AppColor.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onConfirm(BuildContext context) async {
    final cubit = CategoryCubit.get(context);
    final done = await cubit.completeSetup();
    if (!context.mounted) return;
    if (done) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } else {
      _showSavingBalanceDialog(context, cubit);
    }
  }

  void _showSavingBalanceDialog(BuildContext context, CategoryCubit cubit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => Container(),
      transitionBuilder: (context, animation, _, __) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(
            opacity: animation,
            child: BlocProvider.value(
              value: cubit,
              child: const SavingBalanceDialog(),
            ),
          ),
        );
      },
    );
  }
}
