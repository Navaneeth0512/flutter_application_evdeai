import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'generate_qr_event.dart';
part 'generate_qr_state.dart';

class GenerateQrBloc extends Bloc<GenerateQrEvent, GenerateQrState> {
  GenerateQrBloc() : super(GenerateQrInitial()) {
    on<GenerateQrEvent>((event, emit) {
  
    });
  }
}
