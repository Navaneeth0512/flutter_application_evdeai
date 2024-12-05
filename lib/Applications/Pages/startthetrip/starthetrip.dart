import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/Sharebuspage';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_evdeai/Applications/Pages/routepage.dart';
import 'package:flutter_application_evdeai/Applications/Pages/timeschedule.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_elevated_button.dart';
import 'start_trip_bloc.dart'; // Import your BLoC here

// Stateless Widget Wrapper
class StartTheTripWrapper extends StatelessWidget {
  const StartTheTripWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final busNumber = args?['busNumber'] ?? 'DefaultBusName';

    return BlocProvider(
      create: (context) => StartTripBloc(busNumber), // Provide the BLoC
      child: StartTheTrip(busDetails: args), // Pass busData to StartTheTrip
    );
  }
}

// Stateful Widget
class StartTheTrip extends StatefulWidget {
  final Map<String, dynamic>? busDetails;

  const StartTheTrip({super.key, this.busDetails});

  @override
  State<StartTheTrip> createState() => _StartTheTripState();
}

class _StartTheTripState extends State<StartTheTrip> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No need to fetch args again since we are passing it through the constructor
  }

  @override
  Widget build(BuildContext context) {
    final sharelivelocationbloc = BlocProvider.of<StartTripBloc>(context);
    final busName = widget.busDetails?['busName'] ?? 'Default Bus Name';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(busName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Adjusted padding
        child: BlocBuilder<StartTripBloc, StartTripState>(
          builder: (context, state) {
            bool isTripActive =
                sharelivelocationbloc.sharelivelocation.isTripActive;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/bus.jpg', fit: BoxFit.contain),
                const SizedBox(height: 20), // Space between image and button
                CustomElevatedButton(
                  onTap: () {
                    sharelivelocationbloc.add(StartTripToggleEvent());
                  },
                  text: isTripActive ? 'Stop your Trip' : 'Start your Trip',
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomElevatedButton(
                      onPressed: () {
                        // Navigate to Time Schedule page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Timeschedule()),
                        );
                      },
                      text: 'Time Schedule',
                      onTap: () {},
                    ),
                    CustomElevatedButton(
                      onPressed: () {
                        // Navigate to Route page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RoutePage()),
                        );
                      },
                      text: 'Your Route',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    // Navigate to Share Your Bus page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShareBusPage(), // Pass arguments if needed
                      ),
                    );
                  },
                  child: Text(
                    'Share Your Bus',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
