part of 'generate_qr_bloc.dart';

sealed class GenerateQrState extends Equatable {
  const GenerateQrState();
  
  @override
  List<Object> get props => [];
}

final class GenerateQrInitial extends GenerateQrState {}
