import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

class MyEvent extends StatefulWidget {
  const MyEvent({Key? key});

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  bool showFutureEvents = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('My Events'),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.purple, // Background color for top section
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'These are all your event!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10), // Adjust spacing between text and search box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search your event',
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(Icons.search, color: Colors.white),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Implement search functionality here
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 20),
                Text(
                  'Event',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),SizedBox(width: 150),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateEventPage(),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 175, 81, 192),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: Row(
    children: [
      Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
      SizedBox(width: 1), // Adjust spacing between icon and text
      Text(
        'Create Event',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    ],
  ),
),

                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
  child: Padding(
    padding: const EdgeInsets.all(25.0), // Adjust padding as needed
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterButton(
                label: 'Future Events',
                selected: showFutureEvents,
                onPressed: () {
                  setState(() {
                    showFutureEvents = true;
                  });
                },
              ),
              FilterButton(
                label: 'Past Events',
                selected: !showFutureEvents,
                onPressed: () {
                  setState(() {
                    showFutureEvents = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          buildEventList(context),
        ],
      ),
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
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Image.asset(
              event['picture'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            title: Text(event['eventName']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${event['date']}'),
                Text('Time: ${event['time']}'),
                Text('Location: ${event['location']}'),
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

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const FilterButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.purple : Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10), // Adjust padding here
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey[400],
          fontSize: 16, // Adjust font size here
        ),
      ),
    );
  }
}

