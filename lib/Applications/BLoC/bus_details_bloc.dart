import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Define the BLoC Events
abstract class BusDetailsEvent {}

class FetchBusDetailsEvent extends BusDetailsEvent {}

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

// Define the BLoC
class BusDetailsBloc extends Bloc<BusDetailsEvent, BusDetailsState> {
  BusDetailsBloc() : super(BusDetailsInitial()) {
    on<FetchBusDetailsEvent>((event, emit) async {
      emit(BusDetailsLoading());
      try {
        // Get the logged-in user's email
        String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

        // Fetch bus details from the user's subcollection 'BusDetails'
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('Busdata')
            .doc(userEmail)
            .collection('BusDetails')
            .get();

        List<Map<String, dynamic>> buses = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        emit(BusDetailsLoaded(buses));
      } catch (e) {
        emit(BusDetailsError(e.toString()));
      }
    });
  }
}
