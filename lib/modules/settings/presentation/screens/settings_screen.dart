import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_rounded,
              size: 72.sp,
              color: AppColor.primaryColor.withValues(alpha: 0.15),
            ),
            SizedBox(height: 16.h),
            Text(
              'Settings',
              style: GoogleFonts.cairo(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textSecondary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Coming soon',
              style: GoogleFonts.cairo(
                fontSize: 13.sp,
                color: AppColor.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
