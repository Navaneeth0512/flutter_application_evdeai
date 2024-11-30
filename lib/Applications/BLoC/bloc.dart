import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<SubmitPhoneNumberEvent>((event, emit) async {
      emit(PhoneNumberSubmitting());

      try {
        // Simulate an async operation (e.g., OTP sending)
        await Future.delayed(const Duration(seconds: 2));
        emit(PhoneNumberSubmitted());
      } catch (e) {
        emit(LoginError("Failed to send OTP. Please try again."));
      }
    });
  }
}
