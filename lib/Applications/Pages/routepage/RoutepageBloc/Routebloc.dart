// route_bloc.dart
import 'dart:async';
import 'package:flutter_application_evdeai/Applications/pages/Routepage/RoutepageBloc/RouteEvent.dart';
import 'package:flutter_application_evdeai/Applications/pages/Routepage/RoutepageBloc/Routestate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  Timer? _animationTimer;
  final int totalStops;

  RouteBloc({this.totalStops = 6}) : super(const RouteState()) {
    on<StartAnimationEvent>(_onStartAnimation);
    on<StopAnimationEvent>(_onStopAnimation);
    on<UpdateDropdownEvent>(_onUpdateDropdown);
  }

  void _onStartAnimation(StartAnimationEvent event, Emitter<RouteState> emit) {
    int currentStop = 0;

    _animationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      currentStop += 1;
      if (currentStop >= totalStops) {
        timer.cancel();
      } else {
        emit(state.copyWith(currentStop: currentStop));
      }
    });
  }

  void _onStopAnimation(StopAnimationEvent event, Emitter<RouteState> emit) {
    _animationTimer?.cancel();
  }

  void _onUpdateDropdown(UpdateDropdownEvent event, Emitter<RouteState> emit) {
    emit(state.copyWith(dropdownValue: event.selectedValue));
  }

  @override
  Future<void> close() {
    _animationTimer?.cancel();
    return super.close();
  }
}
