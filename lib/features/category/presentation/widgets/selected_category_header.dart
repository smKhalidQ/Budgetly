import 'package:flutter/material.dart';
import 'package:budget_buddy/core/domain/entities/category_entity.dart';
import '../../../../core/themes/app_color.dart';

class SelectedCategoryHeaderWidget extends StatelessWidget {
  final CategoryEntity categoryEntity;
  final Color categoryColor;
  final double remainingAmount;
  final bool showPieChart;
  final VoidCallback onTogglePieChart;
  final VoidCallback onEditCategory;

  const SelectedCategoryHeaderWidget({
    Key? key,
    required this.categoryEntity,
    required this.categoryColor,
    required this.remainingAmount,
    required this.showPieChart,
    required this.onTogglePieChart,
    required this.onEditCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentSpent = categoryEntity.storedSpentAmount / categoryEntity.allocatedAmount!;
    final double progressValue = percentSpent.clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: Icon and Category name
          Row(
            children: [
              _buildCategoryIcon(progressValue),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryInfo(),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),

          // Optional pie chart
          if (showPieChart)
            Container(
              height: 180,
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Pie Chart Here",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
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
            backgroundColor: Colors.grey.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(
              progressValue >= 1 ? Colors.red : categoryColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: categoryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            IconData(
              int.parse(categoryEntity.categoryIcon!),
              fontFamily: 'MaterialIcons',
            ),
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
        Text(
          categoryEntity.categoryName!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: remainingAmount < 0
                ? Colors.red.withOpacity(0.15)
                : categoryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "\$${remainingAmount.toStringAsFixed(0)} ${remainingAmount < 0 ? 'over' : 'left'}",
            style: TextStyle(
              color: Colors.black.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        InkWell(
          onTap: onTogglePieChart,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.pie_chart,
              color: categoryColor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onEditCategory,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.edit,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}