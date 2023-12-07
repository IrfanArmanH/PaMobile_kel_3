import 'package:flutter/material.dart';
import 'package:test_pa/bottomnavigationBar.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavScreen(),
    );
  }
}
