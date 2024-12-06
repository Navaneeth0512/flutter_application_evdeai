import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/pages/AddBusScreen/Add_bus_page.dart';
import 'package:flutter_application_evdeai/Applications/pages/AddBusScreen/widget/bus_list.dart';
import 'package:flutter_application_evdeai/Applications/pages/Routepage/Routepage.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOperatorHomeScreen/BusOperatorHomePage.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/Login_with_email/register_page.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/busoperatorlogin.dart';
import 'package:flutter_application_evdeai/Applications/pages/busoperatorDashscreen/BusOperatorDashScreen.dart';
import 'package:flutter_application_evdeai/Applications/pages/otpVerificationScreen/OtpVerificatinPage.dart';
import 'package:flutter_application_evdeai/Applications/pages/splashscreen/splash_screen.dart';
import 'package:flutter_application_evdeai/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/buslogin': (context) => const BusoperatorloginWrapper(),
        '/emailregister': (context) => const EmailRegisterWrapper(),
        '/otppage': (context) => const OtpVerificationPageWrapper(),
        '/bushome': (context) => const Busoperatorhomepage(),
        '/buslistpage': (context) => const BusListWrapper(),
        '/addbuspage': (context) => const AddBusWrapper(),
        '/busstand': (context) => const BusStandWrapper(),
        '/busroutepage': (context) => RoutePage(),
        //'sharebuspage':(context) => const BusQrpage( busData:ModalRoute.of(context)!.setting.arguments?.toString()?? '',
        // ),
      }, // Set SplashScreen as the initial page
    );
  }
}
