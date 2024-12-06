import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/Login_with_email/Login_email_bloc/login_email_bloc.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/bus_Operator_Auth_bloc/bus_operator_auth_bloc.dart';
import 'package:flutter_application_evdeai/Applications/widgets/textfieldwidget/custom_Textfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../Widgets/custom_button.dart';

class LoginEmailWrapper extends StatelessWidget {
  const LoginEmailWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginEmailBloc(),
      child: LoginWithEmail(),
    );
  }
}

class LoginWithEmail extends StatefulWidget {
  const LoginWithEmail({super.key});

  @override
  State<LoginWithEmail> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginemailbloc = BlocProvider.of<LoginEmailBloc>(context);
    return BlocListener<LoginEmailBloc, LoginEmailState>(
      listener: (context, state) {
        if (state is EmailAuthenticated &&
            state.user != null &&
            state.user!.email != null) {
          checkBusDetailsAndNavigate(context, state.user!.email!);
        } else if (state is EmailAuthenticatedError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      child: BlocBuilder<LoginEmailBloc, LoginEmailState>(
        builder: (context, state) {
          if (state is EmailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintText: 'E-mail address',
                  ),
                  validator: (value) => value != null && value.isEmpty
                      ? 'Enter your valid Email'
                      : null,
                ),
                const Gap(10),
                CustomTextformWidget(
                  controller: _passwordController,
                  hinttext: 'Password',
                  labelText: 'Password',
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  validator: (value) => value != null && value.isEmpty
                      ? 'Enter the password'
                      : null,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      loginemailbloc.add(LoginEvent(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Error: incorrect credential')));
                    }
                  },
                  text: 'Login',
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: textColor,
                  ),
                  height: 70,
                  width: 370,
                  textStyle: const TextStyle(
                    color: backGroundColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/emailregister');
                    },
                    child: Text(
                      "You are First Time? Register Here",
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
                const Gap(80),
                const Center(child: Text('------------OR------------')),
                const Gap(30),
                Center(
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<BusOperatorAuthBloc>()
                          .add(BusOperatorphoneLogin());
                    },
                    child: const Text(
                      'Login with Phone',
                      style: TextStyle(color: Color.fromARGB(201, 244, 67, 54)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Checks if the user has bus details and navigates accordingly.
  Future<void> checkBusDetailsAndNavigate(
      BuildContext context, String email) async {
    try {
      // Access Firestore to check if the user has added a bus
      final busDetailsSnapshot = await FirebaseFirestore.instance
          .collection('Busdata')
          .doc(email)
          .collection('BusDetails')
          .get();

      if (busDetailsSnapshot.docs.isNotEmpty) {
        // Navigate to Bus List Page if bus details exist
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/buslistpage',
          (route) => false,
        );
      } else {
        // Navigate to Bus Home Page if no bus details are found
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/bushome',
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching bus details: ${e.toString()}')),
      );
    }
  }
}
