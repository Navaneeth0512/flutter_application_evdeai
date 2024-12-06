import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteLocationRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CollectionReference _locationsCollection;

  RouteLocationRepo() {
    _locationsCollection = _firestore.collection('BusLiveLocation').doc('EKB')
        as CollectionReference<Object?>;
  }
  Future<List<LatLng>> getLocationsFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await _locationsCollection.get();
      List<LatLng> locations = querySnapshot.docs.map((doc) {
        return LatLng(doc['latitude'], doc['longitude']);
      }).toList();
      return locations;
    } catch (e) {
      print('Error getting locations from Firestore: $e');
      return [];
    }
  }
}
