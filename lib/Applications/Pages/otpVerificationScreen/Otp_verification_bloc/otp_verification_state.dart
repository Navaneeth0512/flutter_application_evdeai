part of 'otp_verification_bloc.dart';

sealed class OtpVerificationState extends Equatable {
  const OtpVerificationState();
  
  @override
  List<Object> get props => [];
}

final class OtpVerificationInitial extends OtpVerificationState {}
