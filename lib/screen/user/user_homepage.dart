import 'package:eventhub/screen/user/register_event.dart';
import 'package:flutter/material.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/model/event.dart';
import 'package:eventhub/screen/event_page.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:eventhub/screen/user/myevent_saved.dart';
import 'package:eventhub/screen/user/myevent_reg.dart';


class UserHomePage extends StatefulWidget {
  final User passUser;

  const UserHomePage({super.key, required this.passUser});

  @override
  State<UserHomePage> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHomePage> {
  final List<Event> dummyEvents = [
      Event(
      event: "Sprint 2 MAP",
      date: DateTime.now().add(Duration(days: 2)),
      location: "N28",
      // registration: 40,
      organiser: "UTM",
      details: "Presentation for MAP project from every groups in section 3.",
      fee: 00.0,
      image: "lib/images/mainpage.png",
      category: "Education",
    ),
  Event(
    event: "Football Match",
    date: DateTime.now(),
    location: "Stadium A",
    // registration: 150,
    organiser: "Sports Club",
    details: "Exciting football match between top teams.",
    fee: 20.0,
     image: "lib/images/mainpage.png",
     category: "Entertainment",
  ),
  Event(
    event: "Tech Conference",
    date: DateTime.now().add(Duration(days: 1)),
    location: "Convention Center",
    // registration: 200,
    organiser: "Tech Corp",
    details: "Latest trends in technology.",
    fee: 50.0,
image: "lib/images/mainpage.png",
category: "Conference",
),

  Event(
    event: "Art Exhibition",
    date: DateTime.now().add(Duration(days: 2)),
    location: "Art Gallery",
    // registration: 80,
    organiser: "Art Society",
    details: "Showcasing contemporary art pieces.",
    fee: 10.0,
image: "lib/images/mainpage.png",  
category: "Exhibition",
),
  Event(
    event: "Music Concert",
    date: DateTime.now().add(Duration(days: 3)),
    location: "Outdoor Arena",
    // registration: 300,
    organiser: "Music Productions",
    details: "Live performances by famous artists.",
    fee: 40.0,
image: "lib/images/mainpage.png",  
category: "Entertainment",
),
  Event(
    event: "Food Festival",
    date: DateTime.now().add(Duration(days: 4)),
    location: "City Park",
    // registration: 100,
    organiser: "Culinary Society",
    details: "A variety of cuisines from around the world.",
    fee: 15.0,
image: "lib/images/mainpage.png", 
category: "Festival", ),
  Event(
    event: "Book Fair",
    date: DateTime.now().add(Duration(days: 5)),
    location: "Exhibition Hall",
    // registration: 120,
    organiser: "Publishing House",
    details: "Discover the latest books and authors.",
    fee: 25.0,
image: "lib/images/mainpage.png", 
category: "Festival",
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
        final matchesSearch = event.event.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == "All" || event.category == _selectedCategory; // Check if event matches selected category
        if (_filter == "All") {
          return matchesSearch && matchesCategory;
        } else if (_filter == "Past") {
          return event.date.isBefore(now) && matchesCategory;
        } else if (_filter == "Today") {
          return event.date.year == now.year && event.date.month == now.month && event.date.day == now.day && matchesCategory;
        } else if (_filter == "Future") {
          return event.date.isAfter(now) && matchesCategory;
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
      backgroundColor: Colors.black, // Set the background color to black
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 100, 8, 222), // Set the AppBar color to purple
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
          "Participant",
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
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
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
                          scrollDirection: Axis.horizontal, // Scroll horizontally
                          child: Wrap(
                            spacing: 5,
                            runSpacing: 2,
                            children: [
                              _buildCategoryButton('All'), // Added category buttons
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
                              padding: const EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
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
                              icon: Icon(Icons.arrow_downward, color: Colors.white),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: Colors.white),
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              onChanged: _onFilterChanged,
                              items: <String>['All', 'Past', 'Today', 'Future'].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              dropdownColor: Colors.grey[800], // Set dropdown box color to grey
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
          //navbar
          Container(
            color: const Color.fromARGB(255, 100, 8, 222), // Set the background color to purple
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FooterIconButton(
                  icon: Icons.home,
                  label: "Home",
                  onPressed: () {
              //          Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const UserHomePage(passUser: loggedInUser),
              //   ),
              // );
                  },
                ),
                FooterIconButton(
                  icon: Icons.bookmark,
                  label: "Saved",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyEventSaved(),
                      ),
                    );
                  },
                ),
                FooterIconButton(
                  icon: Icons.how_to_reg,
                  label: "Registered",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyEventReg(),
                      ),
                    );
                  },
                ),
                FooterIconButton(
                  icon: Icons.account_circle,
                  label: "Profile",
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfileScreen(passUser: widget.passUser),
                    //   ),
                    // );
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
        backgroundColor: _selectedCategory == category ? Colors.blueAccent : Colors.white, // Use backgroundColor instead of primary
      ),
      child: Text(
        category,
        style: TextStyle(fontSize: 10),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          leading: Image.asset(
            event.image,
            fit: BoxFit.cover,
            width: 80,
          ),
          title: Text(
            event.event,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            '${DateFormat.yMMMMd().format(event.date)} at ${event.location}',
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
        builder: (context) => Login(),
      ),
    );
  }
}

class FooterIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FooterIconButton({
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

  const EventDetailsPage({required this.event});

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
            Image.asset(event.image),
            const SizedBox(height: 16),
            Text(
              event.event,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white), // Set text color to white
            ),
            SizedBox(height: 8.0),
                Row(
              children: [
                Icon(Icons.date_range, color: Colors.white), // Icon for date
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMMd().format(event.date),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8.0),

             Row(
              children: [
                Icon(Icons.location_on, color: Colors.white), // Icon for location
                const SizedBox(width: 8),
                Text(
                  event.location,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8.0),
              Row(
              children: [
                Icon(Icons.attach_money, color: Colors.white), // Icon for fee
                const SizedBox(width: 8),
                Text(
                  '${event.fee.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            
            SizedBox(height: 8.0),
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
            SizedBox(height: 8.0),
              Row(
              children: [
                Icon(Icons.archive, color: Colors.white), // Icon for category
                const SizedBox(width: 8),
                Text(
                  event.category,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              'Details: ${event.details}',
              style: TextStyle(fontSize: 16.0, color: Colors.white), // Set text color to white
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add save event functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 140, 40, 222), // Purple with a lighter shade
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bookmark_border, color: Colors.white), // Custom save icon
                      const SizedBox(width: 8),
                      const Text('Save', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterEventPage(event: event),
      ),
    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 140, 40, 222), // Purple with a lighter shade
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.event_available, color: Colors.white), // Icon for register event
                      const SizedBox(width: 6),
                      const Text('Register', style: TextStyle(color: Colors.white)),
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
