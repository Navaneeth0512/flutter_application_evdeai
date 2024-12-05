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
    emit(LoginLoading()); // Emit loading state

    try {
      // Attempt to sign in with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      if (userCredential.user != null) {
        // Check Firestore for user existence in BusOperatorsLogin
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('BusOperatorsLogin')
            .doc('BusOperatorEmail') // Assuming this is the correct reference
            .collection(sanitizeEmail(
                event.email)) // Use sanitized email as collection ID
            .doc('UserCredential')
            .get();

        if (userDoc.exists) {
          // Check for bus details
          QuerySnapshot busDetailsSnapshot = await FirebaseFirestore.instance
              .collection('Busdata')
              .doc(event.email) // Use email as document ID
              .collection('BusDetails') // Sub-collection with bus details
              .get();

          bool hasBusDetails = busDetailsSnapshot.docs.isNotEmpty;

          // Emit success state with bus details information
          emit(LoginSuccess(hasBusDetails));
        } else {
          // User does not exist in Firestore
          emit(LoginFailure('User not found in the database.'));
        }
      } else {
        emit(LoginFailure('Login failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException and emit appropriate error message
      print('FirebaseAuthException caught: ${e.code}');

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
      // Catch any other errors
      emit(LoginFailure('An unknown error occurred: ${e.toString()}'));
    }
  }

  // Function to sanitize email for Firestore collection name
  String sanitizeEmail(String email) {
    return email.replaceAll('.', '_').replaceAll('@', '_at_');
  }
}
