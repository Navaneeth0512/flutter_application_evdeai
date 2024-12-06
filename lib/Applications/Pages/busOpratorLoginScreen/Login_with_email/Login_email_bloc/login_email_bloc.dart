import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'login_email_event.dart';
part 'login_email_state.dart';

class LoginEmailBloc extends Bloc<LoginEmailEvent, LoginEmailState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginEmailBloc() : super(LoginEmailInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(EmailLoading());
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final user = userCredential.user;
        if (user != null) {
          emit(EmailAuthenticated(user));
          // Update Firestore login details
          await _firestore
              .collection('BusOperatorsLogin')
              .doc('BusOperatorEmail')
              .collection(event.email)
              .doc('User credential')
              .set({
            'email': event.email,
            'created at': DateTime.now(),
          });
        } else {
          emit(EmailUnAuthenticated());
        }
      } catch (e) {
        emit(EmailAuthenticatedError(
            message: 'Your Email and Password is Incorrect'));
        emit(EmailUnAuthenticated());
      }
    });

    on<SingupEvent>((event, emit) async {
      emit(EmailLoading());
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final user = userCredential.user;
        if (user != null) {
          emit(EmailAuthenticated(user));
        } else {
          emit(EmailUnAuthenticated());
        }
      } catch (e) {
        emit(EmailAuthenticatedError(message: 'Failed to create account'));
        emit(EmailUnAuthenticated());
      }
    });

    on<CheckLoginStatus>((event, emit) async {
      final user = _auth.currentUser;
      if (user != null) {
        emit(EmailAuthenticated(user));
      } else {
        emit(EmailUnAuthenticated());
      }
    });

    on<LogOutEvent>((event, emit) async {
      try {
        await _auth.signOut();
        emit(EmailUnAuthenticated());
      } catch (e) {
        emit(EmailAuthenticatedError(message: e.toString()));
      }
    });

    on<CheckBusDetailsEvent>((event, emit) async {
      try {
        // Check for bus details in Firestore
        final busDetailsSnapshot = await _firestore
            .collection('Busdata')
            .doc(event.email)
            .collection('BusDetails')
            .get();

        if (busDetailsSnapshot.docs.isNotEmpty) {
          emit(BusDetailsFound());
        } else {
          emit(BusDetailsNotFound());
        }
      } catch (e) {
        emit(EmailAuthenticatedError(
            message: 'Error fetching bus details: ${e.toString()}'));
      }
    });
  }
}

// New States
class BusDetailsFound extends LoginEmailState {}

class BusDetailsNotFound extends LoginEmailState {}
