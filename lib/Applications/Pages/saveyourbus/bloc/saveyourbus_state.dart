import 'package:equatable/equatable.dart';

abstract class SaveYourBusState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveYourBusInitial extends SaveYourBusState {}

class SaveYourBusLoading extends SaveYourBusState {}

class SaveYourBusSuccess extends SaveYourBusState {}

class SaveYourBusFailure extends SaveYourBusState {
  final String error;

  SaveYourBusFailure({required this.error});

  @override
  List<Object> get props => [error];
}
