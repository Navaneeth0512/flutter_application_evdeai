import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bus_op_home_event.dart';
part 'bus_op_home_state.dart';

class BusOpHomeBloc extends Bloc<BusOpHomeEvent, BusOpHomeState> {
  BusOpHomeBloc() : super(BusOpHomeInitial()) {
    on<BusOpHomeEvent>((event, emit) {
      
    });
  }
}
