import 'package:eventhub/homepage/organiser/create_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class MyEvent extends StatefulWidget {
  const MyEvent({super.key});

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  bool showFutureEvents =
      true; // Flag to determine whether to show future or past events

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
      ),
      body: Container(
        color: Colors.black, // Set background color to purple
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SizedBox(height: 20),
                    // Text('These are all your events!', style: TextStyle(fontSize: 20, color: Colors.white)),
                    // SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search your event',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          // Implement search functionality here
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreateEventPage()),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.purple, // Adjust color as needed
                            size: 30, // Adjust size as needed
                          ),
                          SizedBox(
                              width:
                                  10), // Adjust spacing between icon and text
                          Text(
                            'Create Event',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showFutureEvents = true; // Show future events
                            });
                          },
                          child: const Text('Future Events'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showFutureEvents = false; // Show past events
                            });
                          },
                          child: const Text('Past Events'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(thickness: 2, color: Colors.white),
                    const SizedBox(height: 20),
                    buildEventList(
                        context), // Display events based on selected filter
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEventList(BuildContext context) {
    // Placeholder for event data
    List<Map<String, dynamic>> events = [
      {
        'picture': 'lib/images/gmailLogo.png',
        'date': 'May 15, 2024',
        'time': '10:00 AM',
        'eventName': 'Event 1',
        'location': 'Location 1',
      },
      {
        'picture': 'lib/images/logo.png',
        'date': 'May 20, 2024',
        'time': '3:00 PM',
        'eventName': 'Event 2',
        'location': 'Location 2',
      },
      // Add more events here as needed
    ];

    // Filter events based on past/future
    List<Map<String, dynamic>> filteredEvents = showFutureEvents
        ? events
            .where((event) => DateFormat('MMM d, yyyy')
                .parse(event['date'])
                .isAfter(DateTime.now()))
            .toList()
        : events
            .where((event) => DateFormat('MMM d, yyyy')
                .parse(event['date'])
                .isBefore(DateTime.now()))
            .toList();

    return Column(
      children: filteredEvents.map((event) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ListTile(
            leading: Image.asset(
              event['picture'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(event['eventName'],
                style: const TextStyle(color: Colors.black)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${event['date']}',
                    style: const TextStyle(color: Colors.black)),
                Text('Time: ${event['time']}',
                    style: const TextStyle(color: Colors.black)),
                Text('Location: ${event['location']}',
                    style: const TextStyle(color: Colors.black)),
              ],
            ),
            onTap: () {
              // Handle event tap
            },
          ),
        );
      }).toList(),
    );
  }
}

class FooterIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FooterIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: Colors.white,
      tooltip: label,
    );
  }
}
