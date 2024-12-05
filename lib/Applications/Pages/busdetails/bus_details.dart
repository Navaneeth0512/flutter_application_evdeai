import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busdetails/bloc/bus_details_bloc.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busdetails/bloc/event.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busdetails/bloc/state.dart';
import 'package:flutter_application_evdeai/Applications/Pages/saveyourbus/saveyourbuspage.dart';
import 'package:flutter_application_evdeai/Applications/Pages/startthetrip/starthetrip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_evdeai/Applications/Pages/googleapi.dart';

class BusDetails extends StatelessWidget {
  // Function to fetch coordinates from Google Maps API
  Future<Map<String, dynamic>?> _getCoordinates(String address) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=${GoogleAPI.googleApiKey}';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          return data['results'][0]['geometry']['location'];
        }
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
    return null;
  }

  // Function to save coordinates to Firestore
  Future<void> _saveCoordinatesToFirestore(
      String busId, String startAddress, String endAddress) async {
    final startCoordinates = await _getCoordinates(startAddress);
    final endCoordinates = await _getCoordinates(endAddress);

    if (startCoordinates != null && endCoordinates != null) {
      try {
        // Save coordinates as a map
        await FirebaseFirestore.instance
            .collection('BusDetails')
            .doc(busId)
            .update({
          'startCoordinates': {
            'lat': startCoordinates['lat'],
            'lng': startCoordinates['lng'],
          },
          'endCoordinates': {
            'lat': endCoordinates['lat'],
            'lng': endCoordinates['lng'],
          },
        });
      } catch (e) {
        print('Error saving coordinates to Firestore: $e');
      }
    } else {
      print('Error: Could not fetch coordinates for addresses.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusDetailsBloc()..add(FetchBusDetailsEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          centerTitle: false, // Set to false to allow left alignment
          title: const Row(
            mainAxisAlignment:
                MainAxisAlignment.start, // Align title to the left
            children: [
              Text(
                'Bus Details',
                style: TextStyle(color: Colors.black), // Set text color
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<BusDetailsBloc, BusDetailsState>(
          builder: (context, state) {
            if (state is BusDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BusDetailsLoaded) {
              return ListView.builder(
                itemCount: state.buses.length,
                itemBuilder: (context, index) {
                  final bus = state.buses[index];
                  return InkWell(
                    onTap: () async {
                      await _saveCoordinatesToFirestore(
                        bus['id'] ?? '', // Default to empty string if null
                        bus['startDestination'] ??
                            '', // Default to empty string if null
                        bus['endDestination'] ??
                            '', // Default to empty string if null
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StartTheTrip(), // Navigate to your RoutePage
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4, // Add some elevation
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.directions_bus,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Bus Name: ${bus['busName'] ?? 'N/A'}', // Fallback to 'N/A'
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.confirmation_number,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Register Number: ${bus['busRegisterNumber'] ?? 'N/A'}', // Fallback to 'N/A'
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Start Destination: ${bus['startDestination'] ?? 'N/A'}', // Fallback to 'N/A'
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  'End Destination: ${bus['endDestination'] ?? 'N/A'}', // Fallback to 'N/A'
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is BusDetailsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No bus details available.'));
          },
        ),
        // FloatingActionButton to navigate to BusOperatorHomePage
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SaveYourBusPage(), // Navigate to BusOperatorHomePage
              ),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
