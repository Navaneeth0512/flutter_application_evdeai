part of 'login_phone_bloc.dart';

sealed class LoginPhoneEvent extends Equatable {
  const LoginPhoneEvent();

  @override
  List<Object> get props => [];
}
class VerifyPhoneNumber extends LoginPhoneEvent{ 
  final String phoneNumber;

  const VerifyPhoneNumber({required this.phoneNumber});
}

class SignInWithphone extends LoginPhoneEvent{ 
  final String verficationId;
  final int? token;

  const SignInWithphone({required this.verficationId, required this.token});
}

class VerifyOtp extends LoginPhoneEvent{
  final String otpCode;
  final String verificationId;

  const VerifyOtp({required this.otpCode, required this.verificationId});
}

class PhoneAuthErrorEvent extends LoginPhoneEvent{
  final String error;

  const PhoneAuthErrorEvent({required this.error});
}

class PhoneverificationComplete extends LoginPhoneEvent{
  final AuthCredential credential;

  const PhoneverificationComplete({required this.credential});
}