import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../screens/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation(),),);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/animation/news-icon.json',
          width: double.infinity,
        ),
      ),
    );
  }
}

