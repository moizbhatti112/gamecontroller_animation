import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamecontroller_animation/constants/colors.dart';
import 'package:gamecontroller_animation/providers/nav_provider.dart';
import 'package:gamecontroller_animation/screens/account.dart';
import 'package:gamecontroller_animation/screens/home.dart';
import 'package:gamecontroller_animation/utils/screen_util.dart';

import 'package:provider/provider.dart';

class MainNav extends StatelessWidget {
  const MainNav({super.key});

  static final List<Widget> _screens = [const HomeScreen(), AccountScreen()];

  @override
  Widget build(BuildContext context) {
    debugPrint("🏠 MainNav built");

    return Scaffold(
      body: Stack(
        children: [
          // Use Selector instead of Consumer for more granular control
          Selector<BottomNavProvider, int>(
            selector: (context, navProvider) => navProvider.selectedIndex,
            builder: (context, selectedIndex, child) {
              debugPrint("📱 IndexedStack rebuilt with index: $selectedIndex");
              return Positioned.fill(
                child: PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, result) async {
                    if (!didPop) {
                      final navProvider = context.read<BottomNavProvider>();
                      if (navProvider.selectedIndex == 0) {
                        await SystemNavigator.pop();
                      } else {
                        navProvider.setIndex(0);
                      }
                    }
                  },
                  child: IndexedStack(
                    index: selectedIndex,
                    children: MainNav._screens,
                  ),
                ),
              );
            },
          ),

          // Static positioned navbar - should never rebuild
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _StaticBottomNavBar(),
          ),
        ],
      ),
    );
  }
}

// Separate static widget for navbar to prevent rebuilds
class _StaticBottomNavBar extends StatelessWidget {
  const _StaticBottomNavBar();

  @override
  Widget build(BuildContext context) {
    debugPrint("🔧 Static NavBar built (should only happen once)");

    return BottomNavBar(
      onItemTapped: (index) {
        context.read<BottomNavProvider>().setIndex(index);
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final ValueChanged<int> onItemTapped;

  BottomNavBar({super.key, required this.onItemTapped});
  
  final items = [
    const _NavBarItem(label: 'Home', icon: Icons.home),
    const _NavBarItem(label: 'Groups', icon: Icons.person),
    const _NavBarItem(label: 'Practices', icon: Icons.settings),
    const _NavBarItem(label: 'Journal', icon: Icons.bookmark),
    // const _NavBarItem(
    //   label: 'Resources',
    //   icon: Icons.library_books,
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint("Navbar rebuilt");
    final isLandscape = context.orientation == Orientation.landscape;

    final double iconSize = isLandscape
        ? context.width(0.045)
        : context.width(0.06);
    final double textSize = isLandscape
        ? context.responsiveFont(8)
        : context.responsiveFont(10);
    final double verticalPadding = isLandscape
        ? context.height(0.00)
        : context.height(0.0);
    final double containerPadding = isLandscape
        ? context.height(0.008)
        : context.height(0.007);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.width(0.06),
          vertical: 10,
        ),
        child: Container(
          height: isLandscape ? context.height(0.2) : context.height(0.075),
          decoration: BoxDecoration(
            color: navcolor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 204, 213, 224),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              return Expanded(
                child: _SmartNavBarItem(
                  item: items[index],
                  index: index,
                  onTap: () => onItemTapped(index),
                  iconSize: iconSize,
                  textSize: textSize,
                  verticalPadding: verticalPadding,
                  containerPadding: containerPadding,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _SmartNavBarItem extends StatelessWidget {
  final _NavBarItem item;
  final int index;
  final VoidCallback onTap;
  final double iconSize;
  final double textSize;
  final double verticalPadding;
  final double containerPadding;

  const _SmartNavBarItem({
    required this.item,
    required this.index,
    required this.onTap,
    required this.iconSize,
    required this.textSize,
    required this.verticalPadding,
    required this.containerPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.orientation == Orientation.landscape;

    return GestureDetector(
      onTap: onTap,
      // SIRF YE SPECIFIC ITEM REBUILD HOGA
      child: Selector<BottomNavProvider, bool>(
        selector: (context, navProvider) => navProvider.selectedIndex == index,
        builder: (context, isSelected, child) {
          debugPrint("🔄 Item $index rebuilt - Selected: $isSelected");

          return isSelected
              ? Padding(
                  padding: EdgeInsets.all(containerPadding),
                  child: AnimatedContainer(
                    height: isLandscape
                        ? context.height(0.18)
                        : context.height(0.07),
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      vertical: verticalPadding,
                      horizontal: 0,
                    ),
                    decoration: BoxDecoration(
                      // color: const Color.fromARGB(255, 224, 128, 2),
                      borderRadius: BorderRadius.circular(54),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StaticIcon(
                          icon: item.icon,
                          color: iconcolor,
                          iconSize: iconSize,
                        ),
                        // _StaticText(
                        //   label: item.label,
                        //   color: whiteColor,
                        //   textSize: textSize,
                        // ),
                      ],
                    ),
                  ),
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    vertical: verticalPadding,
                    horizontal: 0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StaticIcon(
                        icon: item.icon,
                        color: Colors.grey,
                        iconSize: iconSize,
                      ),
                      SizedBox(height: context.height(0.005)),
                      // _StaticText(
                      //   label: item.label,
                      //   color: textfiledhintColor,
                      //   textSize: textSize,
                      // ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class _StaticIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double iconSize;

  const _StaticIcon({
    required this.icon,
    required this.color,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: color,
      size: iconSize,
    );
  }
}

class _NavBarItem {
  final String label;
  final IconData icon;
  const _NavBarItem({required this.label, required this.icon});
}