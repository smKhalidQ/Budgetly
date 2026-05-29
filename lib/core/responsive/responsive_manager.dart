import 'package:flutter/material.dart';

class ResponsiveManager {
  static final ResponsiveManager instance = ResponsiveManager._internal();
  ResponsiveManager._internal();

  static const double _baseWidth = 430.0;
  static const double _baseHeight = 932.0;
  static const double _tabletBreakpoint = 600.0;

  late double _screenWidth;
  late double _screenHeight;
  late double _scaleWidth;
  late double _scaleHeight;
  late double _scaleSp;

  bool get isTablet => _screenWidth >= _tabletBreakpoint;
  double get scaleWidth => _scaleWidth;
  double get scaleHeight => _scaleHeight;

  void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _scaleWidth = _screenWidth / _baseWidth;
    _scaleHeight = _screenHeight / _baseHeight;
    _scaleSp = (_scaleWidth + _scaleHeight) / 2;
  }

  double w(num value) => value * _scaleWidth;
  double h(num value) => value * _scaleHeight;
  double sp(num value) => value * _scaleSp;
  double r(num value) => value * _scaleWidth;
}

extension ResponsiveNum on num {
  double get w => ResponsiveManager.instance.w(this);
  double get h => ResponsiveManager.instance.h(this);
  double get sp => ResponsiveManager.instance.sp(this);
  double get r => ResponsiveManager.instance.r(this);
}

double adaptiveW(num mobile, num tablet) {
  final rm = ResponsiveManager.instance;
  return (rm.isTablet ? tablet : mobile) * rm.scaleWidth;
}

double adaptiveH(num mobile, num tablet) {
  final rm = ResponsiveManager.instance;
  return (rm.isTablet ? tablet : mobile) * rm.scaleHeight;
}

double adaptiveSp(num mobile, num tablet) {
  final rm = ResponsiveManager.instance;
  return rm.sp(rm.isTablet ? tablet : mobile);
}

double adaptiveR(num mobile, num tablet) {
  final rm = ResponsiveManager.instance;
  return rm.r(rm.isTablet ? tablet : mobile);
}
