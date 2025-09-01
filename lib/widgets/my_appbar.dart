import 'package:flutter/material.dart';
import 'package:gamecontroller_animation/constants/colors.dart';
import 'package:gamecontroller_animation/utils/screen_util.dart';

class MyAppbar extends StatelessWidget {
  const MyAppbar({super.key});

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: context.height(0.05),
            width: context.width(0.1),
            decoration: BoxDecoration(
              color: appbarcolor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 204, 213, 224),
                  blurRadius: 12,
                ),
              ],
            ),

            child: Icon(Icons.sort_outlined),
          ),
          Container(
            height: context.height(0.05),
            width: context.width(0.1),
            decoration: BoxDecoration(
              color: appbarcolor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 204, 213, 224),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Icon(Icons.shopping_cart_checkout_outlined),
          ),
        ],
      ),
    );
  }
}
