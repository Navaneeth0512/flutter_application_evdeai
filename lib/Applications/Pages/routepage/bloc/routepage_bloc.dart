import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'routepage_event.dart';
part 'routepage_state.dart';

class RoutepageBloc extends Bloc<RoutepageEvent, RoutepageState> {
  RoutepageBloc() : super(RoutepageInitial()) {
    on<RoutepageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
