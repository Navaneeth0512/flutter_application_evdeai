part of 'login_email_bloc.dart';

sealed class LoginEmailState extends Equatable {
  const LoginEmailState();
  
  @override
  List<Object> get props => [];
}

 class LoginEmailInitial extends LoginEmailState {}

 class EmailLoading extends LoginEmailState{}

// ignore: must_be_immutable
class EmailAuthenticated extends LoginEmailState{
  User? user;
  EmailAuthenticated(this.user);
  

}

class EmailUnAuthenticated extends LoginEmailState{

}

class EmailAuthenticatedError extends LoginEmailState{
  final String message;

  const EmailAuthenticatedError({required this.message});
}
