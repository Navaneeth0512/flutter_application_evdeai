import 'package:equatable/equatable.dart';

abstract class SaveYourBusEvent extends Equatable {
  @override
  List<Object> get props => [];
}

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

  @override
  List<Object> get props =>
      [busRegisterNumber, busName, startDestination, endDestination];
}
