import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class SharelivelocationRepo {
  final String busNumber;
  bool isTripActive = false; // Default trip state
  Timer? _timer;

  SharelivelocationRepo(this.busNumber);

  Future<void> _saveLocationToFirestore(
      double latitude, double longitude) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentTime = DateTime.now();
      final formattedTime = DateFormat('hh:mm a').format(currentTime);

      QuerySnapshot querySnapshot = await firestore
          .collectionGroup('BusDetails')
          .where('busNumber', isEqualTo: busNumber)
          .orderBy('busNumber')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
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

  Future<Position> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

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

  void stopUpdatingLocation() {
    _timer?.cancel();
    isTripActive = false;
    print("Location updates stopped.");
  }
}
