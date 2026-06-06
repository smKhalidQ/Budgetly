import 'package:budget_buddy/core/theming/app_color.dart';
import 'package:budget_buddy/core/utilities/constants.dart';
import 'package:budget_buddy/modules/category/domain/models/category.dart';
import 'package:budget_buddy/modules/subcategory/domain/models/subcategory.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_cubit.dart';
import 'package:budget_buddy/modules/subcategory/presentation/cubits/subcategory_state.dart';
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

  const SelectedCategoryHeaderWidget({
    super.key,
    required this.category,
    required this.categoryColor,
    required this.remainingAmount,
    required this.showPieChart,
    required this.onTogglePieChart,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue =
        (category.spentAmount / category.allocatedAmount).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                _buildCategoryIcon(progressValue),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buildCategoryInfo(), _buildActionButtons()],
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
                        prev.subcategories != curr.subcategories,
                    builder: (context, state) {
                      final subs = state.subcategories
                          .where((s) => s.parentCategoryId == category.id)
                          .toList();
                      return _buildPieChart(subs);
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(List<Subcategory> subs) {
    final spentSubs = subs
        .map((s) => (
              sub: s,
              amount: double.tryParse(s.spentAmount ?? '0') ?? 0.0,
              color: parseColorFromString(s.color),
            ))
        .where((e) => e.amount > 0)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Divider(color: Colors.grey.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 16),
          if (spentSubs.isEmpty)
            _buildEmptyChart()
          else
            Row(
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 28,
                      sections: spentSubs
                          .map(
                            (e) => PieChartSectionData(
                              value: e.amount,
                              color: e.color,
                              radius: 42,
                              title: '',
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: spentSubs
                        .map((e) => _buildLegendItem(
                              e.sub.name,
                              e.amount,
                              e.color,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Row(
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 28,
              sections: [
                PieChartSectionData(
                  value: 1,
                  color: categoryColor.withValues(alpha: 0.2),
                  radius: 42,
                  title: '',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          "No spending yet",
          style: GoogleFonts.roboto(
            color: AppColor.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String name, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.roboto(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            amount.toStringAsFixed(0),
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon(double progressValue) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: progressValue,
            strokeWidth: 5,
            backgroundColor: Colors.grey.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(
              progressValue >= 1 ? Colors.red : categoryColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration:
              BoxDecoration(color: categoryColor, shape: BoxShape.circle),
          child: Icon(
            IconData(int.parse(category.icon), fontFamily: 'MaterialIcons'),
            color: Colors.white,
            size: 24,
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: remainingAmount < 0
                ? Colors.red.withValues(alpha: 0.15)
                : categoryColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "\$${remainingAmount.toStringAsFixed(0)} ${remainingAmount < 0 ? 'over' : 'left'}",
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return _iconBtn(
      icon: Icons.pie_chart,
      color: categoryColor,
      onTap: onTogglePieChart,
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
