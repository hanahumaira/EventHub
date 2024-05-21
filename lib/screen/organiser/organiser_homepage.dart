import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/organiser/eventList.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrganiserHomePage extends StatefulWidget {
  final User? passUser;

  const OrganiserHomePage({Key? key, required this.passUser}) : super(key: key);

  @override
  State<OrganiserHomePage> createState() => _OrganiserHomeState();
}

class _OrganiserHomeState extends State<OrganiserHomePage> {
  final List<Event> dummyEvents = [
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
          "Welcome Organiser!",
          style: Theme.of(context).textTheme.headline6!.copyWith(
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
                              hintText: 'Search event/category/organiser',
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
                                "Exhibition",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ],
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
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventList(),
          ),
        );
      },
      child: Row(
        children: [
          Text(
            "See More",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ],
      ),
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
                  icon: Icons.event,
                  label: "My Event",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyEvent(),
                      ),
                    );
                  },
                ),
                 FooterIconButton(
                  icon: Icons.create,
                  label: "Create Event",
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEventPage(user: widget.passUser),
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
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       UserAccountsDrawerHeader(
      //         accountName: Text(widget.passUser?.name ?? 'Guest'),
      //         accountEmail: Text(widget.passUser?.email ?? 'guest@example.com'),
      //         currentAccountPicture: CircleAvatar(
      //           backgroundColor: Colors.white,
      //           child: Text(
      //             widget.passUser?.name?.substring(0, 1) ?? '?',
      //             style: const TextStyle(fontSize: 40.0),
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.account_circle),
      //         title: const Text('Profile'),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => ProfileScreen(user: widget.passUser),
      //             ),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.event),
      //         title: const Text('My Events'),
      //         onTap: () {
      //           // Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(
      //           //     builder: (context) => MyEventPage(user: widget.passUser),
      //           //   ),
      //           // );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.create),
      //         title: const Text('Create Event'),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => CreateEventPage(user: widget.passUser),
      //             ),
      //           );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.event_available),
      //         title: const Text('Event List'),
      //         onTap: () {
      //           // Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(
      //           //     builder: (context) => EventListPage(user: widget.passUser),
      //           //   ),
      //           // );
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.logout),
      //         title: const Text('Logout'),
      //         onTap: () {
      //           _logoutAndNavigateToLogin(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
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
    return dummyEvents.map((event) {
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
          subtitle: Text('${DateFormat.yMMMMd().format(event.date)} at ${event.location}', 
          style: const TextStyle(color: Colors.white70),),
          trailing: Text('Registration: ${event.registration}',
          style: const TextStyle(color: Colors.white70),),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => EventPage(event: event),
            //   ),
            // );
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

