import 'package:flutter/material.dart';
import 'package:gamecontroller_animation/constants/colors.dart';
import 'package:gamecontroller_animation/utils/screen_util.dart';

class ProductCard extends StatefulWidget {
  final String path;
  final String title;
  final String subtitle;
  
  const ProductCard({
    super.key, 
    required this.path,
    required this.title,
    required this.subtitle,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SlopedClipper(),
      
      child: Container(
        height: context.height(0.15),
        width: context.width(0.45), // Increased width for better proportions
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
              // Image container with flexible sizing
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  widget.path,
                  fit: BoxFit.contain, // Ensures image fits properly
                ),
              ),
              // SizedBox(height: 12),
              // Text content with flexible sizing
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  // maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlopedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 16.0; // Same as the border radius in the container
    double slopeOffset = 80.0; // The slope offset amount

    // Start from bottom-left with radius
    path.moveTo(0, size.height - radius);
    
    // Bottom-left rounded corner
    path.arcToPoint(
      Offset(radius, size.height),
      radius: Radius.circular(radius),
    );
    
    // Bottom edge
    path.lineTo(size.width - radius, size.height);
    
    // Bottom-right rounded corner
    path.arcToPoint(
      Offset(size.width, size.height - radius),
      radius: Radius.circular(radius),
    );
    
    // Right edge to top-right with radius
    path.lineTo(size.width, radius);
    
    // Top-right rounded corner
    path.arcToPoint(
      Offset(size.width - radius, 0),
      radius: Radius.circular(radius),
    );
    
    // Top edge with slope - go to the point where slope starts
    path.lineTo(radius, slopeOffset);
    
    // Top-left area with slope and radius
    // Create a curved transition from the slope to the left edge
    path.arcToPoint(
      Offset(0, slopeOffset + radius),
      radius: Radius.circular(radius),
    );
    
    // Left edge back to start
    path.lineTo(0, size.height - radius);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}