import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Hai',
            style: TextStyle(fontSize: 20),
          ),
          Center(
              child: Container(
            height: 100,
            width: 100,
            color: textColor,
          ))
          // ),
        ],
      ),
    );
  }

  Future<void> _saveToFirestore(String scannedData) async {
    try {
      final user = _auth.currentUser;
      String collectionName;

      if (user?.phoneNumber != null) {
        // User is logged in with phone number
        collectionName = user!.phoneNumber ?? '';
      } else if (user?.email != null) {
        // User is logged in with email
        collectionName = user!.email ?? '';
      } else {
        return;
      }
      // Assuming you have a collection named 'users' and you want to save under the user's credentials
      await firestore.collection(collectionName).add({
        'scannedData': scannedData,
        'timestamp': FieldValue.serverTimestamp(), // Optional: Add timestamp
      });
      print("Data saved successfully");
    } catch (e) {
      print("Error saving data: $e");
    }
  }
}
