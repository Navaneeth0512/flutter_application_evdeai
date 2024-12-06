import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'otp_verification_event.dart';
part 'otp_verification_state.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  OtpVerificationBloc() : super(OtpVerificationInitial()) {
    on<OtpVerificationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
