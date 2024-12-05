import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busdetails/bus_details.dart';
import 'package:flutter_application_evdeai/Applications/Pages/saveyourbus/saveyourbuspage.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_elevated_button.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BusOperatorHome(),
    );
  }
}

class BusOperatorHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/logo.jpg'), // Replace with actual image URL
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your location',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
            Text(
              'Kochi, Kerala',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.directions_bus,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                const Text(
                  'No Buses connected Yet!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Save your bus to have full access on your bus and enjoy our features.\n\nTap the "Save your bus" button below to get started.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 80),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaveYourBusPage(),
                      ),
                    );
                  },
                  text: 'Save your bus',
                  width: null, onTap: () {}, // Remove infinity width
                ),
                const SizedBox(height: 20), // Add some space between buttons
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusDetails(),
                      ),
                    );
                  },
                  text: 'Saved Buses', onTap: () {},
                  // Remove infinity width
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
