import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/l10n/translation.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_state.dart';
import 'build_slicing_category_card.dart';

class CategorySlicingCardList extends StatefulWidget {
  const CategorySlicingCardList({
    super.key,
    required this.monthlySalary,
    required this.currency,
  });

  final int monthlySalary;
  final String currency;

  @override
  State<CategorySlicingCardList> createState() =>
      _CategorySlicingCardListState();
}

class _CategorySlicingCardListState extends State<CategorySlicingCardList> {
  final Map<int, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(int index) {
    return _controllers.putIfAbsent(index, TextEditingController.new);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tr;

    return BlocBuilder<CategoryCubit, CategoryState>(
      buildWhen: (prev, curr) =>
          prev.categories != curr.categories || prev.status != curr.status,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
            ),
          );
        }

        if (state.hasError) {
          return Center(
            child: Text(
              state.errorMessage ?? '',
              style: GoogleFonts.cairo(
                  color: AppColor.expenseColor, fontSize: 15.sp),
              textAlign: TextAlign.center,
            ),
          );
        }

        final categories = state.categories;

        if (categories.isEmpty) {
          return Center(
            child: Text(
              t.noCategoriesFound,
              style: GoogleFonts.cairo(
                  color: AppColor.textSecondary, fontSize: 15.sp),
              textAlign: TextAlign.center,
            ),
          );
        }

        // Flat list — rows sit directly on the screen background, separated
        // by hairline dividers (no card / white sheet wrapper).
        return ListView.separated(
          padding: EdgeInsets.only(top: 4.h, bottom: 20.h),
          itemCount: categories.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            indent: 74.w,
            endIndent: 20.w,
            color: AppColor.dividerColor,
          ),
          itemBuilder: (context, index) {
            return SlicingCategoryCard(
              category: categories[index],
              controller: _controllerFor(index),
              index: index,
              monthlySalary: widget.monthlySalary,
              currency: widget.currency,
            );
          },
        );
      },
    );
  }
}
