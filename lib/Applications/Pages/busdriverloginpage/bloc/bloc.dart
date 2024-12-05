import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState());

  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is SubmitPhoneNumberEvent) {
      yield PhoneNumberSubmitting();
      try {
        // Simulate OTP sending logic
        await Future.delayed(const Duration(seconds: 2));
        yield PhoneNumberSubmitted();
      } catch (e) {
        yield LoginError(error: "Failed to send OTP.");
      }
    }
  }
}
