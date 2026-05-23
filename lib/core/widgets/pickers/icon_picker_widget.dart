import 'package:flutter/material.dart';

class IconPickerWidget extends StatelessWidget {
  final IconData currentIcon;
  final Color currentColor;
  final Function(IconData) onIconSelected;

  const IconPickerWidget({
    Key? key,
    required this.currentIcon,
    required this.currentColor,
    required this.onIconSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<IconData> iconOptions = [
      Icons.category,
      Icons.shopping_bag,
      Icons.shopping_cart,
      Icons.restaurant,
      Icons.local_cafe,
      Icons.directions_car,
      Icons.directions_bus,
      Icons.local_taxi,
      Icons.local_hospital,
      Icons.school,
      Icons.book,
      Icons.movie,
      Icons.sports_esports,
      Icons.fitness_center,
      Icons.sports,
      Icons.home,
      Icons.house,
      Icons.smartphone,
      Icons.computer,
      Icons.tv,
      Icons.card_giftcard,
      Icons.airplanemode_active,
      Icons.hotel,
      Icons.beach_access,
      Icons.savings,
      Icons.fastfood

    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: iconOptions.map((icon) {
        final isSelected = currentIcon == icon;
        return GestureDetector(
          onTap: () => onIconSelected(icon),
          child:Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? currentColor.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? currentColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? currentColor : Colors.grey[600],
              size: 24,
            ),
          ),
        );
      }).toList(),
    );
  }
}