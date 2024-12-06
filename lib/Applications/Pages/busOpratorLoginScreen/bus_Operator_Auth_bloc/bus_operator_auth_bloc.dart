import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bus_operator_auth_event.dart';
part 'bus_operator_auth_state.dart';

class BusOperatorAuthBloc extends Bloc<BusOperatorAuthEvent, BusOperatorAuthState> {
  BusOperatorAuthBloc() : super(BusOperatorAuthInitial()) {
    on<BusOperatoremailLogin>((event, emit) {
      emit(LoginWithemailState());
    });

    on<BusOperatorphoneLogin>((event,emit){
      emit(LoginWithPhoneState());
    });
  }
}
