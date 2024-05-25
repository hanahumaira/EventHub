//firebase related import
import 'package:cloud_firestore/cloud_firestore.dart';

//page related import
import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:eventhub/screen/organiser/event_details.dart';

//dart import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrganiserHomePage extends StatefulWidget {
  final User passUser;

  const OrganiserHomePage({Key? key, required this.passUser}) : super(key: key);

  @override
  State<OrganiserHomePage> createState() => _OrganiserHomeState();
}

class _OrganiserHomeState extends State<OrganiserHomePage> {
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  String _searchQuery = "";
  String _selectedCategory = "All";
  String _filter = "All";

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  //To fetch event data from firestore
  Future<void> _fetchEvents() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('eventData').get();
      final events =
          querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();

      setState(() {
        _events = events;
        _filteredEvents = events;
      });
    } catch (e) {
      print('Error fetching event: $e');
    }
  }

  //Apply filter to event
  void _filterEvents() {
    final now = DateTime.now();
    setState(() {
      _filteredEvents = _events.where((event) {
        final matchesSearch =
            event.event.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == "All" ||
            event.category ==
                _selectedCategory; // Check if event matches selected category
        if (_filter == "All") {
          return matchesSearch && matchesCategory;
        } else if (_filter == "Past") {
          return event.dateTime.isBefore(now) && matchesCategory;
        } else if (_filter == "Today") {
          return event.dateTime.year == now.year &&
              event.dateTime.month == now.month &&
              event.dateTime.day == now.day &&
              matchesCategory;
        } else if (_filter == "Future") {
          return event.dateTime.isAfter(now) && matchesCategory;
        }
        return false;
      }).toList();
    });
  }

  //Apply search
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterEvents();
    });
  }

  //Apply filter
  void _onFilterChanged(String? filter) {
    setState(() {
      _filter = filter ?? 'All';
      _filterEvents();
    });
  }

  //Apply catergory
  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category ?? 'All';
      _filterEvents();
    });
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
          "Home",
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
                        //Search
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
                        //Category
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
                        //Categories button
                        SingleChildScrollView(
                          scrollDirection:
                              Axis.horizontal, // Scroll horizontally
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 2,
                            children: [
                              _buildCategoryButton(
                                  'All'), // Added category buttons
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0), // Add horizontal padding
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
                              dropdownColor: Colors
                                  .grey[800], // Set dropdown box color to grey
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

          //Footer
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
                        builder: (context) => OrganiserHomePage(
                          passUser: widget.passUser,
                        ),
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
                            CreateEventPage(user: widget.passUser),
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
        backgroundColor: _selectedCategory == category
            ? Colors.blueAccent
            : Colors.white, // Use backgroundColor instead of primary
      ),
      child: Text(
        category,
        style: TextStyle(fontSize: 10),
      ),
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
          // trailing: Text(
          //   'Registration: ${event.registration}',
          //   style: const TextStyle(color: Colors.white70),
          // ),
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
