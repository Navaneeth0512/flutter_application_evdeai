import 'package:flutter_bloc/flutter_bloc.dart';

// BLoC Events
abstract class RegistrationEvent {}

class SubmitRegistrationEvent extends RegistrationEvent {
  final String email;
  final String phone;
  final String password;

  SubmitRegistrationEvent(this.email, this.phone, this.password);
}

// BLoC States
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String error;
  RegistrationFailure(this.error);
}

// BLoC
class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<SubmitRegistrationEvent>(_onSubmitRegistrationEvent);
  }

  void _onSubmitRegistrationEvent(
      SubmitRegistrationEvent event, Emitter<RegistrationState> emit) async {
    emit(RegistrationLoading());
    try {
      // Simulate registration process
      await Future.delayed(Duration(seconds: 2));

      // Basic validation logic
      if (event.email.isEmpty ||
          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(event.email)) {
        emit(RegistrationFailure("Invalid email format"));
        return;
      }
      if (event.phone.isEmpty || event.phone.length < 10) {
        emit(RegistrationFailure("Invalid phone number"));
        return;
      }
      if (event.password.isEmpty || event.password.length < 6) {
        emit(
            RegistrationFailure("Password must be at least 6 characters long"));
        return;
      }

      // Simulate successful registration
      emit(RegistrationSuccess());
    } catch (e) {
      emit(RegistrationFailure("An error occurred: ${e.toString()}"));
    }
  }
}
