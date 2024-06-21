// page or model import
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/organiser/create_event.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/organiser/report_event.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:eventhub/screen/organiser/organiser_homepage.dart';

//others import
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationPressed;
  final VoidCallback onLogoutPressed;
  final String title;

  const CustomAppBar({
    Key? key,
    required this.onNotificationPressed,
    required this.onLogoutPressed,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: onNotificationPressed,
          icon: const Icon(Icons.notifications),
          color: Colors.white,
        ),
        IconButton(
          onPressed: onLogoutPressed,
          icon: const Icon(Icons.logout),
          color: Colors.white,
        ),
      ],
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomFooter extends StatelessWidget {
  final User passUser;

  const CustomFooter({Key? key, required this.passUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 100, 8, 222),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Spacer(),
          FooterIconButton(
            icon: Icons.home,
            label: "Home",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrganiserHomePage(
                      passUser: passUser, appBarTitle: 'Home'),
                ),
              );
            },
          ),
          const Spacer(),
          FooterIconButton(
            icon: Icons.event,
            label: "My Event",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyEvent(passUser: passUser, appBarTitle: 'My Event'),
                ),
              );
            },
          ),
          const Spacer(),
          FooterIconButton(
            icon: Icons.add,
            label: "Create Event",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEventPage(
                      passUser: passUser, appBarTitle: 'Create Event'),
                ),
              );
            },
          ),
          const Spacer(),
          FooterIconButton(
            icon: Icons.analytics,
            label: "Report",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ReportPage(passUser: passUser, appBarTitle: 'Report'),
                ),
              );
            },
          ),
          const Spacer(),
          FooterIconButton(
            icon: Icons.person,
            label: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(passUser: passUser, appBarTitle: 'Profile'),
                ),
              );
            },
          ),
          const Spacer(),
        ],
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
