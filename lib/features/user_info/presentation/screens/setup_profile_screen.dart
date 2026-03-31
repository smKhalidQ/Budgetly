import 'package:budget_buddy/features/user_info/data/models/user_info_model.dart';
import 'package:budget_buddy/features/user_info/domain/entities/user_info_entity.dart';
import 'package:budget_buddy/features/user_info/presentation/cubit/setting_up_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constances.dart';
import '../../../../core/themes/app_color.dart';


import '../../../category/presentation/cubit/category_cubit.dart';
import '../../../category/presentation/screens/category_slicing_screen.dart';
import '../../../user_info/presentation/cubit/setting_up_cubit.dart';
import '../widgets/currency_modal_bottom_sheet.dart';


class SetupProfileScreen extends StatelessWidget {
  SetupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider<SettingCubit>(
      create: (ctx)=>SettingCubit(),
      child: Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: SettingBody()
      ),
    );
  }

}
class SettingBody extends StatelessWidget {
  SettingBody( {Key? key}) : super(key: key);
  TextEditingController salaryController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SettingCubit settingCubit =SettingCubit.get(context);

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
            BlocBuilder<SettingCubit,SettingStates>(
                builder: (context,state) {
                  if (!currencies.containsKey(settingCubit.selectedCurrency)) {
                    settingCubit.selectedCurrency = currencies.keys.first;
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
                            "${currencies[settingCubit.selectedCurrency]!['currencyName']} (${currencies[settingCubit.selectedCurrency]!['currencySymbol']})",
                            style: const TextStyle(
                              color: AppColor.textWhite,
                            ),
                          ),
                          Expanded(child: Container()),
                          const Icon(
                            CupertinoIcons.arrowtriangle_down_fill,
                            color: Colors.white,
                            size: 18,
                          )
                        ],
                      ),
                    ),

                  );
                }
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
                  borderSide: const BorderSide(
                    color: AppColor.cardBackground,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.accentColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.expenseColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.expenseColor,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: AppColor.backgroundGlass,
                errorStyle: const TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your salary';
                }
                final salary = int.tryParse(value);
                if (salary == null || salary <= 0) {
                  return 'Please enter a valid salary';
                }
                return null;
              },
            ),
            const Expanded(child: SizedBox()),
            GestureDetector(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  UserInfoEntity userInfoEntity = UserInfoModel(
                    monthlySalary: salaryController.text,
                    currency: settingCubit.selectedCurrency!,
                  );
                  settingCubit.monthlySalary=int.parse(salaryController.text);
                  settingCubit.insertUserInfo(userInfoEntity);

                  // Navigate to the next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        CategoryCubit.get(context).remainingBudget=settingCubit.monthlySalary;
                        return CategorySlicingScreen(
                            monthlySalary:  settingCubit.monthlySalary, // Replace with actual salary value
                            currency:  settingCubit.selectedCurrency!
                        );
                      }
                    ),
                  );
                } else {
                  // Form is invalid, show a snackbar or other feedback to the user
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
            ),          ],
        ),
      ),
    );
  }
  _showCurrencyBottomSheet(context, SettingCubit settingCubit) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CurrencyBottomSheet(settingCubit: settingCubit);
      },
    );
  }
}