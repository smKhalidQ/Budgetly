import 'package:flutter/material.dart';

class AdaptiveLayoutConfig {
  static const double tabletBreakpoint = 600.0;
  static const double tabletContentWidthFactor = 0.6;

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= tabletBreakpoint;
  }

  static bool isTabletLandscape(BuildContext context) {
    final mq = MediaQuery.of(context);
    return mq.size.shortestSide >= tabletBreakpoint &&
        mq.orientation == Orientation.landscape;
  }

  static double? getMaxContentWidth(BuildContext context) {
    if (!isTabletLandscape(context)) return null;
    final width = MediaQuery.of(context).size.width;
    return width * tabletContentWidthFactor;
  }
}

class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final maxWidth = AdaptiveLayoutConfig.getMaxContentWidth(context);
    if (maxWidth == null) return child;

    return ColoredBox(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
