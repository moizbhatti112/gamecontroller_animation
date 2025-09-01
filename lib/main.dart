import 'package:flutter/material.dart';
import 'package:gamecontroller_animation/providers/home_provider.dart';
import 'package:gamecontroller_animation/providers/nav_provider.dart';
import 'package:gamecontroller_animation/widgets/bottom_nav.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
         providers: [
        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
         ChangeNotifierProvider(create: (context) => HomeProvider()),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Game App',
        
        home: const MainNav(),
      ),
    );
  }
}

