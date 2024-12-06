part of 'bus_opdash_bloc.dart';

abstract class BusOpdashEvent extends Equatable {
  const BusOpdashEvent();

  @override
  List<Object?> get props => [];
}

class StartTripEvent extends BusOpdashEvent {}

class StopTripEvent extends BusOpdashEvent {}
