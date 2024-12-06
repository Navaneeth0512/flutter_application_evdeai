import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/Login_with_email/Login_email_bloc/login_email_bloc.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/Login_with_email/login_email.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/Login_with_phone/Login_with_phone.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/bus_Operator_Auth_bloc/bus_operator_auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusoperatorloginWrapper extends StatelessWidget {
  const BusoperatorloginWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BusOperatorAuthBloc()),
        BlocProvider(create: (context) => LoginEmailBloc()),
      ],
      child: const Busoperatorlogin(),
    );
  }
}

class Busoperatorlogin extends StatefulWidget {
  const Busoperatorlogin({super.key});

  @override
  State<Busoperatorlogin> createState() => _BusoperatorloginState();
}

class _BusoperatorloginState extends State<Busoperatorlogin> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<BusOperatorAuthBloc>(context)
          .add(BusOperatorphoneLogin());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginEmailBloc, LoginEmailState>(
      listener: (context, state) {
        if (state is EmailAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/buslist', (route) => false);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/mainpage');
              },
              icon: Icon(Icons.arrow_back)),
          automaticallyImplyLeading: false,
          backgroundColor: backGroundColor,
          title: const Text(
            'Bus operator Login',
            style: TextStyle(
                color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: backGroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<BusOperatorAuthBloc, BusOperatorAuthState>(
            builder: (context, state) {
              return Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  const Text(
                    'evde.AI',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  const Text(
                    'Welcome bus operator',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Hello user, Login to have full access on your\nbus and enjoy our features.',
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  if (state is LoginWithPhoneState)
                    const LoginWithPhoneWrapper(),
                  if (state is LoginWithemailState) const LoginEmailWrapper()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
