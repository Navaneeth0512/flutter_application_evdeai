// BLoC Events
abstract class RegistrationEvent {}

class SubmitRegistrationEvent extends RegistrationEvent {
  final String email;
  final String phone;
  final String password;

  SubmitRegistrationEvent(this.email, this.phone, this.password);
}
