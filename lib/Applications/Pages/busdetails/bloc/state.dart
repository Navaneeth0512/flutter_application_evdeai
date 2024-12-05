// Define the BLoC States
abstract class BusDetailsState {}

class BusDetailsInitial extends BusDetailsState {}

class BusDetailsLoading extends BusDetailsState {}

class BusDetailsLoaded extends BusDetailsState {
  final List<Map<String, dynamic>> buses;

  BusDetailsLoaded(this.buses);
}

class BusDetailsError extends BusDetailsState {
  final String message;

  BusDetailsError(this.message);
}
