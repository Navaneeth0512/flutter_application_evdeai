part of 'otpscreen_bloc.dart';

sealed class OtpscreenState extends Equatable {
  const OtpscreenState();
  
  @override
  List<Object> get props => [];
}

final class OtpscreenInitial extends OtpscreenState {}
