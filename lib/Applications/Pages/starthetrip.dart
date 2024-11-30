import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/Widgets/custom_elevated_button.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Starthetrip(),
    );
  }
}

class Starthetrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Add top padding here
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0), // Adjust the padding value as needed
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/avatar.png'), // Replace with actual image path
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your location'),
                            Text(
                              'Kochi, Kerala',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        const Icon(Icons.notifications),
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: const Text(
                              '24',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Image.asset(
                    'assets/bus.jpg'), // Replace with actual image path
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomElevatedButton(
                    onPressed: () {},
                    text: 'Start The Trip',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {},
                          text: 'Time Schedule',
                          width: null, // Remove infinity width
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {},
                          text: 'Your Route',
                          width: null, // Remove infinity width
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Share the bus',
                      style: TextStyle(
                          color: Colors.orange,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
