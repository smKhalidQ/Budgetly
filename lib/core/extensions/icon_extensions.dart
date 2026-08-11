import 'package:flutter/material.dart';
import 'package:slice_pay/core/widgets/pickers/icon_picker_widget.dart';

extension IconCodeExtension on String {
  IconData toIconData() {
    final codePoint = int.tryParse(this);
    for (final icon in IconPickerWidget.iconOptions) {
      if (icon.codePoint == codePoint) return icon;
    }
    return Icons.category_rounded;
  }
}
