import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_evdeai/domain/Repository/buslivelocation_repository/sharelivelocation_repo.dart';
import 'package:permission_handler/permission_handler.dart';

part 'bus_opdash_event.dart';
part 'bus_opdash_state.dart';

class BusOpdashBloc extends Bloc<BusOpdashEvent, BusOpdashState> {
  final SharelivelocationRepo sharelivelocation;

  BusOpdashBloc(String busNumber)
      : sharelivelocation = SharelivelocationRepo(busNumber),
        super(BusOpdashInitial()) {
    on<StartTripEvent>(_onStartTrip);
    on<StopTripEvent>(_onStopTrip);
  }

  /// Handles starting the trip and enabling live location updates.
  Future<void> _onStartTrip(
      StartTripEvent event, Emitter<BusOpdashState> emit) async {
    emit(BusOpdashLoading());
    if (await Permission.location.request().isGranted) {
      sharelivelocation.startUpdatingLocation();
      emit(TripStartedState());
    } else {
      emit(BusOpDashError(error: 'Location permission denied'));
    }
  }

  /// Handles stopping the trip and disabling live location updates.
  Future<void> _onStopTrip(
      StopTripEvent event, Emitter<BusOpdashState> emit) async {
    emit(BusOpdashLoading());
    sharelivelocation.stopUpdatingLocation();
    emit(TripStoppedState());
  }
}
