abstract class LoginState {}

class LoginInitialState extends LoginState {}

class PhoneNumberSubmitting extends LoginState {}

class PhoneNumberSubmitted extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}
