import 'package:budget_buddy/core/responsive/responsive_manager.dart';
import 'package:flutter/material.dart';

class IconPickerWidget extends StatelessWidget {
  final IconData currentIcon;
  final Color currentColor;
  final Function(IconData) onIconSelected;

  const IconPickerWidget({
    super.key,
    required this.currentIcon,
    required this.currentColor,
    required this.onIconSelected,
  });

  static const List<IconData> iconOptions = [
    // Housing
    Icons.home_rounded,
    Icons.bolt_rounded,
    Icons.wifi_rounded,
    Icons.build_rounded,
    Icons.chair_rounded,
    // Food & Drinks
    Icons.restaurant_rounded,
    Icons.local_grocery_store_rounded,
    Icons.coffee_rounded,
    Icons.fastfood_rounded,
    Icons.delivery_dining_rounded,
    // Transportation
    Icons.local_gas_station_rounded,
    Icons.directions_bus_rounded,
    Icons.local_parking_rounded,
    Icons.local_taxi_rounded,
    Icons.car_repair_rounded,
    Icons.directions_car_rounded,
    // Healthcare
    Icons.medical_services_rounded,
    Icons.medication_rounded,
    Icons.fitness_center_rounded,
    Icons.local_pharmacy_rounded,
    Icons.sentiment_satisfied_rounded,
    // Entertainment
    Icons.movie_rounded,
    Icons.sports_esports_rounded,
    Icons.play_circle_rounded,
    Icons.menu_book_rounded,
    Icons.celebration_rounded,
    // Other / Shopping
    Icons.shopping_bag_rounded,
    Icons.card_giftcard_rounded,
    Icons.subscriptions_rounded,
    Icons.spa_rounded,
    Icons.school_rounded,
    // Saving
    Icons.shield_rounded,
    Icons.trending_up_rounded,
    Icons.flight_rounded,
    Icons.beach_access_rounded,
    Icons.savings_rounded,
    // General
    Icons.category_rounded,
    Icons.smartphone,
    Icons.computer,
    Icons.tv,
    Icons.airplanemode_active,
    Icons.hotel,
    Icons.sports,
    Icons.book,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: iconOptions.map((icon) {
        final isSelected = currentIcon.codePoint == icon.codePoint;
        return GestureDetector(
          onTap: () => onIconSelected(icon),
          child: Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? currentColor.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected ? currentColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? currentColor : Colors.grey[600],
              size: 24.sp,
            ),
          ),
        );
      }).toList(),
    );
  }
}
