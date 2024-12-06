import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async {
      await Navigator.pushNamedAndRemoveUntil(
          context, '/buslogin', (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: Image.asset('assets/images/logo.jpg'),
      ),
    );
  }
}
