import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Pages/startthetrip/starthetrip.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Timeschedule(),
    );
  }
}

class Timeschedule extends StatefulWidget {
  @override
  _TimescheduleState createState() => _TimescheduleState();
}

class _TimescheduleState extends State<Timeschedule> {
  String dropdownValue = 'Today';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Save Your Bus'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StartTheTrip()));
            },
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple[50],
                border: Border.all(width: 1, color: Colors.purple),
                borderRadius: BorderRadius.circular(7), // Add border radius
              ),
              child: DropdownButton<String>(
                focusColor: Colors.amber,
                value: dropdownValue,
                underline: const SizedBox(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
                items: ['Today', 'Tomorrow']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('3:15 PM'),
                        Row(
                          children: [
                            Text('Trivandrum'),
                            Icon(Icons.compare_arrows),
                            Text('Bangalore'),
                          ],
                        ),
                        Text('10:00 AM'),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ]));
  }
}
