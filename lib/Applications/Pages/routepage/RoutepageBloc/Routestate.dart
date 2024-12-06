// route_state.dart
import 'package:equatable/equatable.dart';

class RouteState extends Equatable {
  final String dropdownValue;
  final int currentStop;

  const RouteState({this.dropdownValue = 'Today', this.currentStop = 0});

  RouteState copyWith({String? dropdownValue, int? currentStop}) {
    return RouteState(
      dropdownValue: dropdownValue ?? this.dropdownValue,
      currentStop: currentStop ?? this.currentStop,
    );
  }

  @override
  List<Object?> get props => [dropdownValue, currentStop];
}
