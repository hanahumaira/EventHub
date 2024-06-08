import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';

import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/organiser/edit_event.dart';
import 'package:eventhub/screen/organiser/organiser_homepage.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventhub/screen/organiser/event_details.dart';

class MyEvent extends StatefulWidget {
  final User passUser;

  const MyEvent({super.key, required this.passUser});

  @override
  State<MyEvent> createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  List<Event> _myevent = [];
  List<Event> _filteredEvents = [];
  String _searchQuery = "";
  String _selectedCategory = "All"; // Added selected category
  String _filter = "All";

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }
  Future<void> _fetchEvents() async {
    try {
      final querySnapshot =
          await FirebaseFirestore
          .instance.collection('eventData')
          .where('organiser', isEqualTo: widget.passUser.name)
          .get();
      final events =
          querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();

      setState(() {
        _myevent = events;
        _filteredEvents = events;
      });
      print('Successfully fetching event!');
    } catch (e) {
      print('Error fetching event: $e');
    }
  }
  void _filterEvents() {
    final now = DateTime.now();
    setState(() {
      _filteredEvents = _myevent.where((event) {
        final matchesSearch =
            event.event.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory =
            _selectedCategory == "All" || event.category == _selectedCategory;
        final matchesOrganiser = event.organiser == widget.passUser.name;
        if (_filter == "All") {
          return matchesSearch && matchesCategory && matchesOrganiser;
        } else if (_filter == "Past") {
          return event.dateTime.isBefore(now) &&
              matchesCategory &&
              matchesOrganiser;
        } else if (_filter == "Today") {
          return event.dateTime.year == now.year &&
              event.dateTime.month == now.month &&
              event.dateTime.day == now.day &&
              matchesCategory &&
              matchesOrganiser;
        } else if (_filter == "Future") {
          return event.dateTime.isAfter(now) &&
              matchesCategory &&
              matchesOrganiser;
        }
        return false;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterEvents();
    });
  }

  void _onFilterChanged(String? filter) {
    setState(() {
      _filter = filter ?? 'All';
      _filterEvents();
    });
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category ?? 'All';
      _filterEvents();
    });
  }

void _confirmDelete(Event event) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Event"),
        content: Text("Do you want to delete the event: ${event.event}?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Delete"),
            onPressed: () {
              _deleteEvent(event); // Call the _deleteEvent method to delete the event
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 8, 222),
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
          "My Event",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: const Color.fromARGB(255, 100, 8, 222),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Search event..',
                              hintStyle: const TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 15),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                "Categories",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 2,
                            children: [
                              _buildCategoryButton('All'),
                              _buildCategoryButton('Education'),
                              _buildCategoryButton('Sport'),
                              _buildCategoryButton('Charity'),
                              _buildCategoryButton('Festival'),
                              _buildCategoryButton('Entertainment'),
                              _buildCategoryButton('Workshop'),
                              _buildCategoryButton('Talk'),
                              _buildCategoryButton('Conference'),
                              _buildCategoryButton('Exhibition'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    color: Colors.black,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Events",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              value: _filter,
                              icon: const Icon(Icons.arrow_downward,
                                  color: Colors.white),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.white),
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: _onFilterChanged,
                              items: <String>[
                                'All',
                                'Past',
                                'Today',
                                'Future'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              dropdownColor: Colors.grey[800],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: buildEventCards(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 100, 8, 222),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                FooterIconButton(
                  icon: Icons.event,
                  label: "My Event",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyEvent(passUser: widget.passUser),
                      ),
                    );
                  },
                ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return ElevatedButton(
      onPressed: () => _onCategoryChanged(category),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 30),
        backgroundColor:
            _selectedCategory == category ? Colors.blueAccent : Colors.white,
      ),
      child: Text(
        category,
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

void _deleteEvent(Event event) async {
  try {
    // Delete the event from Firestore
    await FirebaseFirestore.instance
        .collection('eventData')
        .doc(event.id)
        .delete();

    // Remove the event from the local list and refresh
    setState(() {
      _myevent.remove(event);
      _filterEvents(); // Refresh the event list
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event deleted successfully")),
    );
  } catch (e) {
    print('Error deleting event: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to delete event")),
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

  List<Widget> buildEventCards() {
    return _filteredEvents.map((event) {
      return Card(
        elevation: 4,
        color: Colors.grey[900],
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          leading: SizedBox(
            width: 80,
            child: Image.network(
              event.imageURL ?? 'lib/images/mainpage.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.green),
                onPressed: () {
                _editEvent(event);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _confirmDelete(event);
                },
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EventDetailsPage(event: event, passUser: widget.passUser),
              ),
            );
          },
        ),
      );
    }).toList();
  }

void _editEvent(Event event) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditEventPage(
        event: event,
        passUser: widget.passUser,
        fee: event.fee ?? 0.0, // Set fee to event.fee if available, otherwise set to 0.0
      ),
    ),
  ).then((updatedEvent) {
    if (updatedEvent != null) {
      setState(() {
        final index = _myevent.indexWhere((e) => e.id == event.id);
        if (index != -1) {
          _myevent[index] = updatedEvent;
          _filterEvents();
        }
      });
    }
  });
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
