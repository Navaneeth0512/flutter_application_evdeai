part of 'login_email_bloc.dart';

sealed class LoginEmailEvent extends Equatable {
  const LoginEmailEvent();

  @override
  List<Object> get props => [];
}

class CheckLoginStatus extends LoginEmailEvent {}

class CheckBusDetailsEvent extends LoginEmailEvent {
  final String email;
  CheckBusDetailsEvent(this.email);
  @override
  List<Object> get props => [email];
}

class LoginEvent extends LoginEmailEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});
}

class SingupEvent extends LoginEmailEvent {
  final String email;
  final String password;

  const SingupEvent({required this.email, required this.password});
}

class LogOutEvent extends LoginEmailEvent {}
