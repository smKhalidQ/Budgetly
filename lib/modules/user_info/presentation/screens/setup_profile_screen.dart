import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/category/presentation/screens/category_slicing_screen.dart';
import 'package:budget_buddy/modules/user_info/domain/models/user_info.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_state.dart';
import 'package:budget_buddy/modules/user_info/presentation/widgets/currency_modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SetupProfileScreen extends StatelessWidget {
  SetupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SettingBody(),
    );
  }
}

class SettingBody extends StatelessWidget {
  SettingBody({Key? key}) : super(key: key);
  final TextEditingController salaryController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final settingCubit = SettingCubit.get(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Text(
              "We just need a few details to set things up",
              style: GoogleFonts.abel(
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.textWhite,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            BlocBuilder<SettingCubit, SettingState>(
              builder: (context, state) {
                final selectedCurrency = state.selectedCurrency ?? currencies.keys.first;
                if (!currencies.containsKey(selectedCurrency)) {
                  settingCubit.selectCurrency(currencies.keys.first);
                }
                return Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.lightGray),
                  ),
                  child: GestureDetector(
                    onTap: () => _showCurrencyBottomSheet(context, settingCubit),
                    child: Row(
                      children: [
                        Text(
                          "Currency: ",
                          style: GoogleFonts.abel(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: AppColor.textWhite,
                            ),
                          ),
                        ),
                        const Gap(10),
                        Text(
                          "${currencies[selectedCurrency]!['currencyName']} (${currencies[selectedCurrency]!['currencySymbol']})",
                          style: const TextStyle(color: AppColor.textWhite),
                        ),
                        Expanded(child: Container()),
                        const Icon(
                          CupertinoIcons.arrowtriangle_down_fill,
                          color: Colors.white,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Gap(20),
            TextFormField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixText: "Salary: ",
                prefixStyle: GoogleFonts.abel(
                  textStyle: const TextStyle(
                    color: AppColor.textWhite,
                    fontSize: 20,
                  ),
                ),
                labelText: "Monthly Salary",
                labelStyle: GoogleFonts.abel(
                  textStyle: const TextStyle(
                    color: AppColor.textWhite,
                    fontSize: 20,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.cardBackground, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.accentColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.expenseColor, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColor.expenseColor, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: AppColor.backgroundGlass,
                errorStyle: const TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your salary';
                final salary = int.tryParse(value);
                if (salary == null || salary <= 0) return 'Please enter a valid salary';
                return null;
              },
            ),
            const Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  final salary = int.parse(salaryController.text);
                  final selectedCurrency =
                      settingCubit.state.selectedCurrency ?? currencies.keys.first;
                  final user = UserInfo(
                    monthlySalary: salaryController.text,
                    currency: selectedCurrency,
                  );
                  settingCubit.setMonthlySalary(salary);
                  settingCubit.insertUserInfo(user);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorySlicingScreen(
                        monthlySalary: salary,
                        currency: selectedCurrency,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a valid salary to proceed."),
                      backgroundColor: AppColor.expenseColor,
                    ),
                  );
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.cardBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Next",
                    style: GoogleFonts.abel(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyBottomSheet(BuildContext context, SettingCubit settingCubit) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => CurrencyBottomSheet(settingCubit: settingCubit),
    );
  }
}
