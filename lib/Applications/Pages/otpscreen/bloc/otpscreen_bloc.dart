import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'otpscreen_event.dart';
part 'otpscreen_state.dart';

class OtpscreenBloc extends Bloc<OtpscreenEvent, OtpscreenState> {
  OtpscreenBloc() : super(OtpscreenInitial()) {
    on<OtpscreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
