part of 'login_phone_bloc.dart';

sealed class LoginPhoneState extends Equatable {
  const LoginPhoneState();
  
  @override
  List<Object> get props => [];
}

final class LoginPhoneInitial extends LoginPhoneState {}

class LoginPhoneLoading extends LoginPhoneState{
 final bool isLoading;

  const LoginPhoneLoading({required this.isLoading});
  List<Object> get props => [isLoading];

}
class LoginPhoneLoaded extends LoginPhoneState{}

class LoginPhoneVerificationCodeSent extends LoginPhoneState {
  final String verificationId;

  const LoginPhoneVerificationCodeSent({required this.verificationId});
 }

class LoginPhoneSuccess extends LoginPhoneState{


  const LoginPhoneSuccess();
}

class LoginPhoneError extends LoginPhoneState{
final String error;

  const LoginPhoneError({required this.error});

}