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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purple[50],
                border: Border.all(width: 1, color: Colors.purple),
                borderRadius: BorderRadius.circular(7),
              ),
              child: DropdownButton<String>(
                value: dropdownValue,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                style: const TextStyle(color: Colors.black),
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
            child: Stack(
              children: [
                // The ListView with RouteTile widgets
                ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  children: const [
                    RouteTile(
                      time: '06:30 PM',
                      location: 'Kochi hub',
                      status: 'On time',
                      isCurrent: true,
                      showDashedLine: true,
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
                // Bus icon animation positioned at the top
                Positioned(
                  top: 0, // Start from the top
                  left: MediaQuery.of(context).size.width / 9 - -45,
                  child: BusIconAnimation(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RouteTile extends StatelessWidget {
  final String time;
  final String location;
  final String status;
  final bool isCurrent;
  final bool showDashedLine;

  const RouteTile({
    super.key,
    required this.time,
    required this.location,
    required this.status,
    required this.isCurrent,
    this.showDashedLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            time,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Dashed line and circle (background elements)
            Column(
              children: [
                // Circular point
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.purple : Colors.grey,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                ),
                // Dashed line
                if (showDashedLine)
                  Container(
                    width: 2,
                    height: 80,
                    color: Colors.grey,
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (status.isNotEmpty)
                Text(
                  status,
                  style: TextStyle(
                    color: status.contains('delay') ? Colors.red : Colors.green,
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

class BusIconAnimation extends StatefulWidget {
  @override
  _BusIconAnimationState createState() => _BusIconAnimationState();
}

class _BusIconAnimationState extends State<BusIconAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          const Duration(seconds: 5), // Adjust duration for smooth animation
      vsync: this,
    )..repeat(reverse: false); // Continuous animation

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset:
              Offset(0, MediaQuery.of(context).size.height * _animation.value),
          child: const Icon(
            Icons.directions_bus,
            color: Colors.purple,
            size: 36, // Slightly larger for visibility
          ),
        );
      },
    );
  }
}
