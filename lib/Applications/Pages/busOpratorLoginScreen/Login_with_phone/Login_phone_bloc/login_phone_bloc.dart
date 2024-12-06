// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_evdeai/Infrastructure/Models/bus_login_model/bus_operator_auth-model.dart';

part 'login_phone_event.dart';
part 'login_phone_state.dart';

class LoginPhoneBloc extends Bloc<LoginPhoneEvent, LoginPhoneState> {
  String loginResult = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BusoperatorPhoneModel busoperatorPhoneModel = BusoperatorPhoneModel();
  UserCredential? userCredential;
  LoginPhoneBloc(super.initialState) {
    on<VerifyPhoneNumber>((event, emit) async {
      emit(LoginPhoneLoading(isLoading: true));
      try {
        String phoneNumber = '+91${event.phoneNumber}';
        await busoperatorPhoneModel.loginWithPhone(
            phoneNumber: phoneNumber,
            verificationCompleted: (PhoneAuthCredential credentials) {
              add(PhoneverificationComplete(credential: credentials));
            },
            verificationFailed: (FirebaseAuthException e) {
              print('Error: ${e.message}');
              add(PhoneAuthErrorEvent(error: e.toString()));
            },
            codeSent: (String verficationId, int? refreshToken) {
              add(SignInWithphone(
                  verficationId: verficationId, token: refreshToken));
            },
            codeAutoRetrievalTimeout: (String verficationId) {
              print('Error: Code auto retrieval timeout');
            });

        emit(LoginPhoneSuccess());
      } catch (e) {
        print('Error: ${e.toString()}'); // Print error message here
        emit(LoginPhoneError(error: e.toString()));
      }
    });

    on<SignInWithphone>((event, emit) {
      emit(LoginPhoneVerificationCodeSent(verificationId: event.verficationId));
    });

    on<VerifyOtp>((event, emit) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: event.verificationId,
            smsCode: event.verificationId);
        add(PhoneverificationComplete(credential: credential));
      } catch (e) {
        print('Error: ${e.toString()}');
        emit(LoginPhoneError(error: e.toString()));
      }
    });

    on<PhoneAuthErrorEvent>((event, emit) {
      print('Error: ${event.error}');
      emit(LoginPhoneError(error: event.error));
    });

    on<PhoneverificationComplete>((event, emit) async {
      try {
        await busoperatorPhoneModel.authentication
            .signInWithCredential(event.credential)
            .then((value) {
          final phoneNumber = value.user?.phoneNumber;
          if (phoneNumber != null) {
            _firestore
                .collection('BusOperatorsLogin')
                .doc('BusOperatorPhone')
                .collection(phoneNumber)
                .doc('User credential')
                .set({
              'phone_number': phoneNumber,
              'created_at': DateTime.now(),
            });
          }
          emit(const LoginPhoneSuccess());

          emit(LoginPhoneLoaded());
        });
      } catch (e) {
        print('Error: ${e.toString()}');
        emit(LoginPhoneError(error: e.toString()));
      }
    });
  }
}
