import 'package:eventhub/profile/profile_screen.dart';
import 'package:eventhub/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key, required this.email}) : super(key: key);
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Set app bar background color to transparent
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _logoutAndNavigateToLogin(context);
            },
            icon: const Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
        title: Text(
          "Home Page",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white, fontSize: 24),
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
                    const Text(
                      "Welcome to EventHub!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Categories",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10, // Add space between buttons
                      runSpacing: 3, // Add space between rows
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Sport"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Talk"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Conferences"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Technology"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Festival"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Charity"),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Fundraiser"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Add space between sections
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Events",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
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
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200, // Height of each event card
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5, // Number of events
                        itemBuilder: (context, index) {
                          return const EventCard(); // Custom widget for event card
                        },
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Add space between content and footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FooterIconButton(
                            icon: Icons.home, label: "Home", onPressed: () {}),
                        FooterIconButton(
                            icon: Icons.bookmark,
                            label: "Saved",
                            onPressed: () {}),
                        FooterIconButton(
                            icon: Icons.event,
                            label: "Registered",
                            onPressed: () {}),
                        FooterIconButton(
                          icon: Icons.person,
                          label: "Profile",
                          onPressed: () {
                           Get.to(ProfileScreen());
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(right: 20), // Add margin between event cards
      width: 250, // Width of each event card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for event picture
          Container(
            height: 100, // Height of event picture
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              color: Colors.grey, // Placeholder color
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Event Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Date: DD/MM/YYYY",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  "Location: XXXXX",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const FooterIconButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed, // Include the onPressed callback in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon, color: Colors.white),
          iconSize: 30,
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
  // After logout, navigate back to the login page
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => Login()),
    (route) => false, // Clear all previous routes
  );
}
