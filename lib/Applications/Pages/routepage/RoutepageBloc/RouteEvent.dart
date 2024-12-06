// route_events.dart
import 'package:equatable/equatable.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();

  @override
  List<Object?> get props => [];
}

class StartAnimationEvent extends RouteEvent {}

class StopAnimationEvent extends RouteEvent {}

class UpdateDropdownEvent extends RouteEvent {
  final String selectedValue;

  const UpdateDropdownEvent(this.selectedValue);

  @override
  List<Object?> get props => [selectedValue];
}
