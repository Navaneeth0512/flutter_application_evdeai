abstract class LoginEvent {}

class SubmitPhoneNumberEvent extends LoginEvent {
  final String phoneNumber;

  SubmitPhoneNumberEvent(this.phoneNumber);
}
