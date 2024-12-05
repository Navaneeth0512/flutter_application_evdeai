import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/bus_details.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busoperatorhome.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_text_form_field.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_elevated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'googleapi.dart';

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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String googleApiKey = GoogleAPI.googleApiKey;

  // Function to save bus data
  Future<void> _saveBusData() async {
    if (_formKey.currentState?.validate() == true) {
      try {
        final startCoordinates =
            await _getCoordinates(_startDestinationController.text);
        final endCoordinates =
            await _getCoordinates(_endDestinationController.text);

        if (startCoordinates == null || endCoordinates == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Error: Could not fetch coordinates.')),
          );
          return;
        }

        String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

        if (userEmail.isNotEmpty) {
          DocumentReference userDocRef =
              _firestore.collection('Busdata').doc(userEmail);

          await userDocRef.collection('BusDetails').add({
            'busRegisterNumber': _busRegisterController.text,
            'busName': _busNameController.text,
            'startDestination': _startDestinationController.text,
            'endDestination': _endDestinationController.text,
            'startCoordinates': startCoordinates,
            'endCoordinates': endCoordinates,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bus details and route saved!')),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusDetails(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not logged in')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving bus details: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> _getCoordinates(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleApiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['geometry']['location'];
        }
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
    return null;
  }

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
            );
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
                CustomTextFormField(
                  controller: _busRegisterController,
                  labelText: 'Bus register number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the bus register number';
                    }
                    return null;
                  },
                  prefixIcon: Icons.abc,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  hinttext: '',
                  onChanged: (value) {},
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
                  prefixIcon: Icons.abc,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  hinttext: 'Bus Name',
                  onChanged: (value) {},
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
                  prefixIcon: Icons.location_on,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  hinttext: 'Start Destination',
                  onChanged: (value) {},
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
                  prefixIcon: Icons.location_on,
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  hinttext: 'End Destination',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 30),
                Center(
                  child: CustomElevatedButton(
                    text: 'Save Bus',
                    onPressed: _saveBusData,
                    onTap: () {},
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
