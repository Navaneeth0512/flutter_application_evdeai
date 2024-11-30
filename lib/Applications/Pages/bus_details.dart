import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/BLoC/bus_details_bloc.dart';
import 'package:flutter_application_evdeai/Applications/Pages/starthetrip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusDetailsBloc()..add(FetchBusDetailsEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white70,
          centerTitle: false, // Set to false to allow left alignment
          title: const Row(
            mainAxisAlignment:
                MainAxisAlignment.start, // Align title to the left
            children: [
              Text(
                'Bus Details',
                style: TextStyle(color: Colors.black), // Set text color
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: BlocBuilder<BusDetailsBloc, BusDetailsState>(
          builder: (context, state) {
            if (state is BusDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BusDetailsLoaded) {
              return ListView.builder(
                itemCount: state.buses.length,
                itemBuilder: (context, index) {
                  final bus = state.buses[index];
                  return InkWell(
                    onTap: () {
                      // Navigate to the BusDetailPage with the selected bus data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Starthetrip(),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4, // Add some elevation
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white54, // Changed to solid black
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.directions_bus,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Bus Name: ${bus['busName']}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.confirmation_number,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Register Number: ${bus['busRegisterNumber']}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  'Start Destination: ${bus['startDestination']}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.black, size: 24),
                                const SizedBox(width: 8.0),
                                Text(
                                  'End Destination: ${bus['endDestination']}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is BusDetailsError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No bus details available.'));
          },
        ),
      ),
    );
  }
}
