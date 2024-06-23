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

  const MyEventSaved(
      {Key? key, required this.passUser, required this.appBarTitle})
      : super(key: key);

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
        final savedEventsList =
            documentSnapshot.data()?['mysaved'] as List<dynamic>? ?? [];

        print('Saved event IDs: $savedEventsList');

        if (savedEventsList.isNotEmpty) {
          List<Event> fetchedEvents = [];

          for (var eventId in savedEventsList) {
            final eventDoc = await FirebaseFirestore.instance
                .collection('eventData')
                .doc(eventId)
                .get();

            if (eventDoc.exists) {
              final eventData = eventDoc.data();
              if (eventData != null) {
                // Handle dateTime field which could be either Timestamp or String
                DateTime eventDateTime;
                if (eventData['dateTime'] is Timestamp) {
                  eventDateTime = (eventData['dateTime'] as Timestamp).toDate();
                } else if (eventData['dateTime'] is String) {
                  eventDateTime =
                      DateTime.parse(eventData['dateTime'] as String);
                } else {
                  throw Exception("Unsupported type for dateTime field");
                }

                // Handle fee field which could be either "Free" or a numerical value
                double eventFee;
                if (eventData['fee'] == "Free") {
                  eventFee = 0.0; // Assuming 'Free' means 0.0
                } else if (eventData['fee'] is num) {
                  eventFee = (eventData['fee'] as num).toDouble();
                } else if (eventData['fee'] is String) {
                  eventFee = double.parse(eventData['fee'] as String);
                } else {
                  throw Exception("Unsupported type for fee field");
                }

                // Ensure imageURL is handled as a List<dynamic> and convert it to List<String>
                List<String> eventImages;
                if (eventData['imageURLs'] is List) {
                  eventImages = List<String>.from(eventData['imageURLs']);
                } else {
                  eventImages = ['lib/images/mainpage.png']; // Default image
                }

                final event = Event(
                  id: eventDoc.id,
                  event: eventData['event'] ?? '',
                  dateTime: eventDateTime,
                  location: eventData['location'] ?? '',
                  fee: eventFee,
                  organiser: eventData['organiser'] ?? '',
                  category: eventData['category'] ?? '',
                  details: eventData['details'] ?? '',
                  timestamp: eventData['timestamp'] ?? Timestamp.now(),
                  imageURL: eventImages,
                );
                fetchedEvents.add(event);
              }
            }
          }

          setState(() {
            _savedEvents = fetchedEvents;
            _isLoading = false;
          });
          print('Successfully fetched saved events: $_savedEvents');
        } else {
          print('No saved events found for user: ${widget.passUser.name}');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('No document found for user: ${widget.passUser.name}');
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

  Future<void> _unsaveEvent(Event event) async {
    try {
      // Get the document for the current user
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('mysave_event')
          .doc(widget.passUser.name)
          .get();

      if (documentSnapshot.exists) {
        final savedEventsList =
            documentSnapshot.data()?['mysaved'] as List<dynamic>? ?? [];

        // Remove the event ID from the saved events list
        savedEventsList.remove(event.id);

        // Update the document with the new list
        await FirebaseFirestore.instance
            .collection('mysave_event')
            .doc(widget.passUser.name)
            .update({'mysaved': savedEventsList});

        // Update the state to remove the event from the local list
        setState(() {
          _savedEvents?.remove(event);
        });

        print('Event successfully unsaved');
      } else {
        print('No document found for user: ${widget.passUser.name}');
      }
    } catch (e) {
      print('Error unsaving event: $e');
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
                      onDelete: () => _unsaveEvent(event),
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            leading: SizedBox(
              width: 80,
              child: Image.network(
                event.imageURL != null && event.imageURL!.isNotEmpty
                    ? event.imageURL![0]
                    : 'lib/images/mainpage.png',
                fit: BoxFit.cover,
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
                icon: const Icon(Icons.bookmark, color: Colors.red),
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
          title: const Text("Unsave Event"),
          content: const Text("Are you sure you want to unsave this event?"),
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
              child: const Text("Unsave"),
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
            Image.network(
              event.imageURL != null && event.imageURL!.isNotEmpty
                  ? event.imageURL![0]
                  : 'lib/images/mainpage.png',
              fit: BoxFit.cover,
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
                Text(
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
