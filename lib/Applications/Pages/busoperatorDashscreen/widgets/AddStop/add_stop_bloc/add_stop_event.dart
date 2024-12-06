part of 'add_stop_bloc.dart';

sealed class AddStopEvent extends Equatable {
  const AddStopEvent();

  @override
  List<Object> get props => [];
}
class AddStopRequested extends AddStopEvent {
  final String stopName;
  final String stopTime;

  const AddStopRequested(this.stopName, this.stopTime);

  @override
  List<Object> get props => [stopName, stopTime];
}

class SaveStopsRequested extends AddStopEvent {
final String busId;

  SaveStopsRequested({required this.busId});

}