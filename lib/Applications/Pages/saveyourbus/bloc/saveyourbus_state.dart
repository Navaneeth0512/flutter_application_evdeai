part of 'saveyourbus_bloc.dart';

abstract class SaveYourBusState {}

class SaveYourBusInitial extends SaveYourBusState {}

class SaveYourBusLoading extends SaveYourBusState {}

class SaveYourBusSuccess extends SaveYourBusState {}

class SaveYourBusFailure extends SaveYourBusState {
  final String error;

  SaveYourBusFailure({required this.error});
}
