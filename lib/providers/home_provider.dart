import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _centeredImageIndex = 0;
  bool _boxExpanded = true;
  bool _listviewAnimated = false;

  // Getters
  int get centeredImageIndex => _centeredImageIndex;
  bool get boxexpanded => _boxExpanded;
  bool get listviewanimated => _listviewAnimated;

  // Method to toggle box expansion
  void checkbox() {
    _boxExpanded = !_boxExpanded;
    notifyListeners();
  }

  // Method to toggle listview animation
  void checklistview() {
    _listviewAnimated = !_listviewAnimated;
    notifyListeners();
  }

  // Method to update centered image index
  void updateCenteredImageIndex(int newIndex) {
    if (_centeredImageIndex != newIndex) {
      _centeredImageIndex = newIndex;
      notifyListeners();
      print('Container color changed to index: $newIndex');
    }
  }

  // Method to handle scroll logic and update centered image index
  void handleScroll({
    required ScrollController scrollController,
    required BuildContext context,
    required double screenWidth,
    required double cardWidth,
  }) {
    // Don't process scroll if box is expanded
    if (!scrollController.hasClients || _boxExpanded) {
      return;
    }

    final screenCenter = screenWidth / 2;
    final cardMargin = 8.0;
    final totalCardWidth = cardWidth + (cardMargin * 2);
    final listViewPadding = 16.0;
    final scrollOffset = scrollController.offset;

    int closestCardIndex = _centeredImageIndex;
    double minDistanceToCenter = double.infinity;

    // Find the card closest to the center
    for (int i = 0; i < 5; i++) {
      final cardLeftEdge = (i * totalCardWidth) + listViewPadding - scrollOffset;
      final cardCenterX = cardLeftEdge + (cardWidth / 2);
      final distanceToCenter = (cardCenterX - screenCenter).abs();

      if (distanceToCenter < minDistanceToCenter) {
        minDistanceToCenter = distanceToCenter;
        closestCardIndex = i;
      }
    }

    // Update the centered image index if it changed
    updateCenteredImageIndex(closestCardIndex);
  }
}