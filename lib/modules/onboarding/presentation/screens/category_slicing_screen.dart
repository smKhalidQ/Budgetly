import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/onboarding/presentation/widgets/build_header_section.dart';
import 'package:budget_buddy/modules/onboarding/presentation/widgets/category_slicing_card_list.dart';
import 'package:budget_buddy/modules/onboarding/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CategorySlicingScreen extends StatelessWidget {
  final int monthlySalary;
  final String currency;

  const CategorySlicingScreen({
    super.key,
    required this.monthlySalary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCubit>(
      create: (_) => GetIt.I<CategoryCubit>()
        ..fetchCategories()
        ..setRemainingBudget(monthlySalary),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColor.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColor.backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColor.primaryColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              BuildHeaderSection(
                monthlySalary: monthlySalary,
                currency: currency,
              ),
              Expanded(
                child: CategorySlicingCardList(
                  monthlySalary: monthlySalary,
                  currency: currency,
                ),
              ),
            ],
          ),
          bottomNavigationBar: CustomSetUpBottomBar(
            categoryCubit: context.read<CategoryCubit>(),
          ),
        ),
      ),
    );
  }
}
