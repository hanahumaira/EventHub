import 'package:eventhub/screen/admin/organiser_approval.dart';
import 'package:flutter/material.dart';
import 'package:eventhub/model/user.dart';
// import 'package:eventhub/screen/event_page.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:eventhub/model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomePage extends StatefulWidget {
  final User passUser;

  const AdminHomePage({super.key, required this.passUser});

  @override
  State<AdminHomePage> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHomePage> {
  final List<Event> dummyEvents = [
    Event(
      id: '',
      event: "Sprint 2 MAP",
      dateTime: DateTime.now().add(const Duration(days: 2)),
      location: "N28",
      // registration: 40,
      organiser: "UTM",
      details: "Presentation for MAP project from every groups in section 3.",
      fee: 00.0,
      imageURL: "lib/images/mainpage.png",
      category: "Education",
      timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30)),
    ),
    Event(
      id: '',
      event: "Football Match",
      dateTime: DateTime.now(),
      location: "Stadium A",
      // registration: 150,
      organiser: "Sports Club",
      details: "Exciting football match between top teams.",
      fee: 20.0,
      imageURL: "lib/images/mainpage.png",
      category: "Entertainment",
      timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30)),
    ),
    Event(
      id: '',
      event: "Tech Conference",
      dateTime: DateTime.now().add(const Duration(days: 1)),
      location: "Convention Center",
      // registration: 200,
      organiser: "Tech Corp",
      details: "Latest trends in technology.",
      fee: 50.0,
      imageURL: "lib/images/mainpage.png",
      category: "Technology",
      timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30)),
    ),
    Event(
      id: '',
      event: "Art Exhibition",
      dateTime: DateTime.now().add(const Duration(days: 2)),
      location: "Art Gallery",
      // registration: 80,
      organiser: "Art Society",
      details: "Showcasing contemporary art pieces.",
      fee: 10.0,
      imageURL: "lib/images/mainpage.png",
      category: "Exhibition",
      timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30)),
    ),
    Event(
      id: '',
      event: "Music Concert",
      dateTime: DateTime.now().add(const Duration(days: 3)),
      location: "Outdoor Arena",
      // registration: 300,
      organiser: "Music Productions",
      details: "Live performances by famous artists.",
      fee: 40.0,
      imageURL: "lib/images/mainpage.png",
      category: "Entertainment",
      timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30)),
    ),
    Event(
      id: '',
      event: "Food Festival",
      dateTime: DateTime.now().add(const Duration(days: 4)),
      location: "City Park",
      // registration: 100,
      organiser: "Culinary Society",
      details: "A variety of cuisines from around the world.",
      fee: 15.0,
      imageURL: "lib/images/mainpage.png",
      category: "Festival",
      timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30)),
    ),
    Event(
      id: '',
      event: "Book Fair",
      dateTime: DateTime.now().add(const Duration(days: 5)),
      location: "Exhibition Hall",
      // registration: 120,
      organiser: "Publishing House",
      details: "Discover the latest books and authors.",
      fee: 25.0,
      imageURL: "lib/images/mainpage.png",
      category: "Festival",
      timestamp: Timestamp.fromDate(DateTime(2024, 5, 26, 14, 30)),
    ),
  ];

  List<Event> _filteredEvents = [];
  String _searchQuery = "";
  String _selectedCategory = "All"; // Added selected category
  String _filter = "All";

  @override
  void initState() {
    super.initState();
    _filteredEvents = dummyEvents;
  }

  void _filterEvents() {
    final now = DateTime.now();
    setState(() {
      _filteredEvents = dummyEvents.where((event) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          "Welcome Admin!",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
                            const Padding(
                              padding: EdgeInsets.symmetric(
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
          Container(
            color: const Color.fromARGB(255, 100, 8, 222),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FooterIconButton(
                  icon: Icons.home,
                  label: "Home",
                  onPressed: () {},
                ),
                FooterIconButton(
                  icon: Icons.how_to_reg,
                  label: "Organizer",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrganizerApprovalPage(),
                      ),
                    );
                  },
                ),
                // FooterIconButton(
                //   icon: Icons.event,
                //   label: "Event",
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const EventPage(),
                //       ),
                //     );
                //   },
                // ),
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
        style: const TextStyle(fontSize: 10),
      ),
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
            event.imageURL ?? 'lib/images/mainpage.png',
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

  void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
}

class FooterIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FooterIconButton({super.key, 
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.event),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(event.imageURL ?? 'lib/images/mainpage.png'),
            const SizedBox(height: 16),
            Text(
              event.event,
              style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Set text color to white
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.date_range, color: Colors.white), // Icon for date
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMMd().format(event.dateTime),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Colors.white), // Icon for location
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
                const Icon(Icons.attach_money, color: Colors.white), // Icon for fee
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
                const Icon(Icons.person, color: Colors.white), // Icon for organizer
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
                const Icon(Icons.archive, color: Colors.white), // Icon for category
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
              style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white), // Set text color to white
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 140, 40, 222),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Edit Event',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 140, 40, 222),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Delete Event',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
