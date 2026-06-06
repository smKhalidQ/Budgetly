import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
              style: GoogleFonts.poppins(color: Colors.red, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          );
        }

        final categories = state.categories;

        if (categories.isEmpty) {
          return Center(
            child: Text(
              t.noCategoriesFound,
              style: GoogleFonts.cairo(color: Colors.grey[500], fontSize: 15),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Container(
          margin: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              itemCount: categories.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 74,
                endIndent: 20,
                color: Colors.grey.shade100,
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
            ),
          ),
        );
      },
    );
  }
}
