part of 'saveyourbus_bloc.dart';

abstract class SaveYourBusEvent {}

class SaveBusDataEvent extends SaveYourBusEvent {
  final String busRegisterNumber;
  final String busName;
  final String startDestination;
  final String endDestination;

  SaveBusDataEvent({
    required this.busRegisterNumber,
    required this.busName,
    required this.startDestination,
    required this.endDestination,
  });
}
