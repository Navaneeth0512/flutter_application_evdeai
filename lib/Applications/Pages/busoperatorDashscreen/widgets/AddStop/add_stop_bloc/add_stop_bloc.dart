import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

part 'add_stop_event.dart';
part 'add_stop_state.dart';

class AddStopBloc extends Bloc<AddStopEvent, AddStopState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AddStopBloc() : super(AddStopInitial()) {
    on<AddStopRequested>((event, emit) async {
      emit(AddStopLoading());

      try {
        // Get location from the address
        final locations = await geocoding.locationFromAddress(event.stopName);
        if (locations.isNotEmpty) {
          final location = locations.first;

          // Create the new stop object
          final newStop = {
            'stopName': event.stopName,
            'time': event.stopTime,
            'location': {
              'latitude': location.latitude,
              'longitude': location.longitude,
            }
          };

          // Update the stops list in state
          final updatedStops = (state is AddStopSuccess)
              ? [...(state as AddStopSuccess).stops, newStop]
              : [newStop];

          emit(AddStopSuccess(updatedStops));
        } else {
          emit(AddStopError('Unable to get coordinates for the stop.'));
        }
      } catch (e) {
        emit(AddStopError('Failed to add stop: $e'));
      }
    });

    on<SaveStopsRequested>((event, emit) async {
      try {
        final busId = event.busId; // Ensure busId is passed correctly
        final stops = (state as AddStopSuccess).stops;

        // Create new fields to add to the bus document
        final newFields = {
          'routeDetails': {
            'totalStops': stops.length,
            'lastUpdated': DateTime.now(),
          },
        };

        // Update the existing bus document with the new 'stops' field and new fields
        await firestore.collection('busData').doc(busId).update({
          'stops': stops,
          ...newFields, // Spread operator to include new fields
        });

        emit(AddStopSaved(stops));
      } catch (e) {
        emit(AddStopError('Failed to save stops: $e'));
      }
    });
  }
}