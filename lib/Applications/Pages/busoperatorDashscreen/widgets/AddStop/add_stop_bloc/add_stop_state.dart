part of 'add_stop_bloc.dart';

abstract class AddStopState extends Equatable {
  const AddStopState();

  @override
  List<Object?> get props => [];
}

class AddStopInitial extends AddStopState {}

class AddStopLoading extends AddStopState {}

class AddStopSuccess extends AddStopState {
  final List<Map<String, dynamic>> stops;

  const AddStopSuccess(this.stops);

  @override
  List<Object?> get props => [stops];
}

class AddStopSaved extends AddStopState {
  final List<Map<String, dynamic>> stops;

  const AddStopSaved(this.stops);

  @override
  List<Object?> get props => [stops];
}

class AddStopError extends AddStopState {
  final String message;

  const AddStopError(this.message);

  @override
  List<Object?> get props => [message];
}
