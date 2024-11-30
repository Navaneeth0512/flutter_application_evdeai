import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/BLoC/bloc.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busdriverloginpage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      home: BlocProvider(
        create: (context) => LoginBloc(), // Provide the LoginBloc here
        child: const SplashScreen(), // Start with the SplashScreen
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // Delay for 3 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const BusDriverLoginPageWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Evde.AI',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
