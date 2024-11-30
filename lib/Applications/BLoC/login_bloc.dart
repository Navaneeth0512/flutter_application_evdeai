import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// BLoC Events
abstract class LoginEvent {}

class SubmitLoginEvent extends LoginEvent {
  final String email;
  final String password;

  SubmitLoginEvent(this.email, this.password);
}

// BLoC States
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final bool hasBusDetails;

  LoginSuccess(this.hasBusDetails);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<SubmitLoginEvent>(_onSubmitLoginEvent);
  }

  Future<void> _onSubmitLoginEvent(
      SubmitLoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Check if the user is signed in
      if (userCredential.user != null) {
        // Now check Firestore to see if the user exists in BusOperatorsLogin
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('BusOperatorsLogin')
            .doc(event.email) // Use email as document ID
            .get();

        if (userDoc.exists) {
          // User exists in Firestore, now check for bus details
          QuerySnapshot busDetailsSnapshot = await FirebaseFirestore.instance
              .collection('BusData')
              .doc(event.email) // Use email as document ID
              .collection('BusDetails') // Assuming you have a sub-collection
              .get();

          bool hasBusDetails = busDetailsSnapshot.docs.isNotEmpty;

          // Emit success state with bus details information
          emit(LoginSuccess(hasBusDetails));
        } else {
          // User does not exist in Firestore
          emit(LoginFailure('User  not found in the database.'));
        }
      } else {
        emit(LoginFailure('Login failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      // Print the error code for debugging
      print('FirebaseAuthException caught: ${e.code}');

      // Handle different types of Firebase exceptions
      switch (e.code) {
        case 'user-not-found':
          emit(LoginFailure('No user found for that email.'));
          break;
        case 'wrong-password':
          emit(LoginFailure('Wrong password provided for that user.'));
          break;
        case 'invalid-email':
          emit(LoginFailure('The email address is not valid.'));
          break;
        case 'user-disabled':
          emit(LoginFailure('This user has been disabled.'));
          break;
        default:
          emit(LoginFailure('An unexpected error occurred. Please try again.'));
      }
    } catch (e) {
      // Catch any other types of exceptions
      emit(LoginFailure('An unknown error occurred: ${e.toString()}'));
    }
  }
}
