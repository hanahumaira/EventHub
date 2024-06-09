import 'package:eventhub/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/model/event.dart';
import 'package:intl/intl.dart'; // Import DateFormat for date formatting

class ReportPage extends StatefulWidget {
  final User passUser;
  const ReportPage({super.key, required this.passUser});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool showOverview = true;
  List<Event> _myevent = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('eventData')
          .where('organiser', isEqualTo: widget.passUser.name)
          .get();

       final events = querySnapshot.docs.map((doc) {
      // Access registration data directly from 'doc'
      print('Registration data: ${doc.data()['registration']}');
      return Event.fromSnapshot(doc);
    }).toList();

      setState(() {
        _myevent = events;
      });
      print('Successfully fetching event!');
      // Inside _fetchEvents method

    } catch (e) {
      print('Error fetching event: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 3, 33),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
        elevation: 0,
        title: const Text(
          "Report",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
              child: ToggleButtons(
                isSelected: [showOverview, !showOverview],
                onPressed: (index) {
                  setState(() {
                    showOverview = index == 0;
                  });
                },
                color: Colors.white,
                selectedColor: const Color.fromARGB(255, 100, 8, 222),
                fillColor: Colors.white,
                borderColor: Colors.white,
                selectedBorderColor: const Color.fromARGB(255, 100, 8, 222),
                borderRadius: BorderRadius.circular(8.0),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 140, // Increase width as needed
                      height: 50, // Increase height as needed
                      child: Center(
                        child: Text(
                          'Overview',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 140, // Increase width as needed
                      height: 50, // Increase height as needed
                      child: Center(
                        child: Text(
                          'Events',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: showOverview ? buildOverview() : buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget buildOverview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Past Events: 10',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Upcoming Events: 5',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Registrations: 150',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

Widget buildEventList() {
  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: _myevent.length,
    itemBuilder: (context, index) {
      final event = _myevent[index];
      return Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: ListTile(
          leading: Icon(
            Icons.event,
            color: Color.fromARGB(255, 100, 8, 222),
          ),
          title: Text(
            event.event,
            style: TextStyle(
              color: Color.fromARGB(255, 100, 8, 222),
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${DateFormat.yMMMMd().format(event.dateTime)} at ${event.location}',
            style: const TextStyle(color: Color.fromARGB(179, 72, 60, 70)),
          ),
          trailing: Icon(Icons.arrow_forward_ios,
              color: Color.fromARGB(255, 100, 8, 222)),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Text(
                    event.event,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 67, 12, 139)
                      ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person,
                              color: Color.fromARGB(255, 100, 8, 222)),
                          SizedBox(width: 8),
                          Text('Registrations: ${event.registration ?? 0}'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.share,
                              color: Color.fromARGB(255, 100, 8, 222)),
                          SizedBox(width: 8),
                          Text('Shared: ${index * 5}'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.bookmark,
                              color: Color.fromARGB(255, 100, 8, 222)),
                          SizedBox(width: 8),
                          Text('Saved: ${event.saved ?? 0}'),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style:
                            TextStyle(color: Color.fromARGB(255, 100, 8, 222)),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    },
  );
}

}
