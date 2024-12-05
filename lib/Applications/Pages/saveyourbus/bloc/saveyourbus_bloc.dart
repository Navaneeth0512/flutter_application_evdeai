import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'saveyourbus_event.dart';
part 'saveyourbus_state.dart';

class SaveYourBusBloc extends Bloc<SaveYourBusEvent, SaveYourBusState> {
  final FirebaseFirestore firestore;
  final String googleApiKey;

  SaveYourBusBloc({required this.firestore, required this.googleApiKey})
      : super(SaveYourBusInitial()) {
    on<SaveBusDataEvent>(_onSaveBusData);
  }

  Future<void> _onSaveBusData(
      SaveBusDataEvent event, Emitter<SaveYourBusState> emit) async {
    emit(SaveYourBusLoading());
    try {
      final startCoordinates = await _getCoordinates(event.startDestination);
      final endCoordinates = await _getCoordinates(event.endDestination);

      if (startCoordinates == null || endCoordinates == null) {
        emit(SaveYourBusFailure(error: 'Could not fetch coordinates.'));
        return;
      }

      String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

      if (userEmail.isNotEmpty) {
        DocumentReference userDocRef =
            firestore.collection('Busdata').doc(userEmail);
        await userDocRef.collection('BusDetails').add({
          'busRegisterNumber': event.busRegisterNumber,
          'busName': event.busName,
          'startDestination': event.startDestination,
          'endDestination': event.endDestination,
          'startCoordinates': startCoordinates,
          'endCoordinates': endCoordinates,
        });

        emit(SaveYourBusSuccess());
      } else {
        emit(SaveYourBusFailure(error: 'User not logged in.'));
      }
    } catch (e) {
      emit(SaveYourBusFailure(error: 'Error saving bus details: $e'));
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
}
