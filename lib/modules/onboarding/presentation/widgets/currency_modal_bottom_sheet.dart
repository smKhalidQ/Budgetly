import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';

class CurrencyBottomSheet extends StatelessWidget {
  const CurrencyBottomSheet({super.key, required this.settingCubit});
  final SettingCubit settingCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Currency',
            style: GoogleFonts.abel(
              textStyle: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              ),
            ),
          ),
          SizedBox(height: 10.h),
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
