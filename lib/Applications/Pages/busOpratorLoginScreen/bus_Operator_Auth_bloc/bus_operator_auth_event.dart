part of 'bus_operator_auth_bloc.dart';

sealed class BusOperatorAuthEvent extends Equatable {
  const BusOperatorAuthEvent();

  @override
  List<Object> get props => [];
}

class BusOperatorphoneLogin extends BusOperatorAuthEvent {}
class BusOperatoremailLogin extends BusOperatorAuthEvent {}
