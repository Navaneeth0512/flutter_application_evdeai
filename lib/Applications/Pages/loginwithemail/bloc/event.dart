// BLoC Events
abstract class LoginEvent {}

class SubmitLoginEvent extends LoginEvent {
  final String email;
  final String password;

  SubmitLoginEvent(this.email, this.password);
}
