import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busdriverloginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds before navigating to the next page
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BusDriverLoginPageWrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Optional: Change to match your theme
      body: Center(
        child: Image.asset(
          'assets/images/logo.jpg', // Path to your logo
          width: 500, // Adjust size if needed
          height: 500,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
