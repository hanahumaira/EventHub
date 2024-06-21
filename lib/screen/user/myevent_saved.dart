// firebase import
import 'package:cloud_firestore/cloud_firestore.dart';

// page or model import
import 'package:eventhub/model/user.dart';
import 'package:eventhub/model/event.dart';
import 'package:eventhub/screen/user/user_widget.dart';
import 'package:eventhub/screen/login_page.dart';

// others import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class MyEventSaved extends StatefulWidget {
  final User passUser;
  final String appBarTitle;

  const MyEventSaved({Key? key, required this.passUser, required this.appBarTitle}) : super(key: key);

  @override
  _MyEventSavedState createState() => _MyEventSavedState();
}

class _MyEventSavedState extends State<MyEventSaved> {
  List<Event>? _savedEvents;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSavedEvents();
  }

  Future<void> _fetchSavedEvents() async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('mysave_event')
          .doc(widget.passUser.name)
          .get();

      if (documentSnapshot.exists) {
        final eventData = documentSnapshot.data();
        print('Event data retrieved: $eventData');
        if (eventData != null) {
          final event = Event(
            id: eventData['id'] ?? 'N/A',
            event: eventData['eventName'] ?? '',
            dateTime: (eventData['eventDateTime'] as Timestamp).toDate(),
            location: eventData['eventLocation'] ?? '',
            fee: eventData['eventFee']?.toDouble() ?? 0.0,
            organiser: eventData['eventOrganiser'] ?? '',
            category: eventData['eventCategory'] ?? '',
            details: eventData['eventDetails'] ?? '',
            timestamp: eventData['timestamp'] ?? Timestamp.now(),
            imageURL: eventData['eventImage'] ?? 'lib/images/mainpage.png',
          );
          setState(() {
            _savedEvents = [event];
            _isLoading = false;
          });
          print('Successfully fetched saved events: $_savedEvents');
        } else {
          print('Event data is null');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('No event found for user: ${widget.passUser.name}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching saved events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteEvent(Event event) async {
    try {
      await FirebaseFirestore.instance
          .collection('mysave_event')
          .doc(widget.passUser.name)
          .delete();

      setState(() {
        _savedEvents = null;
      });
      print('Event successfully deleted');
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        onNotificationPressed: () {},
        onLogoutPressed: () => _logoutAndNavigateToLogin(context),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : _savedEvents != null
          ? ListView.builder(
        itemCount: _savedEvents!.length,
        itemBuilder: (context, index) {
          final event = _savedEvents![index];
          return EventCard(
            event: event,
            onDelete: () => _deleteEvent(event),
            onShare: () => _shareEvent(context, event),
          );
        },
      )
          : const Center(
        child: Text(
          'No saved events.',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      bottomNavigationBar: CustomFooter(passUser: widget.passUser),
    );
  }

  void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  void _shareEvent(BuildContext context, Event event) {
    // Define the event details to be shared
    final String eventDetails = '''
      Event Name: ${event.event}
      Location: ${event.location}
      Fee: ${event.fee}
      Organizer: ${event.organiser}
      Details: ${event.details}
      ''';

    try {
      // Implement your sharing logic here, for example using Share.share:
      Share.share(eventDetails, subject: 'Check out this event!');
    } catch (e) {
      print('Failed to share event: $e');
    }
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;
  final VoidCallback onShare;

  const EventCard({
    Key? key,
    required this.event,
    required this.onDelete,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: SizedBox(
              width: 80,
              child: Image.network(
                event.imageURL != null && event.imageURL!.isNotEmpty ? 
event.imageURL![0] : 'lib/images/mainpage.png',  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    print('Failed to load image: ${event.imageURL}');
    print('Error: $error');
    print('StackTrace: $stackTrace');
    return Image.asset(
      'lib/images/mainpage.png',
      fit: BoxFit.cover,
    );
  },

              ),
            ),
            title: Text(
              event.event,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${DateFormat.yMMMMd().format(event.dateTime)} at ${event.location}',
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage(event: event),
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  onShare();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(context),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove Event"),
          content: const Text("Are you sure you want to remove this event?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Call the delete function from the parent widget
                onDelete();
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({Key? key, required this.event}) : super(key: key);

  Future<void> _shareEvent(BuildContext context) async {
    // Define the event details to be shared
    final String eventDetails = '''
      Event Name: ${event.event}
      Location: ${event.location}
      Fee: ${event.fee}
      Organizer: ${event.organiser}
      Details: ${event.details}
      ''';

    try {
      // Implement your sharing logic here, for example using Share.share:
      await Share.share(eventDetails, subject: 'Check out this event!');
    } catch (e) {
      print('Failed to share event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(event.event),
          backgroundColor: const Color.fromARGB(255, 100, 8, 222),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                _shareEvent(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Image.network( event.imageURL != null && event.imageURL!.isNotEmpty ? 
event.imageURL![0] : 'lib/images/mainpage.png',  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) {
    print('Failed to load image: ${event.imageURL}');
    print('Error: $error');
    print('StackTrace: $stackTrace');
    return Image.asset(
      'lib/images/mainpage.png',
      fit: BoxFit.cover,
    );
  },
),
    const SizedBox(height: 16),
    Text(
    event.event,
    style: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.white), // Set text color to white
    ),
    const SizedBox(height: 8.0),
    Row(
    children: [
    Icon(Icons.date_range, color: Colors.white), // Icon for date
    const SizedBox(width: 8),
    Text(
    DateFormat.yMMMMd().format(event.dateTime),
    style: const TextStyle(fontSize: 18, color: Colors.white),
    ),
    const SizedBox(width: 16), // Add spacing
    Icon(Icons.access_time, color: Colors.white), // Icon for time
    const SizedBox(width: 8),
    Text(
    DateFormat.Hm().format(event.dateTime),
    style: const TextStyle(fontSize: 18, color: Colors.white),
    ),
    ],
    ),
    const SizedBox(height: 8.0),
    Row(
    children: [
    Icon(Icons.location_on, color: Colors.white),
    const SizedBox(width: 8),
    Text
      (
      event.location,
      style: const TextStyle(fontSize: 18, color: Colors.white),
    ),
    ],
    ),
      const SizedBox(height: 8.0),
      Row(
        children: [
          Icon(Icons.attach_money, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            event.fee!.toStringAsFixed(2),
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
      const SizedBox(height: 8.0),
      Row(
        children: [
          Icon(Icons.person, color: Colors.white), // Icon for organizer
          const SizedBox(width: 8),
          Text(
            event.organiser,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
      const SizedBox(height: 8.0),
      Row(
        children: [
          Icon(Icons.archive, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            event.category,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
      const SizedBox(height: 8.0),
      Text(
        'Details: ${event.details}',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    ],
    ),
        ),
      backgroundColor: Colors.black,
    );
  }
}
