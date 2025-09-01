import 'package:flutter/material.dart';


class TypewriterFeaturedText extends StatefulWidget {
  const TypewriterFeaturedText({super.key});

  @override
  State<TypewriterFeaturedText> createState() => _TypewriterFeaturedTextState();
}

class _TypewriterFeaturedTextState extends State<TypewriterFeaturedText>
    with TickerProviderStateMixin {
  late AnimationController _typewriterController;
  late Animation<int> _characterCount1;
  late Animation<int> _characterCount2;
  
  final String text1 = "Featured";
  final String text2 = "Products";

  @override
  void initState() {
    super.initState();
    
    _typewriterController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _characterCount1 = StepTween(
      begin: 0,
      end: text1.length,
    ).animate(CurvedAnimation(
      parent: _typewriterController,
      curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    _characterCount2 = StepTween(
      begin: 0,
      end: text2.length,
    ).animate(CurvedAnimation(
      parent: _typewriterController,
      curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _typewriterController.forward();
  }

  @override
  void dispose() {
    _typewriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _typewriterController.reset();
        _typewriterController.forward();
      },
      child: AnimatedBuilder(
        animation: _typewriterController,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1.substring(0, _characterCount1.value),
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                text2.substring(0, _characterCount2.value),
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}