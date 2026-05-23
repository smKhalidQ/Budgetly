import 'package:flutter/material.dart';

class ResponsiveManager {
  static final ResponsiveManager instance = ResponsiveManager._internal();
  ResponsiveManager._internal();

  static const double _baseWidth = 430.0;
  static const double _baseHeight = 932.0;

  late double _screenWidth;
  late double _screenHeight;
  late double _scaleWidth;
  late double _scaleHeight;

  bool get isTablet => _screenWidth >= 600;
  double get scaleWidth => _scaleWidth;

  void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _scaleWidth = _screenWidth / _baseWidth;
    _scaleHeight = _screenHeight / _baseHeight;
  }

  double w(num value) => value * _scaleWidth;
  double h(num value) => value * _scaleHeight;
}

extension ResponsiveNum on num {
  double get w => ResponsiveManager.instance.w(this);
  double get h => ResponsiveManager.instance.h(this);
}

double adaptiveW(num mobile, num tablet) {
  final r = ResponsiveManager.instance;
  return (r.isTablet ? tablet : mobile) * r.scaleWidth;
}

double adaptiveH(num mobile, num tablet) {
  final r = ResponsiveManager.instance;
  return (r.isTablet ? tablet : mobile).toDouble();
}
