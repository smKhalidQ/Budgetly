import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slice_pay/core/responsive/responsive_manager.dart';
import 'package:slice_pay/core/theming/app_color.dart';
import 'package:slice_pay/core/theming/app_radius.dart';
import 'package:slice_pay/l10n/translation.dart';
import 'package:slice_pay/modules/settings/presentation/cubits/locale_cubit.dart';
import 'package:slice_pay/modules/settings/presentation/cubits/locale_state.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return BlocProvider.value(
      value: GetIt.I<LocaleCubit>(),
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            t.language,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
        ),
        body: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              children: [
                _LanguageOption(
                  label: t.english,
                  selected: state.locale.languageCode == 'en',
                  onTap: () => context
                      .read<LocaleCubit>()
                      .changeLocale(const Locale('en')),
                ),
                SizedBox(height: 12.h),
                _LanguageOption(
                  label: t.arabic,
                  selected: state.locale.languageCode == 'ar',
                  onTap: () => context
                      .read<LocaleCubit>()
                      .changeLocale(const Locale('ar')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.label,
    required this.selected,
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColor.primaryColor,
                  size: 22.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
