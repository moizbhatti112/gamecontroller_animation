import 'package:flutter/material.dart';

class DebugRebuild extends StatelessWidget {
  final String name;
  final Widget child;

  const DebugRebuild({super.key, required this.name, required this.child});

  @override
  Widget build(BuildContext context) {
    debugPrint("🔁 Rebuilding: $name");
    return child;
  }
}
