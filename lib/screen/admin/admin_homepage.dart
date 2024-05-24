import 'package:eventhub/screen/admin/organiser_approval.dart';
import 'package:flutter/material.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/event_page.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:intl/intl.dart';
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

class AdminHomePage extends StatefulWidget {
  final User passUser;

  const AdminHomePage({super.key, required this.passUser});

  @override
  State<AdminHomePage> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHomePage> {
  final List<Event> dummyEvents = [
      Event(
      event: "Sprint 2 MAP",
      date: DateTime.now().add(Duration(days: 2)),
      location: "N28",
      registration: 40,
      organiser: "UTM",
      details: "Presentation for MAP project from every groups in section 3.",
      fee: 00.0,
      image: "lib/images/mainpage.png",
    ),
    Event(
      event: "Football Match",
      date: DateTime.now(),
      location: "Stadium A",
      registration: 150,
      organiser: "Sports Club",
      details: "Exciting football match between top teams.",
      fee: 20.0,
      image: "lib/images/mainpage.png",
    ),
    Event(
      event: "Tech Conference",
      date: DateTime.now().add(Duration(days: 1)),
      location: "Convention Center",
      registration: 200,
      organiser: "Tech Corp",
      details: "Latest trends in technology.",
      fee: 50.0,
      image: "lib/images/mainpage.png",
    ),
    Event(
      event: "Art Exhibition",
      date: DateTime.now().add(Duration(days: 2)),
      location: "Art Gallery",
      registration: 80,
      organiser: "Art Society",
      details: "Showcasing contemporary art pieces.",
      fee: 10.0,
      image: "lib/images/mainpage.png",
    ),
    Event(
      event: "Music Concert",
      date: DateTime.now().add(Duration(days: 3)),
      location: "Outdoor Arena",
      registration: 300,
      organiser: "Music Productions",
      details: "Live performances by famous artists.",
      fee: 40.0,
      image: "lib/images/mainpage.png",
    ),
    Event(
      event: "Food Festival",
      date: DateTime.now().add(Duration(days: 4)),
      location: "City Park",
      registration: 100,
      organiser: "Culinary Society",
      details: "A variety of cuisines from around the world.",
      fee: 15.0,
      image: "lib/images/mainpage.png",
    ),
    Event(
      event: "Book Fair",
      date: DateTime.now().add(Duration(days: 5)),
      location: "Exhibition Hall",
      registration: 120,
      organiser: "Publishing House",
      details: "Discover the latest books and authors.",
      fee: 25.0,
      image: "lib/images/mainpage.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 100, 8, 222),
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
                              hintText: 'Search event/category/organizer',
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
                            )
                          ],
                        ),
                        const SizedBox(height: 1),
                        Wrap(
                          spacing: 5,
                          runSpacing: 2,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Sport",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Education",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Charity",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Festival",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Entertainment",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Workshop",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Talk",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Technology",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Conference",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text(
                                "Fundraiser",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Events",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EventPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "See More",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        buildEventCards(context), // Display event cards
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
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
                        builder: (context) =>  OrganizerApprovalPage(),
                      ),
                    );
                  },
                ),
                FooterIconButton(
                  icon: Icons.event,
                  label: "Event",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventPage(),
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
                        builder: (context) => const ProfileScreen(),
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

  Widget buildEventCards(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyEvents.length,
      itemBuilder: (context, index) {
        final event = dummyEvents[index];

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsPage(event: event),
              ),
            );
          },
          child: Card(
            color: Colors.grey[900],
            child: ListTile(
              leading: Image.asset(
                event.image,
                fit: BoxFit.cover,
              ),
              title: Text(
                event.event,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                DateFormat.yMMMMd().format(event.date),
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        );
      },
    );
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(Icons.date_range, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMMd().format(event.date),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  DateFormat.jm().format(event.date),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  '\$${event.fee.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  event.organiser,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${event.details}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 140, 40, 222),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text('Edit Event', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 140, 40, 222),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text('Delete Event', style: TextStyle(color: Colors.white)),
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


