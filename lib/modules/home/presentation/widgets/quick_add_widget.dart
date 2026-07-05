import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/home/presentation/cubits/quick_add_cubit.dart';
import 'package:budget_buddy/modules/home/presentation/cubits/quick_add_state.dart';
import 'package:budget_buddy/modules/transaction/presentation/screens/add_transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_it/get_it.dart';

class QuickAddWidget extends StatelessWidget {
  const QuickAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<QuickAddCubit>()..load(),
      child: BlocBuilder<QuickAddCubit, QuickAddState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
                child: Text(
                  'Quick Add',
                  style: GoogleFonts.cairo(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 92.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (_, i) => _QuickAddTile(
                    item: state.items[i],
                    onAdded: () {
                      context.read<QuickAddCubit>().load();
                      context.read<CategoryCubit>().fetchCategories();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _QuickAddTile extends StatelessWidget {
  final QuickAddItem item;
  final VoidCallback onAdded;

  const _QuickAddTile({required this.item, required this.onAdded});

  @override
  Widget build(BuildContext context) {
    final color = parseColorFromString(item.color);

    return GestureDetector(
      onTap: () => AddTransactionScreen.show(
        context,
        initialCategoryId: item.category.id,
        initialSubcategoryId: item.subcategory?.id,
        onSuccess: onAdded,
      ),
      child: Container(
        width: 76.w,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconData(int.parse(item.icon), fontFamily: 'MaterialIcons'),
                color: color,
                size: 16.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                height: 1.1,
                color: AppColor.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
