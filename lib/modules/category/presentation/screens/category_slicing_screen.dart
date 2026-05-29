import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../widgets/slicing_screen/build_header_section.dart';
import '../widgets/slicing_screen/category_slicing_card_list.dart';
import '../widgets/slicing_screen/custom_bottom_nav_bar.dart';

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
          body: SafeArea(
            child: Column(
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
          ),
          bottomNavigationBar: CustomSetUpBottomBar(
            categoryCubit: context.read<CategoryCubit>(),
          ),
        ),
      ),
    );
  }
}
