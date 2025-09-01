import 'package:flutter/material.dart';
import 'package:gamecontroller_animation/utils/screen_util.dart';

class ProductCategorymenu extends StatefulWidget {
  final Icon icon;
  const ProductCategorymenu({super.key, required this.icon});

  @override
  State<ProductCategorymenu> createState() => _ProductCategorymenuState();
}

class _ProductCategorymenuState extends State<ProductCategorymenu> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        height: context.height(0.05),
        width: context.width(0.14),
        decoration: BoxDecoration(
          color: isSelected 
            ?const Color.fromARGB(255, 39, 38, 38) 
            : Colors.white ,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(
              color: isSelected ?Colors.white: Colors.black  ,
            ),
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}