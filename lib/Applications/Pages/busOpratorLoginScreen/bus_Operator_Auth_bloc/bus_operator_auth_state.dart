part of 'bus_operator_auth_bloc.dart';

sealed class BusOperatorAuthState extends Equatable {
  const BusOperatorAuthState();
  
  @override
  List<Object> get props => [];
}

final class BusOperatorAuthInitial extends BusOperatorAuthState {}

class LoginWithPhoneState extends BusOperatorAuthState{}

class LoginWithemailState extends BusOperatorAuthState{}

class LoginStaterror extends BusOperatorAuthState{}
