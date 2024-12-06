// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_button.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/Login_with_phone/Login_phone_bloc/login_phone_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPageWrapper extends StatelessWidget {
  const OtpVerificationPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginPhoneBloc(LoginPhoneInitial()),
      child: const Otpverificatinpage(),
    );
  }
}

class Otpverificatinpage extends StatefulWidget {
  const Otpverificatinpage({super.key});

  @override
  State<Otpverificatinpage> createState() => _OtpverificatinpageState();
}

class _OtpverificatinpageState extends State<Otpverificatinpage> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() {
    _otpController = TextEditingController();
  }

  LoginPhoneBloc loginPhoneBloc = LoginPhoneBloc(LoginPhoneInitial());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginPhoneBloc, LoginPhoneState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backGroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/buslogin');
                },
                icon: Icon(Icons.arrow_back)),
            backgroundColor: backGroundColor,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Icon(
                    BoxIcons.bx_lock_alt,
                    size: 28,
                    color: Colors.purple,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'OTP',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Please enter the code sent to your mobile\n number. Kindly check',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Pinput(
                    // focusedPinTheme: PinTheme(decoration: BoxDecoration(gradient: LinearGradient(colors: [
                    //   Colors.blue,
                    //   Colors.purple
                    // ]))),
                    controller: _otpController,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Didn't Recieve Code?",
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'resend',
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  if (state is LoginPhoneVerificationCodeSent)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomButton(
                          onTap: () {
                            loginPhoneBloc.add(VerifyOtp(
                                otpCode: _otpController.text,
                                verificationId: state.verificationId));
                            Navigator.pushNamed(context, '/addbuspage');
                          },
                          text: 'Continue',
                          boxDecoration: BoxDecoration(
                              color: textColor,
                              borderRadius: BorderRadius.circular(15)),
                          height: 60,
                          width: 320,
                          textStyle: const TextStyle(
                              color: backGroundColor, fontSize: 20)),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Need Help?",
                        style: TextStyle(color: textColor, fontSize: 14),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'contact support',
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
