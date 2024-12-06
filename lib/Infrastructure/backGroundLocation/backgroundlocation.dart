// import 'dart:async';
// import 'package:workmanager/workmanager.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// class BackgroundLocationWorker extends wor {
//   BackgroundLocationWorker() : super(const WorkerDetails(id: "background_location_task"));

//   @override
//   Future<FutureOr<bool>> execute(context, data) async {
//     try {
//       final position = await Geolocator.getCurrentPosition();
//       // Update your Firestore or other database with the location

//       return Future.value(true); // Success
//     } catch (error) {
//       debugPrint('Error updating location: $error');
//       return Future.value(false); // Failure
//     }
//   }
// }