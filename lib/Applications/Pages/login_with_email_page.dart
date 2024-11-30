import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_evdeai/Applications/BLoC/login_bloc.dart';
import 'package:flutter_application_evdeai/Applications/Pages/bus_details.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busoperatorhome.dart';
import 'package:flutter_application_evdeai/Applications/Pages/register_with_email_page.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_elevated_button.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_text_form_field.dart';

class LoginWithEmailPage extends StatefulWidget {
  const LoginWithEmailPage({Key? key}) : super(key: key);

  @override
  _LoginWithEmailPageState createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Login with Email'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccess) {
              User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                try {
                  // Fetch bus details from Firestore
                  QuerySnapshot busDetailsSnapshot = await FirebaseFirestore
                      .instance
                      .collection('BusData')
                      .doc(user.email) // Use email as document ID
                      .collection(
                          'BusDetails') // Assuming you have a sub-collection
                      .get();

                  // Debugging: Print the snapshot data
                  print(
                      'Bus Details Snapshot: ${busDetailsSnapshot.docs.length} documents found.');

                  if (busDetailsSnapshot.docs.isNotEmpty) {
                    // User has bus details, navigate to BusDetails page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BusDetails()),
                    );
                  } else {
                    // No bus details, navigate to BusOperatorHome
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusOperatorHome()),
                    );
                  }
                } catch (e) {
                  // Handle any errors that occur during Firestore access
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error retrieving bus details: $e')),
                  );
                }
              } else {
                // Handle case where user is null
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User  is not authenticated.')),
                );
              }
            } else if (state is LoginFailure) {
              // Show the error message from the LoginFailure state
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Login with Email',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: 'Password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Center(
                        child: CustomElevatedButton(
                          onPressed: state is LoginLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    context.read<LoginBloc>().add(
                                          SubmitLoginEvent(
                                            _emailController.text,
                                            _passwordController.text,
                                          ),
                                        );
                                  }
                                },
                          text: state is LoginLoading ? "Loading..." : "Login",
                          width: null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20), // Added spacing
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account...?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterWithEmailPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Create",
                            style: TextStyle(
                              color: Colors.orange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
