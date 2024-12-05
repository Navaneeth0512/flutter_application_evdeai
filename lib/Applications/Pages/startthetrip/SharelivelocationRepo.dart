import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class SharelivelocationRepo {
  final String busNumber; // Bus number passed when initializing the repository
  bool isTripActive = false; // Tracks if the trip is active
  Timer? _timer;

  SharelivelocationRepo(this.busNumber);

  /// Saves the live location to Firestore under the document corresponding to the bus number
  Future<void> _saveLocationToFirestore(
      double latitude, double longitude) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentTime = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(currentTime);

      // Fetch the Firestore document containing the bus number
      QuerySnapshot querySnapshot = await firestore
          .collectionGroup(
              'BusDetails') // Query all subcollections named 'BusDetails'
          .where('busNumber', isEqualTo: busNumber)
          .orderBy('busNumber') // Filter by the given bus number
          .get(); // Execute the query

      if (querySnapshot.docs.isNotEmpty) {
        // Update the first matching document with the live location
        await querySnapshot.docs.first.reference.update({
          'liveLocations': {
            'latitude': latitude,
            'longitude': longitude,
            'timestamp': currentTime.toIso8601String(),
            'LiveTime': formattedTime,
          },
        });
        print("Live location saved at $formattedTime");
      } else {
        print("BusNumber $busNumber not found in Firestore.");
      }
    } catch (e) {
      print("Error saving live location: $e");
    }
  }

  /// Retrieves the current device location
  Future<Position> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }

    // Check and request location permissions if needed
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    // Return the current position with high accuracy
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /// Starts updating the live location periodically
  void startUpdatingLocation() {
    if (isTripActive) return; // Prevent duplicate timers

    isTripActive = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      try {
        final position = await _getCurrentLocation();
        _saveLocationToFirestore(position.latitude, position.longitude);
      } catch (e) {
        print("Error during location update: $e");
      }
    });
    print("Location updates started.");
  }

  /// Stops updating the live location
  void stopUpdatingLocation() {
    _timer?.cancel();
    isTripActive = false;
    print("Location updates stopped.");
  }
}
