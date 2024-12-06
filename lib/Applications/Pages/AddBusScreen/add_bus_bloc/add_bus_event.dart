part of 'add_bus_bloc.dart';

sealed class AddBusEvent extends Equatable {
  const AddBusEvent();

  @override
  List<Object> get props => [];
}

class AddingBusEvent extends AddBusEvent {
  final String uid;
  final String busRegisterNumber;
  final String busName;
  final String startLocation;
  final String endLocation;
  // final TimeOfDay startTime;
  // final TimeOfDay endTime;

  const AddingBusEvent({
    required this.uid,
    required this.startLocation,
    required this.endLocation,
    required this.busRegisterNumber,
    required this.busName,
  });
}

class FetchBusData extends AddBusEvent {}
