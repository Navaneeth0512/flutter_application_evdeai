// BLoC States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final bool hasBusDetails;

  LoginSuccess(this.hasBusDetails);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
