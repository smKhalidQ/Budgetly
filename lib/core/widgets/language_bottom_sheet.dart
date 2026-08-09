import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/locale_cubit.dart';
import 'package:budget_buddy/modules/settings/presentation/cubits/locale_state.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<LocaleCubit>(),
        child: const LanguageBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            t.language,
            style: GoogleFonts.cairo(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LanguageTile(
                    label: t.english,
                    selected: state.locale.languageCode == 'en',
                    onTap: () {
                      context.read<LocaleCubit>().changeLocale(const Locale('en'));
                      Navigator.of(context).pop();
                    },
                  ),
                  _LanguageTile(
                    label: t.arabic,
                    selected: state.locale.languageCode == 'ar',
                    onTap: () {
                      context.read<LocaleCubit>().changeLocale(const Locale('ar'));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: GoogleFonts.cairo(fontSize: 15.sp)),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: AppColor.primaryColor)
          : null,
      onTap: onTap,
    );
  }
}
