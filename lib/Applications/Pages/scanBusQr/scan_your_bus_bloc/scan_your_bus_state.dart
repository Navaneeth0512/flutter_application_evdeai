part of 'scan_your_bus_bloc.dart';

sealed class ScanYourBusState extends Equatable {
  const ScanYourBusState();
  
  @override
  List<Object> get props => [];
}

final class ScanYourBusInitial extends ScanYourBusState {}
