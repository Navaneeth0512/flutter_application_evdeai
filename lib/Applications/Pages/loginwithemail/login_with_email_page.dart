import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_evdeai/Applications/Pages/loginwithemail/bloc/login_bloc.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busdetails/bus_details.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busoperatorhome/busoperatorhome.dart';
import 'package:flutter_application_evdeai/Applications/Pages/Registerwithemail/register_with_email_page.dart';
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
          listener: (context, state) {
            if (state is LoginSuccess) {
              // Navigate based on whether the user has bus details
              if (state.hasBusDetails) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BusDetails()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BusOperatorHome()),
                );
              }
            } else if (state is LoginFailure) {
              // Show error message on failure
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
                  const Text(
                    'Login with Email',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                    onChanged: (value) {},
                    prefixIcon: Icons.abc,
                    onTap: () {},
                    hinttext: '',
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
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
                    onChanged: (value) {},
                    prefixIcon: Icons.password,
                    onTap: () {},
                    hinttext: 'Enter Your Password',
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
                          onTap: () {},
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
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
                        ),
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
