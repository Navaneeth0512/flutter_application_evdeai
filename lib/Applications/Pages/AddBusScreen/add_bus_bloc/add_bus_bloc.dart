import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Infrastructure/busStopdata/busStopData.dart';
import 'package:flutter_application_evdeai/domain/Repository/geocoding_repository/geocoding_repository.dart';

part 'add_bus_event.dart';
part 'add_bus_state.dart';

class AddBusBloc extends Bloc<AddBusEvent, AddBusState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AddBusBloc() : super(AddBusInitial()) {
    on<AddingBusEvent>((event, emit) async {
      emit(AddBusSaving());
      try {
        final startLocations = await GeocodingService.getLocationFromAddress(
            event.startLocation.toLowerCase());
        final endLocations = await GeocodingService.getLocationFromAddress(
            event.endLocation.toLowerCase());

        if (startLocations == null || endLocations == null) {
          emit(AddBusError('Failed to geocode one or both destinations'));
          return;
        }

        final user = _auth.currentUser;
        String docName;

        if (user?.phoneNumber != null) {
          docName = user!.phoneNumber ?? '';
        } else if (user?.email != null) {
          docName = user!.email ?? '';
        } else {
          emit(AddBusError('User is not logged in'));
          return;
        }

        if (docName.isEmpty) {
          emit(AddBusError('Document name is empty'));
          return;
        }

        print('Document path: Busdata/$docName/BusDetails');

        // Prepare the document data with common fields
        final Map<String, dynamic> busData = {
          'busNumber': event.busRegisterNumber,
          'busName': event.busName,
          'startDestination': {
            'stopname': event.startLocation,
            'latitude': startLocations['latitude'],
            'longitude': startLocations['longitude'],
          },
          'endDestination': {
            'stopname': event.endLocation,
            'latitude': endLocations['latitude'],
            'longitude': endLocations['longitude'],
          },
        };

        // Add arrays based on conditions
        if (event.startLocation == 'kottakkal bus stand' &&
            event.endLocation == 'tirur bus stand') {
          busData['Stops'] = ktklTotir;
          busData['Stops2'] =
              tirtoktkl; // `Stops` will now contain a flat list of maps
        } else if (event.startLocation == 'tirur bus stand' &&
            event.endLocation == 'kottakkal bus stand') {
          busData['Stops'] = tirtoktkl;
          busData['Stops2'] =
              ktklTotir; // `Stops` will now contain a flat list of maps
        }
        if (event.startLocation == 'tirur bus stand' &&
            event.endLocation == 'kuttippuram bus stand') {
          busData['Stops'] =
              tirTOkuttp; // `Stops` will now contain a flat list of maps
        } else if (event.startLocation == 'kuttippuram bus stand' &&
            event.endLocation == 'tirur bus stand') {
          busData['Stops'] =
              tirTOkuttp; // `Stops` will now contain a flat list of maps
        }

// Add the data to Firestore
        await _firestore
            .collection('Busdata')
            .doc(docName)
            .collection('BusDetails')
            .add(busData);

        emit(AddBusSaved());
      } catch (e) {
        FirebaseCrashlytics.instance.recordError(e, null);
        emit(AddBusError(e.toString()));
      }
    });

    on<FetchBusData>((event, emit) async {
      emit(AddBusLoading());
      try {
        final user = _auth.currentUser;
        String docName;

        if (user?.phoneNumber != null) {
          docName = user!.phoneNumber ?? '';
        } else if (user?.email != null) {
          docName = user!.email ?? '';
        } else {
          emit(AddBusError('User is not logged in'));
          return;
        }

        if (docName.isEmpty) {
          emit(AddBusError('Document name is empty'));
          return;
        }

        print('Document path: Busdata/$docName/BusDetails');

        final busDataSnapshot = await _firestore
            .collection('Busdata')
            .doc(docName)
            .collection('BusDetails')
            .get();

        if (busDataSnapshot.docs.isNotEmpty) {
          final List<Map<String, dynamic>> busDataList =
              busDataSnapshot.docs.map((doc) => doc.data()).toList();
          emit(LoadedBusData(busData: busDataList));
        } else {
          emit(DataEmptyState());
        }
      } catch (e) {
        emit(AddBusError(e.toString()));
      }
    });
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute;
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12; // Convert to 12-hour format
    return '$hour12:${minute.toString().padLeft(2, '0')} $ampm'; // Ensure two digits for minutes
  }
}
