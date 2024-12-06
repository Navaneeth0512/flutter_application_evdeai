// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_application_evdeai/Applications/pages/AddBusScreen/add_bus_bloc/add_bus_bloc.dart';
import 'package:flutter_application_evdeai/Applications/widgets/textfieldwidget/custom_Textfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../Widgets/custom_button.dart';

class AddBusWrapper extends StatelessWidget {
  const AddBusWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBusBloc(),
      child: AddBusScreen(),
    );
  }
}

class AddBusScreen extends StatefulWidget {
  const AddBusScreen({super.key});

  @override
  State<AddBusScreen> createState() => _AddBusScreenState();
}

class _AddBusScreenState extends State<AddBusScreen> {
  late TextEditingController busRegisterController;
  late TextEditingController busNameController;
  late TextEditingController startDestinationController;
  late TextEditingController endDestinationController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? startTime; // Store Start Time
  TimeOfDay? endTime; // Store End Time
  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() {
    busRegisterController = TextEditingController();
    busNameController = TextEditingController();
    startDestinationController = TextEditingController();
    endDestinationController = TextEditingController();
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final addBusbloc = BlocProvider.of<AddBusBloc>(context);
    return BlocConsumer<AddBusBloc, AddBusState>(
      listener: (context, state) {
        if (state is AddBusSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bus saved successfully!')),
          );
          Navigator.pushNamed(context, '/buslistpage');
        } else if (state is AddBusError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: backGroundColor,
            title: const Text(
              'Save Your Bus',
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
          backgroundColor: backGroundColor,
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(20),
                  const Text(
                    'Save Your Bus',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                      'Hello user, save your bus to have full access on\nyour bus and enjoy our features'),
                  Gap(50),
                  CustomTextformWidget(
                    controller: busRegisterController,
                    hinttext: 'Bus register number',
                    labelText: 'Bus register number',
                    keyboardType: TextInputType.text,
                    isPassword: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a value';
                      }
                      value = value.toUpperCase();
                      if (value.length < 9 || value.length > 10) {
                        return 'Length should be between 9 and 10 characters';
                      }
                      if (!RegExp(r'^[A-Z]{2}\d{2}[A-Z]{1,2}\d{4}$')
                          .hasMatch(value)) {
                        return 'Invalid format. Please use the format: KL00AB1111';
                      }
                      return null;
                    },
                    InputFormatter: [
                      // FilteringTextInputFormatter.allow(RegExp(r'^[A-Z0-9]+$')),
                      LengthLimitingTextInputFormatter(10),
                      UpperCaseTextFormatter(), // Convert all alphabets to uppercase
                    ],
                  ),
                  Gap(30),
                  CustomTextformWidget(
                    controller: busNameController,
                    hinttext: 'Bus name',
                    labelText: 'Bus name',
                    keyboardType: TextInputType.text,
                    isPassword: false,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Enter the Bus Name'
                        : null,
                  ),
                  Gap(30),
                  CustomTextformWidget(
                    controller: startDestinationController,
                    hinttext: 'Start destination',
                    labelText: 'Start destination',
                    keyboardType: TextInputType.text,
                    isPassword: false,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Enter the starting destination'
                        : null,
                  ),
                  Gap(20),
                  CustomTextformWidget(
                    controller: endDestinationController,
                    hinttext: 'End destination',
                    labelText: 'End destination',
                    keyboardType: TextInputType.text,
                    isPassword: false,
                    validator: (value) => value != null && value.isEmpty
                        ? 'Enter the ending destination'
                        : null,
                  ),
                  Gap(40),
                  CustomButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        //                      { final error = await validateBusRegisterNumber(
//                           busRegisterController.text);
//                       if (error != null) {
// ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('the value is empty')),
//           );
//                       } else  {
                        addBusbloc.add(AddingBusEvent(
                          uid: FirebaseAuth.instance.currentUser?.uid ?? '',
                          busRegisterNumber: busRegisterController.text,
                          busName: busNameController.text,
                          startLocation: startDestinationController.text,
                          endLocation: endDestinationController.text,
                          // startTime: startTime!,
                          // endTime: endTime!,
                        ));
                      }
// final busreg = await validateBusRegisterNumber(busNameController.text);
                      busRegisterController.clear();
                      busNameController.clear();
                      startDestinationController.clear();
                      endDestinationController.clear();
                    },
                    // }
                    // },
                    text: state is AddBusSaving ? 'saving..' : 'Continue',
                    boxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: textColor),
                    height: 70,
                    width: double.infinity,
                    textStyle: const TextStyle(
                        color: backGroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    busRegisterController.dispose();
    busNameController.dispose();
    startDestinationController.dispose();
    endDestinationController.dispose();
    super.dispose();
  }

  Future<bool> _checkIfBusRegisterNumberExists(String value) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('Busdatas')
        .where('busNumber', isEqualTo: value)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<String?> validateBusRegisterNumber(String? value) async {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('the value is empty')),
      );
    }

    try {
      final isExisting = await _checkIfBusRegisterNumberExists(value!);
      if (isExisting) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('the value is empty')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('the value is empty')),
      );
      return null;
    }
    return null;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
