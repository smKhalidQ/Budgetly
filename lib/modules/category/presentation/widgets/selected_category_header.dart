import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/theming/app_radius.dart';
import 'package:budget_buddy/core/theming/app_text_style.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/category/presentation/cubits/category_cubit.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';
import 'package:budget_buddy/core/widgets/pickers/color_picker_widget.dart';
import 'package:budget_buddy/core/widgets/pickers/icon_picker_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectedCategoryHeaderWidget extends StatelessWidget {
  final Category category;
  final Color categoryColor;
  final double remainingAmount;
  final bool showPieChart;
  final VoidCallback onTogglePieChart;
  final ValueChanged<Category> onCategoryUpdated;

  const SelectedCategoryHeaderWidget({
    super.key,
    required this.category,
    required this.categoryColor,
    required this.remainingAmount,
    required this.showPieChart,
    required this.onTogglePieChart,
    required this.onCategoryUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue =
        (category.spentAmount / category.allocatedAmount).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Row(
              children: [
                _buildCategoryIcon(progressValue),
                SizedBox(width: 16.w),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryInfo(),
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: showPieChart
                ? BlocBuilder<SubcategoryCubit, SubcategoryState>(
                    buildWhen: (prev, curr) =>
                        prev.subcategories != curr.subcategories ||
                        prev.spentBySubcategory != curr.spentBySubcategory ||
                        prev.generalSpent != curr.generalSpent,
                    builder: (context, state) {
                      final subs = state.subcategories
                          .where((s) => s.parentCategoryId == category.id)
                          .toList();
                      return _buildPieChart(
                        subs,
                        state.spentBySubcategory,
                        state.generalSpent,
                      );
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(
    List<Subcategory> subs,
    Map<int, double> spentBySub,
    double generalSpent,
  ) {
    const palette = [
      Color(0xFF4F959D),
      Color(0xFFEF6C6C),
      Color(0xFFF2A65A),
      Color(0xFF6C8EEF),
      Color(0xFF9B6CEF),
      Color(0xFF5BBF8A),
      Color(0xFFE5C454),
      Color(0xFFEF6CB0),
    ];

    final entries = <({String name, double amount})>[
      for (final s in subs)
        if ((spentBySub[s.id] ?? 0) > 0)
          (name: s.name, amount: spentBySub[s.id]!),
      if (generalSpent > 0) (name: 'General', amount: generalSpent),
    ];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        children: [
          Divider(color: AppColor.dividerColor, height: 1),
          SizedBox(height: 16.h),
          if (entries.isEmpty)
            _buildEmptyChart()
          else
            SizedBox(
              width: 190.w,
              height: 190.w,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 30.r,
                  sections: [
                    for (var i = 0; i < entries.length; i++)
                      PieChartSectionData(
                        value: entries[i].amount,
                        color: palette[i % palette.length],
                        radius: 58.r,
                        titlePositionPercentageOffset: 0.55,
                        title:
                            '${entries[i].name}\n${entries[i].amount.toStringAsFixed(0)}',
                        titleStyle: GoogleFonts.cairo(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Row(
      children: [
        SizedBox(
          width: 140.w,
          height: 140.w,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 28.r,
              sections: [
                PieChartSectionData(
                  value: 1,
                  color: categoryColor.withValues(alpha: 0.2),
                  radius: 42.r,
                  title: '',
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          "No spending yet",
          style: GoogleFonts.cairo(
            color: AppColor.textSecondary,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryIcon(double progressValue) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60.w,
          height: 60.w,
          child: CircularProgressIndicator(
            value: progressValue,
            strokeWidth: 5,
            backgroundColor: AppColor.surfaceMuted,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressValue >= 1 ? AppColor.expenseColor : categoryColor,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.r),
          decoration:
              BoxDecoration(color: categoryColor, shape: BoxShape.circle),
          child: Icon(
            IconData(int.parse(category.icon), fontFamily: 'MaterialIcons'),
            color: Colors.white,
            size: 24.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category.name,
            style: GoogleFonts.cairo(
                fontSize: 18.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: remainingAmount < 0
                ? AppColor.expenseColor.withValues(alpha: 0.15)
                : categoryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppRadius.md.r),
          ),
          child: Text(
            "\$${remainingAmount.toStringAsFixed(0)} ${remainingAmount < 0 ? 'over' : 'left'}",
            style: GoogleFonts.cairo(
              color: AppColor.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _iconBtn(
          icon: Icons.edit_outlined,
          color: AppColor.textSecondary,
          onTap: () => _showEditDialog(context),
        ),
        SizedBox(width: 8.w),
        _iconBtn(
          icon: Icons.pie_chart,
          color: categoryColor,
          onTap: onTogglePieChart,
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context) {
    final cubit = CategoryCubit.get(context);
    showDialog(
      context: context,
      builder: (_) => _EditCategoryDialog(
        category: category,
        cubit: cubit,
        onSaved: onCategoryUpdated,
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: const BoxDecoration(
          color: AppColor.surfaceMuted,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
    );
  }
}

// ─── Edit Category Dialog ─────────────────────────────────────────────────────

class _EditCategoryDialog extends StatefulWidget {
  final Category category;
  final CategoryCubit cubit;
  final ValueChanged<Category> onSaved;

  const _EditCategoryDialog({
    required this.category,
    required this.cubit,
    required this.onSaved,
  });

  @override
  State<_EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<_EditCategoryDialog> {
  late final TextEditingController _nameCtrl;
  late final PageController _pageCtrl;
  late Color _color;
  late String _icon;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category.name);
    _pageCtrl = PageController();
    _color = parseColorFromString(widget.category.color);
    _icon = widget.category.icon;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Edit Category",
        style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (p) => setState(() => _page = p),
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Select Icon",
                          style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10.h),
                        IconPickerWidget(
                          key: ValueKey(_icon),
                          currentIcon: IconData(
                            int.tryParse(_icon) ?? Icons.category.codePoint,
                            fontFamily: 'MaterialIcons',
                          ),
                          currentColor: _color,
                          onIconSelected: (icon) =>
                              setState(() => _icon = icon.codePoint.toString()),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Select Color",
                          style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10.h),
                        ColorPickerWidget(
                          key: ValueKey(_color.toARGB32()),
                          currentColor: _color,
                          onColorSelected: (c) => setState(() => _color = c),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2,
                (i) => Container(
                  width: 8.w,
                  height: 8.w,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _page == i
                        ? AppColor.primaryColor
                        : Colors.grey.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (_nameCtrl.text.trim().isEmpty) return;
            final colorHex =
                '0x${_color.toARGB32().toRadixString(16).padLeft(8, '0')}';
            final updated = widget.category.copyWith(
              name: _nameCtrl.text.trim(),
              icon: _icon,
              color: colorHex,
            );
            widget.cubit.updateCategoryData(widget.category.id!, updated);
            widget.onSaved(updated);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
