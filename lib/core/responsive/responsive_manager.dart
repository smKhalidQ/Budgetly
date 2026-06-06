import 'package:flutter/material.dart';

import 'adaptive_layout.dart';

class ResponsiveManager {
  static ResponsiveManager? _instance;
  static ResponsiveManager get instance {
    assert(_instance != null, 'ResponsiveManager not initialized. Call initialize() first.');
    return _instance!;
  }

  static const double _baseWidth = 430.0;
  static const double _baseHeight = 932.0;

  late double _effectiveWidth;
  late double _scaleWidth;
  late double _scaleHeight;
  late double _screenWidth;
  late double _screenHeight;
  late double _shortestSide;
  late bool _isTabletLandscape;

  ResponsiveManager._();

  static void initialize(BuildContext context) {
    if (_instance == null) {
      _instance = ResponsiveManager._();
      _instance!._calculate(context);
    }
  }

  void forceRecalculate(BuildContext context) {
    _calculate(context);
  }

  void _calculate(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _shortestSide = size.shortestSide;
    _isTabletLandscape = AdaptiveLayoutConfig.isTabletLandscape(context);

    final maxContentWidth = AdaptiveLayoutConfig.getMaxContentWidth(context);
    if (maxContentWidth != null && _screenWidth > maxContentWidth) {
      _effectiveWidth = maxContentWidth;
    } else {
      _effectiveWidth = _screenWidth;
    }

    _scaleWidth = _effectiveWidth / _baseWidth;
    _scaleHeight = _screenHeight / _baseHeight;
  }

  double get effectiveWidth => _effectiveWidth;
  double get scaleWidth => _scaleWidth;
  double get scaleHeight => _scaleHeight;
  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;
  bool get isTabletLandscape => _isTabletLandscape;
  bool get isTablet => _shortestSide >= AdaptiveLayoutConfig.tabletBreakpoint && !_isTabletLandscape;

  double w(num value) => value * _scaleWidth;
  double h(num value) => value * _scaleHeight;
  double sp(num value) => value * _scaleWidth;
  double r(num value) => value * _scaleWidth;

  double adaptiveW(num mobile, num tablet) {
    final value = isTablet ? tablet : mobile;
    return value * _scaleWidth;
  }

  double adaptiveH(num mobile, num tablet) {
    final value = isTablet ? tablet : mobile;
    return value * _scaleHeight;
  }

  double adaptiveSp(num mobile, num tablet) {
    final value = isTablet ? tablet : mobile;
    return value * _scaleWidth;
  }

  double adaptiveR(num mobile, num tablet) {
    final value = isTablet ? tablet : mobile;
    return value * _scaleWidth;
  }

  static bool get isInitialized => _instance != null;
}

extension ResponsiveNum on num {
  double get w => ResponsiveManager.instance.w(this);
  double get h => ResponsiveManager.instance.h(this);
  double get sp => ResponsiveManager.instance.sp(this);
  double get r => ResponsiveManager.instance.r(this);
}

double adaptiveW(num mobile, num tablet) => ResponsiveManager.instance.adaptiveW(mobile, tablet);
double adaptiveH(num mobile, num tablet) => ResponsiveManager.instance.adaptiveH(mobile, tablet);
double adaptiveSp(num mobile, num tablet) => ResponsiveManager.instance.adaptiveSp(mobile, tablet);
double adaptiveR(num mobile, num tablet) => ResponsiveManager.instance.adaptiveR(mobile, tablet);
