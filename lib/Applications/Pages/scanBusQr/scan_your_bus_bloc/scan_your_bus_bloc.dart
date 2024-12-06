import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'scan_your_bus_event.dart';
part 'scan_your_bus_state.dart';

class ScanYourBusBloc extends Bloc<ScanYourBusEvent, ScanYourBusState> {
  ScanYourBusBloc() : super(ScanYourBusInitial()) {
    on<ScanYourBusEvent>((event, emit) {
 
    });
  }
}
