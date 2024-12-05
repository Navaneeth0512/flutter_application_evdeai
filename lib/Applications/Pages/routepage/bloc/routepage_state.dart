part of 'routepage_bloc.dart';

sealed class RoutepageState extends Equatable {
  const RoutepageState();
  
  @override
  List<Object> get props => [];
}

final class RoutepageInitial extends RoutepageState {}
