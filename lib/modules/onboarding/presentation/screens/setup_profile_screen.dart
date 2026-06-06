import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/onboarding/presentation/screens/category_slicing_screen.dart';
import 'package:budget_buddy/modules/user_info/domain/models/user_info.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_cubit.dart';
import 'package:budget_buddy/modules/user_info/presentation/cubits/setting_state.dart';
import 'package:budget_buddy/modules/onboarding/presentation/widgets/currency_modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SetupProfileScreen extends StatelessWidget {
  const SetupProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: const _SetupBody(),
    );
  }
}

class _SetupBody extends StatefulWidget {
  const _SetupBody();

  @override
  State<_SetupBody> createState() => _SetupBodyState();
}

class _SetupBodyState extends State<_SetupBody> {
  final _nameController = TextEditingController();
  final _salaryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasAttemptedSubmit = false;

  @override
  void dispose() {
    _nameController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tr;
    final settingCubit = SettingCubit.get(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
        child: Form(
          key: _formKey,
          autovalidateMode: _hasAttemptedSubmit
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(24.h),
              Center(
                child: Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 36.sp,
                  ),
                ),
              ),
              Gap(24.h),
              Center(
                child: Text(
                  t.setupTitle,
                  style: GoogleFonts.cairo(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(6.h),
              Center(
                child: Text(
                  t.setupSubtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gap(40.h),

              _FieldLabel(label: t.yourName),
              Gap(8.h),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  hint: t.yourNameHint,
                  icon: Icons.person_outline_rounded,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? t.pleaseEnterName : null,
              ),
              Gap(20.h),

              _FieldLabel(label: t.currency),
              Gap(8.h),
              BlocBuilder<SettingCubit, SettingState>(
                buildWhen: (prev, curr) =>
                    prev.selectedCurrency != curr.selectedCurrency,
                builder: (context, state) {
                  final key = state.selectedCurrency ?? currencies.keys.first;
                  final info = currencies[key]!;
                  return GestureDetector(
                    onTap: () => _showCurrencySheet(context, settingCubit),
                    child: Container(
                      height: 56.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.currency_exchange_rounded,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: 20.sp,
                          ),
                          Gap(12.w),
                          Text(
                            '${info['flag']}  ${info['currencyName']} (${info['currencySymbol']})',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            CupertinoIcons.chevron_down,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 16.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Gap(20.h),

              _FieldLabel(label: t.monthlySalary),
              Gap(8.h),
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.done,
                decoration: _inputDecoration(
                  hint: t.salaryHint,
                  icon: Icons.payments_outlined,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return t.pleaseEnterSalary;
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) return t.invalidSalary;
                  return null;
                },
              ),
              Gap(48.h),

              GestureDetector(
                onTap: () => _onNext(context, settingCubit),
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      t.next,
                      style: GoogleFonts.cairo(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onNext(BuildContext context, SettingCubit settingCubit) {
    setState(() => _hasAttemptedSubmit = true);
    if (!_formKey.currentState!.validate()) return;

    final salary = int.parse(_salaryController.text);
    final name = _nameController.text.trim();
    final currency =
        settingCubit.state.selectedCurrency ?? currencies.keys.first;

    settingCubit.setMonthlySalary(salary);
    settingCubit.insertUserInfo(
      UserInfo(name: name, monthlySalary: _salaryController.text, currency: currency),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategorySlicingScreen(
          monthlySalary: salary,
          currency: currency,
        ),
      ),
    );
  }

  void _showCurrencySheet(BuildContext context, SettingCubit settingCubit) {
    showModalBottomSheet(
      context: context,
      builder: (_) => CurrencyBottomSheet(settingCubit: settingCubit),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        color: Colors.white.withValues(alpha: 0.4),
        fontSize: 14.sp,
      ),
      prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20.sp),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.08),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: AppColor.accentColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: AppColor.expenseColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(color: AppColor.expenseColor, width: 2),
      ),
      errorStyle: const TextStyle(color: Colors.white70),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.cairo(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}
