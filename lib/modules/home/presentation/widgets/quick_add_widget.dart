import 'package:slice_pay/core/extensions/icon_extensions.dart';
import 'package:slice_pay/core/responsive/responsive_manager.dart';
import 'package:slice_pay/core/theming/app_color.dart';
import 'package:slice_pay/core/utilities/constants.dart';
import 'package:slice_pay/l10n/translation.dart';
import 'package:slice_pay/modules/category/presentation/cubits/category_cubit.dart';
import 'package:slice_pay/modules/home/presentation/cubits/quick_add_cubit.dart';
import 'package:slice_pay/modules/home/presentation/cubits/quick_add_state.dart';
import 'package:slice_pay/modules/transaction/presentation/screens/add_transaction_screen.dart';
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
                  context.tr.quickAdd,
                  style: GoogleFonts.cairo(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 46.h,
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
        subcategoryPreselected: true,
        onSuccess: onAdded,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26.w,
              height: 26.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon.toIconData(),
                color: color,
                size: 14.sp,
              ),
            ),
            SizedBox(width: 8.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 72.w),
              child: Text(
                item.label(context.tr),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
