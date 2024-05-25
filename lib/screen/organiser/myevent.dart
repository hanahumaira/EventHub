import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/login_page.dart';
// import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/organiser/edit_event.dart';
import 'package:eventhub/screen/organiser/organiser_homepage.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventhub/screen/organiser/event_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyEvent extends StatefulWidget {
  final User? passUser;

  const MyEvent({Key? key, required this.passUser}) : super(key: key);

  @override
  State<MyEvent> createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  List<Event> dummyEvents = [
    Event(
        event: "Proposal MAP",
        dateTime: DateTime.now().add(Duration(days: 1)),
        location: "N28",
        organiser: "MobileCraft",
        details: "Presentation for MAP project from every group in section 3.",
        fee: 00.0,
        imageURL: "lib/images/mainpage.png",
        category: "Education",
        timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30))),
    Event(
        event: "AI Talk",
        dateTime: DateTime.now().add(Duration(days: 2)),
        location: "N28",
        organiser: "MobileCraft",
        details: "A talk about AI and its future's pros and cons",
        fee: 00.0,
        imageURL: "lib/images/mainpage.png",
        category: "Exhibition",
        timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30))),
    Event(
        event: "Program Kerjaya",
        dateTime: DateTime.now().add(Duration(days: 5)),
        location: "N28",
        organiser: "MobileCraft",
        details:
            "Program for computer science students to find their networks and job opportunities.",
        fee: 00.0,
        imageURL: "lib/images/mainpage.png",
        category: "Talk",
        timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30))),
    // Add more dummy events here
  ];

  List<Event> _filteredEvents = [];
  String _searchQuery = "";
  String _selectedCategory = "All"; // Added selected category
  String _filter = "All";

  @override
  void initState() {
    super.initState();
    _filterEvents();
  }

  void _filterEvents() {
    final now = DateTime.now();
    setState(() {
      _filteredEvents = dummyEvents.where((event) {
        final matchesSearch =
            event.event.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory =
            _selectedCategory == "All" || event.category == _selectedCategory;
        final matchesOrganiser = event.organiser == "MobileCraft";
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
          title: Text("Delete Event"),
          content: Text("Do you want to delete the event: ${event.event}?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteEvent(
                    event); // Call the _deleteEvent method to delete the event
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
        title: Text(
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                              icon: Icon(Icons.arrow_downward,
                                  color: Colors.white),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.white),
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
                                    style: TextStyle(color: Colors.white),
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         OrganiserHomePage(passUser: widget.passUser),
                    //   ),
                    // );
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         CreateEventPage(user: widget.passUser),
                    //   ),
                    // );
                  },
                ),
                FooterIconButton(
                  icon: Icons.person,
                  label: "Profile",
                  onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ProfileScreen(),
                    //     ),
                    //   );
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
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  void _deleteEvent(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Event"),
          content: Text("Do you want to delete the event: ${event.event}?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without deleting
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog first

                setState(() {
                  dummyEvents.remove(event);
                  _filterEvents(); // Refresh the event list
                });

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Event deleted successfully")));
              },
            ),
          ],
        );
      },
    );
  }

  void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
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
          leading: Image.asset(
            event.imageURL,
            fit: BoxFit.cover,
            width: 80,
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
                icon: Icon(Icons.edit, color: Colors.green),
                onPressed: () {
                  _navigateToEditEvent(
                      event); // Navigate to the edit event page
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
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
                builder: (context) => EventDetailsPage(event: event),
              ),
            );
          },
        ),
      );
    }).toList();
  }

  void _navigateToEditEvent(Event event) {
    // Navigate to the EditEventPage, passing the event object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditEventPage(
          event: '',
        ),
      ),
    );
  }
}

class FooterIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FooterIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
