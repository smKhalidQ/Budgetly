import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/onboarding/presentation/cubits/setting_cubit.dart';

class CurrencyBottomSheet extends StatelessWidget {
  const CurrencyBottomSheet({super.key, required this.settingCubit});
  final SettingCubit settingCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Currency',
            style: GoogleFonts.abel(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                String currenciesKey = currencies.keys.elementAt(index);
                Map<String, String> currency = currencies[currenciesKey]!;
                return ListTile(
                  leading: Text(currency['flag']!),
                  title: Text(currency['currencyName']!),
                  subtitle: Text(currency['currencySymbol']!),
                  onTap: () {
                    settingCubit.selectCurrency(currenciesKey);
                    Navigator.of(context).pop();
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}
