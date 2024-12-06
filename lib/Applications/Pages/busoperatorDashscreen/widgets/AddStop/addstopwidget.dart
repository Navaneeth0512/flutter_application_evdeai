import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_application_evdeai/Applications/pages/busoperatorDashscreen/widgets/AddStop/add_stop_bloc/add_stop_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddStopWrapper extends StatelessWidget {
  final Map<String, dynamic> busData; // Accept busData through constructor

  const AddStopWrapper({Key? key, required this.busData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddStopBloc(),
      child: AddStopsPage(busData: busData), // Pass busData to the page
    );
  }
}

class AddStopsPage extends StatefulWidget {
  final Map<String, dynamic> busData; // Receive busData from constructor

  const AddStopsPage({Key? key, required this.busData}) : super(key: key);

  @override
  State<AddStopsPage> createState() => _AddStopsPageState();
}

class _AddStopsPageState extends State<AddStopsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Stops for ${widget.busData['busName']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final busId = widget.busData['stops'];
              context.read<AddStopBloc>().add(SaveStopsRequested(busId: busId));
            },
          ),
        ],
      ),
      body: BlocBuilder<AddStopBloc, AddStopState>(
        builder: (context, state) {
          if (state is AddStopLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddStopSuccess) {
            // Update the busData with the new stops
            widget.busData['stops'] =
                state.stops; // Add or update the stops array
            return ListView.builder(
              itemCount: state.stops.length,
              itemBuilder: (context, index) {
                final stop = state.stops[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(stop['stopName']),
                    subtitle: Text(stop['time']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Implement stop removal logic if needed
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No stops added.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStopDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddStopDialog(BuildContext context) {
    String stopName = '';
    String stopTime = '';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<AddStopBloc>(),
          child: AlertDialog(
            backgroundColor: backGroundColor,
            title: Text(
              'Add New Stop',
              style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => stopName = value,
                  decoration: InputDecoration(
                    labelText: 'Stop Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const Gap(10),
                TextField(
                  onChanged: (value) => stopTime = value,
                  decoration: InputDecoration(
                    labelText: 'Stop Time (HH:mm)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // keyboardType: TextInputType.none,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (stopName.isNotEmpty && stopTime.isNotEmpty) {
                    // Add the new stop to the stops array in busData
                    final newStop = {
                      'stopName': stopName,
                      'time': stopTime,
                    };
                    widget.busData['stops'] = [
                      ...?widget.busData['stops'],
                      newStop
                    ]; // Add new stop
                    context.read<AddStopBloc>().add(
                          AddStopRequested(stopName, stopTime),
                        );
                  }
                  Navigator.pop(dialogContext); // Close the dialog
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
