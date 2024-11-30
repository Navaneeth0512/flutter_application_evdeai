abstract class LoginState {}

class LoginInitial extends LoginState {}

class PhoneNumberSubmitting extends LoginState {}

class PhoneNumberSubmitted extends LoginState {}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}
