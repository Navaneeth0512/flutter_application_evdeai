import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Widgets/custom_button.dart';
import '../bus_Operator_Auth_bloc/bus_operator_auth_bloc.dart';
import 'Login_phone_bloc/login_phone_bloc.dart';
import 'package:country_picker/country_picker.dart';

// ...

class LoginWithPhoneWrapper extends StatelessWidget {
  const LoginWithPhoneWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginPhoneBloc(LoginPhoneInitial()),
      child: const LoginWithPhone(),
    );
  }
}

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initUser();
    setState(() {});
  }

  void initUser() {
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
  }

  bool isValidPhoneNumber(String phoneNumber) {
    return RegExp(r'^\d{10}$').hasMatch(phoneNumber);
  }

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
  @override
  Widget build(BuildContext context) {
    _phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: _phoneController.text.length,
      ),
    );
    final loginPhoneBloc = BlocProvider.of<LoginPhoneBloc>(context);
    return BlocListener<LoginPhoneBloc, LoginPhoneState>(
      listener: (context, state) {
        if (state is LoginPhoneSuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/otppage');
              });
              return const CupertinoAlertDialog(
                title: Text(
                  'success',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text('OTP sent to your Phone Number',
                    style: TextStyle(color: textColor, fontSize: 18)),
              );
            },
          );
        } else if (state is LoginPhoneError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      child: BlocBuilder<LoginPhoneBloc, LoginPhoneState>(
        builder: (context, state) {
          if (state is LoginPhoneInitial) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CountryCodePicker(
                    onChanged: (CountryCode countryCode) {
                      print(countryCode.dialCode);
                    },
                    initialSelection: 'IN',
                    favorite: ['+1', 'IN'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    builder: (p0) {
                      return TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _phoneController.text = value;
                          });
                        },
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                      bottomSheetHeight: 550,
                                    ),
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Text(
                                "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          suffixIcon: _phoneController.text.length > 9
                              ? Container(
                                  height: 30,
                                  width: 30,
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              : null,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          hintText: 'Phone number',
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(73, 0, 0, 0)),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return 'Enter the mobile no';
                          } else if (!isValidPhoneNumber(value!)) {
                            return 'Invalid phone number';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        loginPhoneBloc.add(VerifyPhoneNumber(
                            phoneNumber: _phoneController.text));
                        _phoneController.clear();
                        print('$_phoneController');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Error: incorrect Phone')));
                      }
                    },
                    text: 'Get OTP',
                    boxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: textColor),
                    height: 70,
                    width: 370,
                    textStyle: const TextStyle(
                        color: backGroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                  const Center(child: Text('------------OR------------')),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                      child: TextButton(
                          onPressed: () {
                            context
                                .read<BusOperatorAuthBloc>()
                                .add(BusOperatoremailLogin());
                          },
                          child: const Text(
                            'Login with email',
                            style: TextStyle(
                                color: Color.fromARGB(201, 244, 67, 54)),
                          ))),
                ],
              ),
            );
          } else if (state is LoginPhoneLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
