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

class _RoutePageState extends State<RoutePage>
    with SingleTickerProviderStateMixin {
  String dropdownValue = 'Today';
  late AnimationController _controller;
  late Animation<double> _animation;
  final int totalStops = 6; // Total number of stops
  int currentStop = 0; // Index of the current stop

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15), // Duration for the animation
      vsync: this,
    )..addListener(() {
        setState(() {
          // Dynamically calculate the current stop based on animation value
          currentStop = (_animation.value * totalStops).round();
        });
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat(); // Start animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  itemCount: totalStops,
                  itemBuilder: (context, index) {
                    return RouteTile(
                      time: '${6 + index}:30 PM',
                      location: 'Stop ${index + 1}',
                      status: index == 2
                          ? '10min delay'
                          : (index < currentStop ? 'on Time' : 'On Way'),
                      isCurrent: index == currentStop,
                      isVisited: index < currentStop,
                      showDashedLine: index != totalStops - 1,
                    );
                  },
                ),
                Positioned(
                  top: _animation.value *
                      (MediaQuery.of(context).size.height - 200), // Dynamic top
                  left: MediaQuery.of(context).size.width / 8 - -43, // Centered
                  child: const Icon(
                    Icons.directions_bus,
                    color: Colors.purple,
                    size: 36,
                  ),
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
  final bool isVisited;
  final bool showDashedLine;

  const RouteTile({
    super.key,
    required this.time,
    required this.location,
    required this.status,
    required this.isCurrent,
    required this.isVisited,
    this.showDashedLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
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
          children: [
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? Colors.purple
                        : isVisited
                            ? Colors.purple[200]
                            : Colors.grey,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                ),
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
        const SizedBox(width: 1),
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
