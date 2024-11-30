import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/bus_details.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busoperatorhome.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_text_form_field.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_elevated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SaveYourBusPage(),
    );
  }
}

class SaveYourBusPage extends StatefulWidget {
  @override
  _SaveYourBusPageState createState() => _SaveYourBusPageState();
}

class _SaveYourBusPageState extends State<SaveYourBusPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _busRegisterController = TextEditingController();
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _startDestinationController =
      TextEditingController();
  final TextEditingController _endDestinationController =
      TextEditingController();

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Save Your Bus'),
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusOperatorHome(),
              ),
            ); // Handle back button press
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Save Your Bus',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Hello user, save your bus to have full access on your bus and enjoy our features.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _busRegisterController,
                  labelText: 'Bus register number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the bus register number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _busNameController,
                  labelText: 'Bus name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the bus name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _startDestinationController,
                  labelText: 'Start destination',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the start destination';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                CustomTextFormField(
                  controller: _endDestinationController,
                  labelText: 'End destination',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the end destination';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: CustomElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        // Form is valid, save the data to Firestore
                        try {
                          // Get the logged-in user's email
                          String userEmail =
                              FirebaseAuth.instance.currentUser?.email ?? '';

                          // Create or update the document for the user in BusData collection
                          DocumentReference userDocRef =
                              _firestore.collection('BusData').doc(userEmail);

                          // Create a subcollection named BusDetails and add the bus details
                          await userDocRef.collection('BusDetails').add({
                            'busRegisterNumber': _busRegisterController.text,
                            'busName': _busNameController.text,
                            'startDestination':
                                _startDestinationController.text,
                            'endDestination': _endDestinationController.text,
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bus details saved!')),
                          );

                          // Navigate to the next page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusDetails(),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error saving bus details: $e')),
                          );
                        }
                      }
                    },
                    text: 'Continue',
                    width: null, // Remove infinity width
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
