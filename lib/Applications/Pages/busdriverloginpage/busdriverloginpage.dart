import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/loginwithemail/login_with_email_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';
import '../otpscreen/otpscreen.dart';

class BusDriverLoginPageWrapper extends StatelessWidget {
  const BusDriverLoginPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: const BusDriverLoginPage(),
    );
  }
}

class BusDriverLoginPage extends StatefulWidget {
  const BusDriverLoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BusDriverLoginPageState createState() => _BusDriverLoginPageState();
}

class _BusDriverLoginPageState extends State<BusDriverLoginPage> {
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Handle back navigation
          },
        ),
        title: const Text(
          "Bus Driver Login",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is PhoneNumberSubmitted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtpScreen()),
                );
              } else if (state is LoginError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "evde.AI",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Welcome bus operator",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Hello user, Login to have full access on your bus and enjoy our features.",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10, // Limit input length to 10
                ),
                const SizedBox(height: 20),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: state is PhoneNumberSubmitting
                            ? null
                            : () {
                                final phoneNumber = phoneController.text.trim();
                                if (phoneNumber.isEmpty ||
                                    phoneNumber.length != 10 ||
                                    !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("Enter a valid phone number")),
                                  );
                                } else {
                                  loginBloc
                                      .add(SubmitPhoneNumberEvent(phoneNumber));
                                }
                              },
                        child: state is PhoneNumberSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Get OTP",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 100),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR", style: TextStyle(color: Colors.black)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 100),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginWithEmailPage()));
                    },
                    child: const Text(
                      "Login with Email",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
