import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Applications/BLoC/login_bloc.dart';
import 'Applications/Pages/splashscreen.dart';
import 'firebase_options.dart'; // Import Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppInitializer());
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreenWrapper(),
      ),
    );
  }
}

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure that LoginPage is part of the widget tree below the BlocProvider
    return const SplashScreen();
  }
}
