import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_evdeai/Applications/BLoC/registration_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busoperatorhome.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_elevated_button.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class RegisterWithEmailPage extends StatefulWidget {
  @override
  _RegisterWithEmailPageState createState() => _RegisterWithEmailPageState();
}

class _RegisterWithEmailPageState extends State<RegisterWithEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Register with Email'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<RegistrationBloc, RegistrationState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => BusOperatorHome()),
              );
            } else if (state is RegistrationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Register with Email',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        controller: _phoneController,
                        labelText: 'Phone Number',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Please enter a valid phone number';
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
                      CustomTextFormField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<RegistrationBloc, RegistrationState>(
                        builder: (context, state) {
                          return Center(
                            child: CustomElevatedButton(
                              onPressed: state is RegistrationLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState?.validate() ==
                                          true) {
                                        // Form is valid, handle the registration logic here
                                        try {
                                          // Create user with email and password
                                          UserCredential userCredential =
                                              await FirebaseAuth.instance
                                                  .createUserWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );

                                          // Save additional user information in Firestore
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  'BusOperatorsLogin') // Changed collection name
                                              .doc(_emailController
                                                  .text) // Use email as document ID
                                              .set({
                                            'email': _emailController.text,
                                            'phone': _phoneController.text,
                                            // Add any additional driver details here
                                          });

                                          // Dispatch success event
                                          context
                                              .read<RegistrationBloc>()
                                              .add(SubmitRegistrationEvent(
                                                _emailController.text,
                                                _phoneController.text,
                                                _passwordController.text,
                                              ));
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(e.toString())),
                                          );
                                        }
                                      }
                                    },
                              text: state is RegistrationLoading
                                  ? "Loading..."
                                  : "Register",
                              width: null, // Remove infinity width
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
