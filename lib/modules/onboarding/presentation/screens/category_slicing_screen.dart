import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/onboarding/presentation/widgets/build_header_section.dart';
import 'package:budget_buddy/modules/onboarding/presentation/widgets/category_slicing_card_list.dart';
import 'package:budget_buddy/modules/onboarding/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

class CategorySlicingScreen extends StatefulWidget {
  final int monthlySalary;
  final String currency;

  const CategorySlicingScreen({
    super.key,
    required this.monthlySalary,
    required this.currency,
  });

  @override
  State<CategorySlicingScreen> createState() => _CategorySlicingScreenState();
}

class _CategorySlicingScreenState extends State<CategorySlicingScreen> {
  late final CategoryCubit _categoryCubit;

  @override
  void initState() {
    super.initState();
    _categoryCubit = GetIt.I<CategoryCubit>()
      ..fetchCategories()
      ..setRemainingBudget(widget.monthlySalary);
  }

  @override
  void dispose() {
    _categoryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _categoryCubit,
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          foregroundColor: AppColor.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColor.primaryColor,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.tr.distributeYourBudget,
            style: GoogleFonts.cairo(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.textPrimary,
            ),
          ),
        ),
        body: Column(
          children: [
            BuildHeaderSection(
              monthlySalary: widget.monthlySalary,
              currency: widget.currency,
            ),
            Expanded(
              child: CategorySlicingCardList(
                monthlySalary: widget.monthlySalary,
                currency: widget.currency,
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomSetUpBottomBar(),
      ),
    );
  }
}
