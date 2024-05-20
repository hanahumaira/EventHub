import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/model/event.dart';
import 'package:eventhub/screen/event_page.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  final User passUser;

  const UserHomePage({super.key, required this.passUser});

  @override
  State<UserHomePage> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHomePage> {
  final CollectionReference eventsCollection = FirebaseFirestore.instance.collection('event');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          "You are a Participant!",
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
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
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
                    const SizedBox(height: 5),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      runSpacing: 2,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Sport",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Education",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Charity",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Festival",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Entertainment",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text(
                            "Workshop",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Events",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
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
                                  fontSize: 18,
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
                    StreamBuilder<QuerySnapshot>(
                      stream: eventsCollection.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.active) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var event = snapshot.data!.docs[index];
                                return EventCard(
                                  event: Event.fromSnapshot(event),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          }
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 100, 8, 222),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FooterIconButton(
                    icon: Icons.home, label: "Home", onPressed: () {}),
                FooterIconButton(
                  icon: Icons.bookmark,
                  label: "Saved",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyEvent(),
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
                        builder: (context) => const MyEvent(),
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
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(event.image, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(
              event.event,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${event.date.toLocal()}".split(' ')[0], // Formatting the date
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "${event.date.hour}:${event.date.minute}", // Displaying time
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              event.location,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
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
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

void _logoutAndNavigateToLogin(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Login()),
    (route) => false,
  );
}
