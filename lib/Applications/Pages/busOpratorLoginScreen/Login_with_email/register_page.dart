import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_button.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/Login_with_email/Login_email_bloc/login_email_bloc.dart';
import 'package:flutter_application_evdeai/Applications/widgets/textfieldwidget/custom_Textfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EmailRegisterWrapper extends StatelessWidget {
  const EmailRegisterWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginEmailBloc(),
      child: EmailRegister(),
    );
  }
}

class EmailRegister extends StatefulWidget {
  const EmailRegister({super.key});

  @override
  State<EmailRegister> createState() => _EmailRegisterState();
}

class _EmailRegisterState extends State<EmailRegister> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signupbloc = BlocProvider.of<LoginEmailBloc>(context);
    return BlocListener<LoginEmailBloc, LoginEmailState>(
      listener: (context, state) {
        if (state is EmailLoading) {
          Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is EmailAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/buslogin', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: backGroundColor,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  'REGISTER HERE',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                )),
                Gap(20),
                CustomTextformWidget(
                  controller: _emailController,
                  hinttext: 'Enter Your Email',
                  labelText: 'Email',
                  keyboardType: TextInputType.text,
                  isPassword: false,
                  validator: (value) => value != null && value.isEmpty
                      ? 'Enter your valid Email'
                      : null,
                ),
                Gap(10),
                CustomTextformWidget(
                    controller: _passwordController,
                    hinttext: 'Password',
                    labelText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Your Password';
                      }

                      if (value.length < 8) {
                        return 'Length should be 8 characters';
                      }
                      return null;
                    }),
                Gap(10),
                CustomTextformWidget(
                  controller: _confirmPasswordController,
                  hinttext: 'Confirm Password',
                  labelText: 'Confirm Password',
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    } else if (value.length < 8) {
                      return 'The Password Is Incorrect';
                    }
                    return null;
                  },
                ),
                Gap(40),
                CustomButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signupbloc.add(SingupEvent(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim()));
                      }
                    },
                    text: 'Register',
                    boxDecoration: BoxDecoration(
                        color: textColor,
                        borderRadius: BorderRadius.circular(15)),
                    height: 60,
                    width: 380,
                    textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: backGroundColor))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
