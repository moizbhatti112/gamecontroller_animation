import 'package:flutter/material.dart';
import 'package:gamecontroller_animation/constants/colors.dart';
import 'package:gamecontroller_animation/providers/home_provider.dart';
import 'package:gamecontroller_animation/screens/detail_screen.dart';
import 'package:gamecontroller_animation/utils/screen_util.dart';
import 'package:gamecontroller_animation/widgets/debug_wrapper.dart';
import 'package:gamecontroller_animation/widgets/my_appbar.dart';
import 'package:gamecontroller_animation/widgets/product_card.dart';
import 'package:gamecontroller_animation/widgets/product_categorymenu.dart';
import 'package:gamecontroller_animation/widgets/text.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _parallaxController;
  late Animation<double> _parallaxAnimation;

  final List<Color> _containerColors = const [
    Color(0xFFFFB74D),
    Color(0xFF0B7331),
    Color(0xFF612286),

    Color(0xFF852222),
    Color(0xff2B3489),

    //  Color(0xFFA85716),
  ];

  // Product data
  final List<Map<String, dynamic>> _products = [
    {
      'imagePath': 'assets/images/new1.png',
      'title': 'DualSense',
      'subtitle': 'Official PlayStation Controller',
      'price': '\$69.99',
      'description':
          'Experience haptic feedback, adaptive triggers, and a built-in microphone, all integrated into an iconic comfortable design.',
      'features': [
        'Haptic Feedback',
        'Adaptive Triggers',
        'Built-in Microphone',
        'Motion Controls',
        '3.5mm Headphone Jack',
      ],
      'color': Color(0xFFFFB74D),
    },
    {
      'imagePath': 'assets/images/new2.png',
      'title': 'Xbox Wireless',
      'subtitle': 'Official Xbox Controller',
      'price': '\$59.99',
      'description':
          'Get precise control with the Xbox Wireless Controller featuring a hybrid D-pad and textured grip.',
      'features': [
        'Hybrid D-pad',
        'Textured Grip',
        'Bluetooth Connectivity',
        'Custom Button Mapping',
        'Share Button',
      ],
      'color': Color(0xFF0B7331),
    },
    {
      'imagePath': 'assets/images/new3.png',
      'title': 'Pro Elite',
      'subtitle': 'Professional Gaming Controller',
      'price': '\$179.99',
      'description':
          'Take your gaming to the next level with adjustable-tension thumbsticks and wrap-around rubberized grip.',
      'features': [
        'Adjustable Thumbsticks',
        'Hair Triggers',
        'Paddles',
        'Rubberized Grip',
        'Profile Settings',
      ],
      'color': Color(0xFF612286),
    },

    {
      'imagePath': 'assets/images/new4.png',
      'title': 'Gaming Pro',
      'subtitle': 'Multi-Platform Controller',
      'price': '\$89.99',
      'description':
          'Universal gaming controller compatible with PC, mobile, and console gaming with premium build quality.',
      'features': [
        'Multi-Platform Support',
        'Programmable Buttons',
        'RGB Lighting',
        'Wireless Charging',
        '40-Hour Battery',
      ],
      'color': Color(0xFF852222),
    },
    {
      'imagePath': 'assets/images/new5.png',
      'title': 'Retro Pad',
      'subtitle': 'Classic Style Controller',
      'price': '\$39.99',
      'description':
          'Nostalgic design meets modern functionality with this retro-inspired gaming controller.',
      'features': [
        'Retro Design',
        'Modern Connectivity',
        'D-pad Focus',
        'Compact Size',
        'Plug & Play',
      ],
      'color': Color(0xff2B3489),
    },

    // {
    //   'imagePath': 'assets/images/new6.png',
    //   'title': 'Retro Pad',
    //   'subtitle': 'Classic Style Controller',
    //   'price': '\$39.99',
    //   'description': 'Nostalgic design meets modern functionality with this retro-inspired gaming controller.',
    //   'features': [
    //     'Retro Design',
    //     'Modern Connectivity',
    //     'D-pad Focus',
    //     'Compact Size',
    //     'Plug & Play',
    //   ],
    //   'color': Color(0xFFA85716),
    // },
  ];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    _parallaxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _parallaxAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _parallaxController, curve: Curves.easeOutCubic),
    );

    // Animation sequence after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        context.read<HomeProvider>().checkbox();

        Future.delayed(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          context.read<HomeProvider>().checklistview();

          _parallaxController.forward();

          Future.delayed(const Duration(milliseconds: 1100), () {
            if (!mounted) return;
            _centerListView();
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _parallaxController.dispose();
    super.dispose();
  }

  void _centerListView() {
    if (!_scrollController.hasClients) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenCenter = screenWidth / 2;
    const cardWidth = 180.0;
    const listViewPadding = 16.0;

    final initialScrollOffset =
        listViewPadding + (cardWidth / 2) - screenCenter;

    final targetScrollOffset = initialScrollOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      targetScrollOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }

  void _onScroll() {
    final homeProvider = context.read<HomeProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = context.width(0.45);

    homeProvider.handleScroll(
      scrollController: _scrollController,
      context: context,
      screenWidth: screenWidth,
      cardWidth: cardWidth,
    );
  }

  // ✅ SIMPLEST METHOD - Just change the transitionDuration!
  void _navigateToDetail(Map<String, dynamic> product, int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(
          milliseconds: 1200,
        ), // 🎯 This slows down the hero!
        reverseTransitionDuration: const Duration(
          milliseconds: 600,
        ), // 🎯 This slows down going back!
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailPage(product: product, heroTag: 'product_$index'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Stack(
        children: [
          // ✅ Rebuilds ONLY when `boxexpanded` or `centeredImageIndex` change
          Builder(
            builder: (context) {
              final expanded = context.select<HomeProvider, bool>(
                (p) => p.boxexpanded,
              );
              final colorIndex = context.select<HomeProvider, int>(
                (p) => p.centeredImageIndex,
              );

              debugPrint(
                "🎨 Animated background rebuild — expanded:$expanded colorIndex:$colorIndex",
              );

              return AnimatedAlign(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOutCubic,
                alignment: expanded ? Alignment.center : Alignment.topRight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeInOutCubic,
                  width: expanded
                      ? MediaQuery.of(context).size.width
                      : context.width(0.45),
                  height: expanded
                      ? MediaQuery.of(context).size.height
                      : context.height(0.8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: _containerColors[colorIndex],
                      borderRadius: expanded
                          ? BorderRadius.zero
                          : const BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                            ),
                    ),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Center(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 600),
                          opacity: expanded ? 0.3 : 1.0,
                          child: Builder(
                            builder: (context) {
                              debugPrint("Text rebuilt");
                              return Text(
                                "Controllers",
                                style: TextStyle(
                                  fontSize: expanded ? 80 : 120,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ✅ Static area — does NOT listen to provider at all
          DebugRebuild(
            name: "WholeScreen",
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MyAppbar(),
                    const Padding(
                      padding: EdgeInsets.all(25.0),
                      child: TypewriterFeaturedText(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: SizedBox(
                        height: context.height(0.1),
                        child: const Row(
                          children: [
                            Icon(Icons.menu),
                            SizedBox(width: 24),
                            ProductCategorymenu(icon: Icon(Icons.gamepad)),
                            SizedBox(width: 24),
                            ProductCategorymenu(icon: Icon(Icons.keyboard)),
                            SizedBox(width: 24),
                            ProductCategorymenu(icon: Icon(Icons.mouse)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ✅ Rebuilds ONLY when `listviewanimated` changes
                    Builder(
                      builder: (context) {
                        final animated = context.select<HomeProvider, bool>(
                          (p) => p.listviewanimated,
                        );
                        debugPrint(
                          "📜 ListView container rebuild — animated:$animated",
                        );

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutCubic,
                          transform: Matrix4.translationValues(
                            animated ? 0 : MediaQuery.of(context).size.width,
                            0,
                            0,
                          ),
                          height: context.height(0.35),
                          child: AnimatedBuilder(
                            animation: _parallaxAnimation,
                            builder: (context, child) {
                              return NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  if (scrollNotification
                                      is ScrollUpdateNotification) {
                                    final scrollOffset =
                                        scrollNotification.metrics.pixels;
                                    final maxScroll = scrollNotification
                                        .metrics
                                        .maxScrollExtent;
                                    if (maxScroll > 0) {
                                      final progress =
                                          (scrollOffset / maxScroll).clamp(
                                            0.0,
                                            1.0,
                                          );
                                      _parallaxController.value = progress;
                                    }
                                  }
                                  return false;
                                },
                                child: ListView.builder(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: _products.length,
                                  itemBuilder: (context, index) {
                                    final parallaxOffset =
                                        _parallaxAnimation.value *
                                        (index * 20.0 - 40.0);
                                    return Transform.translate(
                                      offset: Offset(parallaxOffset, 0),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: GestureDetector(
                                          onTap: () => _navigateToDetail(
                                            _products[index],
                                            index,
                                          ),
                                          child: _buildProductCard(index),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final product = _products[index];

    return ClipPath(
      clipper: SlopedClipper(),
      child: Container(
        height: context.height(0.15),
        width: context.width(0.45),
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: navcolor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Only the image is wrapped in Hero - matching detail screen
              Hero(
                tag: 'product_$index',
                child: SizedBox(
                  width: double.infinity,
                  child: Image.asset(product['imagePath'], fit: BoxFit.contain),
                ),
              ),

              // Text content outside Hero - prevents transition conflicts
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  product['title'],
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  product['subtitle'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// You'll also need to include the SlopedClipper class in your home screen file
class SlopedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 16.0;
    double slopeOffset = 80.0;

    path.moveTo(0, size.height - radius);

    path.arcToPoint(
      Offset(radius, size.height),
      radius: Radius.circular(radius),
    );

    path.lineTo(size.width - radius, size.height);

    path.arcToPoint(
      Offset(size.width, size.height - radius),
      radius: Radius.circular(radius),
    );

    path.lineTo(size.width, radius);

    path.arcToPoint(
      Offset(size.width - radius, 0),
      radius: Radius.circular(radius),
    );

    path.lineTo(radius, slopeOffset);

    path.arcToPoint(
      Offset(0, slopeOffset + radius),
      radius: Radius.circular(radius),
    );

    path.lineTo(0, size.height - radius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
