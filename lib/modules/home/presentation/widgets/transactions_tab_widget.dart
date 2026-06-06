import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionsTabWidget extends StatelessWidget {
  const TransactionsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 72.sp,
            color: AppColor.primaryColor.withValues(alpha: 0.15),
          ),
          SizedBox(height: 16.h),
          Text(
            t.noTransactionsYet,
            style: GoogleFonts.cairo(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            t.startTracking,
            style: GoogleFonts.cairo(
              fontSize: 13.sp,
              color: AppColor.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
