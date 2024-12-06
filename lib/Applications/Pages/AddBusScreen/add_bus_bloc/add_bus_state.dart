part of 'add_bus_bloc.dart';

sealed class AddBusState extends Equatable {
  const AddBusState();

  @override
  List<Object> get props => [];
}

final class AddBusInitial extends AddBusState {}

class AddBusSaving extends AddBusState {}

class AddBusSaved extends AddBusState {}

class AddBusError extends AddBusState {
  final String error;
  const AddBusError(this.error);
}

class AddBusLoading extends AddBusState {}

class LoadedBusData extends AddBusState {
  final List<Map<String, dynamic>> busData;

  const LoadedBusData({required this.busData});
}

class FetchBusDataError extends AddBusState {
  final String error;

  const FetchBusDataError({required this.error});
}

class DataEmptyState extends AddBusState {}
