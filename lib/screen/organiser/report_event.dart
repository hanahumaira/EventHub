import 'package:eventhub/model/user.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/organiser/organiser_homepage.dart';

class ReportPage extends StatefulWidget {
  final User passUser;

  const ReportPage({super.key, required this.passUser});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool showOverview = true;
  int pastEventsCount = 0;
  int futureEventsCount = 0;
  int totalRegistrations = 0;

  @override
  void initState() {
    super.initState();
    fetchEventData();
  }

  Future<void> fetchEventData() async {
    final today = DateTime.now();

    try {
      // Fetch past events
      final pastEventsQuery = await FirebaseFirestore.instance
          .collection('eventData')
          .where('organizer', isEqualTo: widget.passUser.email)
          .where('date', isLessThan: today)
          .get();

      print('Past Events: ${pastEventsQuery.docs.length}');
      setState(() {
        pastEventsCount = pastEventsQuery.docs.length;
      });

      // Fetch future events
      final futureEventsQuery = await FirebaseFirestore.instance
          .collection('eventData')
          .where('organizer', isEqualTo: widget.passUser.email)
          .where('date', isGreaterThanOrEqualTo: today)
          .get();

      print('Future Events: ${futureEventsQuery.docs.length}');
      setState(() {
        futureEventsCount = futureEventsQuery.docs.length;
      });

      // Fetch total registrations
      num totalRegs = 0;
      for (var doc in pastEventsQuery.docs) {
        totalRegs += doc['registrations'] ?? 0;
      }
      for (var doc in futureEventsQuery.docs) {
        totalRegs += doc['registrations'] ?? 0;
      }
      setState(() {
        totalRegistrations = totalRegs.round();
      });

      print('Total Registrations: $totalRegs');
      setState(() {
        totalRegistrations = totalRegs.round();
      });
    } catch (e) {
      print('Error fetching event data: $e');
    }
  }

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              _logoutAndNavigateToLogin(context);
            },
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
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
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 100, 8, 222),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(),
            FooterIconButton(
              icon: Icons.home,
              label: "Home",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrganiserHomePage(passUser: widget.passUser),
                  ),
                );
              },
            ),
            const Spacer(),
            FooterIconButton(
              icon: Icons.event,
              label: "My Event",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyEvent(passUser: widget.passUser),
                  ),
                );
              },
            ),
            const Spacer(),
            FooterIconButton(
              icon: Icons.add,
              label: "Create Event",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateEventPage(passUser: widget.passUser),
                  ),
                );
              },
            ),
            const Spacer(),
            FooterIconButton(
              icon: Icons.analytics,
              label: "Report",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportPage(passUser: widget.passUser),
                  ),
                );
              },
            ),
            const Spacer(),
            FooterIconButton(
              icon: Icons.person,
              label: "Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(passUser: widget.passUser),
                  ),
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget buildOverview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Past Events',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 100, 8, 222),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$pastEventsCount',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 100, 8, 222),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Future Events',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 100, 8, 222),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$futureEventsCount',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 100, 8, 222),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Registrations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 100, 8, 222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$totalRegistrations',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 100, 8, 222),
                    ),
                  ),
                ],
              ),
            ),
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
                          color: Color.fromARGB(255, 67, 12, 139)),
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
                          style: TextStyle(
                              color: Color.fromARGB(255, 100, 8, 222)),
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
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

void _logoutAndNavigateToLogin(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const Login()),
    (Route<dynamic> route) => false,
  );
}
