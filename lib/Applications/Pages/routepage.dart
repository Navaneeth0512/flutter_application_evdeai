import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RoutePage(),
    );
  }
}

class RoutePage extends StatefulWidget {
  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  String dropdownValue = 'Today';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Use pop to go back
          },
        ),
        title: const Text(
          'Your Route',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DropdownButton moved to the body
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
          // ListView for route tiles
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              children: const [
                RouteTile(
                  time: '06:30 PM',
                  location: 'Kochi hub',
                  status: 'On time',
                  isCurrent: true,
                  showDashedLine: true,
                  showBusIcon: true, // Show bus icon for Kochi hub
                ),
                RouteTile(
                  time: '07:30 PM',
                  location: 'Alappuzha',
                  status: 'On time',
                  isCurrent: false,
                  showDashedLine: true,
                ),
                RouteTile(
                  time: '08:30 PM',
                  location: 'Kollam',
                  status: '10min delay',
                  isCurrent: false,
                  showDashedLine: true,
                ),
                RouteTile(
                  time: '09:30 PM',
                  location: 'Kottayam',
                  status: '',
                  isCurrent: false,
                  showDashedLine: true,
                ),
                RouteTile(
                  time: '10:30 PM',
                  location: 'Pathanamthitta',
                  status: '',
                  isCurrent: false,
                  showDashedLine: true,
                ),
                RouteTile(
                  time: '11:30 PM',
                  location: 'Thiruvananthapuram',
                  status: '',
                  isCurrent: false,
                  showDashedLine: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RouteTile extends StatefulWidget {
  final String time;
  final String location;
  final String status;
  final bool isCurrent;
  final bool showDashedLine;
  final bool showBusIcon;

  const RouteTile({
    super.key,
    required this.time,
    required this.location,
    required this.status,
    required this.isCurrent,
    this.showDashedLine = true,
    this.showBusIcon = false,
  });

  @override
  _RouteTileState createState() => _RouteTileState();
}

class _RouteTileState extends State<RouteTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isCurrent = false; // Initialize directly

  @override
  void initState() {
    super.initState();
    _isCurrent = widget.isCurrent; // Set the value from the widget property
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {
          // Update the local isCurrent status based on the animation value
          _isCurrent = _animation.value >= 0.5;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Column
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            widget.time,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        // Timeline and Dotted Line
        Column(
          children: [
            // Bus Icon positioned above the timeline point
            if (widget.showBusIcon)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 600 * _animation.value), // Move down
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Icon(Icons.directions_bus,
                          color: Colors.purple, size: 20),
                    ),
                  );
                },
              ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _isCurrent ? Colors.purple : Colors.grey,
                shape: BoxShape.circle,
                border: _isCurrent
                    ? Border.all(color: Colors.white, width: 2)
                    : null,
              ),
            ),
            if (widget.showDashedLine)
              Container(
                width: 2,
                height: 80, // Adjust height as needed for spacing
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Location and Status Row
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Location
              Text(
                widget.location,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Status on the right side
              if (widget.status.isNotEmpty)
                Text(
                  widget.status,
                  style: TextStyle(
                    color: widget.status.contains('delay')
                        ? Colors.red
                        : Colors.green,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
