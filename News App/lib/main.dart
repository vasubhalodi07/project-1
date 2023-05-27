import 'package:flutter/material.dart';
import 'package:news_app/screens/bottom_navigation.dart';
import 'animations/splash_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: BottomNavigation(),
    );
  }
}


