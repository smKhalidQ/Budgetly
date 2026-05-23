import 'package:flutter/material.dart';

extension HexColorExtension on String {
  Color toColor() {
    try {
      final hex = replaceAll('#', '').replaceAll('Color(', '').replaceAll(')', '');
      if (hex.startsWith('0x') || hex.startsWith('0X')) {
        return Color(int.parse(hex));
      }
      return Color(int.parse('FF${hex.padLeft(6, '0')}', radix: 16));
    } catch (_) {
      return Colors.blue;
    }
  }
}
