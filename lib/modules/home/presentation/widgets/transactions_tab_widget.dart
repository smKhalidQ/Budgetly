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
            size: 72,
            color: AppColor.primaryColor.withValues(alpha: 0.15),
          ),
          const SizedBox(height: 16),
          Text(
            t.noTransactionsYet,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColor.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t.startTracking,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppColor.textSecondary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
