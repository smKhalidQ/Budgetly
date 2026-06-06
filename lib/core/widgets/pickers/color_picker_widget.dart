import 'package:flutter/material.dart';

class ColorPickerWidget extends StatelessWidget {
  final Color currentColor;
  final Function(Color) onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
  });

  static const List<Color> colorOptions = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Color(0xff1565c0), // Housing blue
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Color(0xff2e7d32), // Healthcare green
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Color(0xfff9a825), // Saving amber
    Colors.orange,
    Color(0xfff57c00), // Food orange
    Colors.deepOrange,
    Colors.brown,
    Color(0xff546e7a), // Transportation blue-grey
    Colors.blueGrey,
    Colors.grey,
    Color(0xff90a4ae), // Other grey
    Color(0xff6a1b9a), // Entertainment purple
  ];

  static bool _match(Color a, Color b) {
    return (a.r * 255).round() == (b.r * 255).round() &&
        (a.g * 255).round() == (b.g * 255).round() &&
        (a.b * 255).round() == (b.b * 255).round() &&
        (a.a * 255).round() == (b.a * 255).round();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colorOptions.map((color) {
        final isSelected = _match(currentColor, color);
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: color.withValues(alpha: 0.6),
                          blurRadius: 8,
                          spreadRadius: 2)
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
