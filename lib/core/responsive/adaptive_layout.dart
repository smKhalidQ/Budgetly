import 'package:flutter/material.dart';
import 'responsive_manager.dart';

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

  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isTabletLandscape(context)) {
      return width * tabletContentWidthFactor;
    }
    return width;
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
    if (!ResponsiveManager.instance.isTablet) return child;

    return ColoredBox(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AdaptiveLayoutConfig.getMaxContentWidth(context),
          ),
          child: child,
        ),
      ),
    );
  }
}
