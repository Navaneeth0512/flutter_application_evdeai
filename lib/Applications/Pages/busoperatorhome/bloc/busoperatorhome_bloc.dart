import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'busoperatorhome_event.dart';
part 'busoperatorhome_state.dart';

class BusoperatorhomeBloc extends Bloc<BusoperatorhomeEvent, BusoperatorhomeState> {
  BusoperatorhomeBloc() : super(BusoperatorhomeInitial()) {
    on<BusoperatorhomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
