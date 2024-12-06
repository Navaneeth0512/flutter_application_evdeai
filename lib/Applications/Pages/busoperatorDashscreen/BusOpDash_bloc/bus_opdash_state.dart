part of 'bus_opdash_bloc.dart';

abstract class BusOpdashState extends Equatable {
  const BusOpdashState();

  @override
  List<Object?> get props => [];
}

class BusOpdashInitial extends BusOpdashState {}

class BusOpdashLoading extends BusOpdashState {}

class TripStartedState extends BusOpdashState {}

class TripStoppedState extends BusOpdashState {}

class BusOpDashError extends BusOpdashState {
  final String error;

  const BusOpDashError({required this.error});

  @override
  List<Object?> get props => [error];
}
