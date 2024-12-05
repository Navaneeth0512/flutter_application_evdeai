import 'package:flutter_application_evdeai/Applications/Pages/startthetrip/SharelivelocationRepo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

// Events
abstract class StartTripEvent {}

class StartTripToggleEvent extends StartTripEvent {}

// States
abstract class StartTripState {}

class StartTripInitial extends StartTripState {}

class StartTripLoading extends StartTripState {}

class TripStartedState extends StartTripState {}

class TripStoppedState extends StartTripState {}

class StartTripError extends StartTripState {
  final String error;
  StartTripError(this.error);
}

// Assuming you have a ShareLiveLocationRepo class defined somewhere
class ShareLiveLocationRepo {
  final String busNumber;
  bool isTripActive = false;

  ShareLiveLocationRepo(this.busNumber);

  void startUpdatingLocation() {
    // Logic to start updating location
    isTripActive = true;
  }

  void stopUpdatingLocation() {
    // Logic to stop updating location
    isTripActive = false;
  }
}

// BLoC Logic
class StartTripBloc extends Bloc<StartTripEvent, StartTripState> {
  final SharelivelocationRepo sharelivelocation;

  StartTripBloc(String busNumber)
      : sharelivelocation = SharelivelocationRepo(busNumber),
        super(StartTripInitial()) {
    on<StartTripToggleEvent>((event, emit) async {
      emit(StartTripLoading());

      if (sharelivelocation.isTripActive) {
        // Stop the trip if it's already active
        sharelivelocation.stopUpdatingLocation();
        emit(TripStoppedState());
      } else {
        // Check for location permission
        if (await Permission.location.request().isGranted) {
          // Start updating location
          sharelivelocation.startUpdatingLocation();
          emit(TripStartedState());
        } else {
          emit(StartTripError('Location permission denied'));
        }
      }
    });
  }
}
