//firebase related import
import 'package:cloud_firestore/cloud_firestore.dart';

//page or model import
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/organiser_widget.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/model/event.dart';

//others import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  final User passUser;
  final String appBarTitle;

  const ReportPage(
      {super.key, required this.passUser, required this.appBarTitle});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool showOverview = true;
  int pastEventsCount = 0;
  int futureEventsCount = 0;
  int totalRegistrations = 0;
  int totalShared = 0;
  int totalSaved = 0;

  List<Event> _myevent = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    fetchEventData();
  }

  Future<void> fetchEventData() async {
    DateTime now = DateTime.now().toUtc();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('eventData')
          .where('organiser', isEqualTo: widget.passUser.name)
          .get();

      List<Event> allEvents =
          querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();

      List<Event> pastEvents = [];
      List<Event> futureEvents = [];
      int registrations = 0;
      int shared = 0;
      int saved = 0;

      for (Event event in allEvents) {
        if (event.dateTime.isBefore(now)) {
          pastEvents.add(event);
        } else {
          futureEvents.add(event);
        }
        registrations += event.registration ?? 0;
        shared += event.shared ?? 0;
        saved += event.saved ?? 0;
      }

      setState(() {
        pastEventsCount = pastEvents.length;
        futureEventsCount = futureEvents.length;
        totalRegistrations = registrations;
        totalShared = shared;
        totalSaved = saved;
        _myevent = allEvents;
      });
    } catch (e) {
      print('Error fetching and filtering events: $e');
    }
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
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        onNotificationPressed: () {},
        onLogoutPressed: () => _logoutAndNavigateToLogin(context),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
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
                      height: 40, // Increase height as needed
                      child: Center(
                        child: Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 140, // Increase width as needed
                      height: 40, // Increase height as needed
                      child: Center(
                        child: Text(
                          'Events',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
      bottomNavigationBar: CustomFooter(passUser: widget.passUser),
    );
  }

  Widget buildOverview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
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
              Expanded(
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
          Expanded(
            child: Card(
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
                    Center(
                      child: Text(
                        '$totalRegistrations',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 100, 8, 222),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Shared',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 8, 222),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '$totalShared',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 100, 8, 222),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Saved',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 8, 222),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '$totalSaved',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 100, 8, 222),
                        ),
                      ),
                    ),
                  ],
                ),
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
