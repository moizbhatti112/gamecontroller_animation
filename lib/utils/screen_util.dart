import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension ScreenUtils on BuildContext {
  // Get screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  // Get screen width
  double get screenWidth => MediaQuery.sizeOf(this).width;

  // Get screen height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Get responsive height percentage
  double height(double percentage) => screenHeight * percentage;

  // Get responsive width percentage
  double width(double percentage) => screenWidth * percentage;

  // Check if device is mobile
  bool get isMobile => screenWidth < 650;

  // Check if device is tablet
  bool get isTablet => screenWidth >= 650 && screenWidth < 1100;

  // Check if device is desktop
  bool get isDesktop => screenWidth >= 1100;

  // Get safe area padding
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  // Get status bar height
  double get statusBarHeight => MediaQuery.paddingOf(this).top;

  // Get bottom safe area height
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  // Get current screen orientation
  Orientation get orientation => MediaQuery.of(this).orientation;

  // Set screen orientation to portrait only
  Future<void> setPortraitOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Set screen orientation to landscape only
  Future<void> setLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Reset to system default orientation
  Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}

// Optional: Create a responsive text scaling utility
extension ResponsiveText on BuildContext {
  // Scale text based on screen size
  double responsiveFont(double size) {
    if (isMobile) return size; 
    if (isTablet) return size * 1.2;
    return size * 1.4; // Desktop
  }
}