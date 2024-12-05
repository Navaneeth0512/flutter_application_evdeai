import 'package:flutter_application_evdeai/Applications/Pages/busdetails/bloc/event.dart';
import 'package:flutter_application_evdeai/Applications/Pages/busdetails/bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
