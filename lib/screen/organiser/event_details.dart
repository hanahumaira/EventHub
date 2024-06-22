//page or model related import
import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/organiser/organiser_widget.dart';
import 'package:eventhub/screen/login_page.dart';

//others import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  final User passUser;
  final String appBarTitle;

  const EventDetailsPage(
      {super.key,
      required this.event,
      required this.passUser,
      this.appBarTitle = 'Event Details'});

  @override
  Widget build(BuildContext context) {
    print("Event slots: ${event.slots}");
    String slotsLeftText;
    if (event.slots != null) {
      slotsLeftText = "${event.slots} slots left";
    } else {
      slotsLeftText = "Unlimited slots";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: appBarTitle,
        onNotificationPressed: () {},
        onLogoutPressed: () => _logoutAndNavigateToLogin(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
  height: 200,
  child: event.imageURLs != null && event.imageURLs!.isNotEmpty
      ? ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: event.imageURLs!.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.network(
                event.imageURLs![index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Failed to load image: ${event.imageURLs![index]}');
                  print('Error: $error');
                  print('StackTrace: $stackTrace');
                  return Image.asset(
                    'lib/images/mainpage.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            );
          },
        )
      : Image.asset(
          'lib/images/mainpage.png',
          fit: BoxFit.cover,
        ),
),
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
                const Icon(Icons.date_range,
                    color: Colors.white), // Icon for date
                const SizedBox(width: 8),
                Text(
                  DateFormat('d MMMM yyyy').format(event.dateTime),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(width: 16), // Add spacing
                const Icon(Icons.access_time,
                    color: Colors.white), // Icon for time
                const SizedBox(width: 8),
                Text(
                  DateFormat.Hm().format(event.dateTime),
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
                const Icon(Icons.attach_money,
                    color: Colors.white), // Icon for fee
                const SizedBox(width: 8),
                Text(
                  'RM ${event.fee!.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.person,
                    color: Colors.white), // Icon for organizer
                const SizedBox(width: 8),
                Text(
                  'Organised by ${event.organiser}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.check_circle,
                    color: Colors.white), // Icon for slot
                const SizedBox(width: 8),
                Text(
                  '$slotsLeftText',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                const Icon(Icons.category,
                    color: Colors.white), // Icon for category
                const SizedBox(width: 8),
                Text(
                  'Category: ${event.category}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.description, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Details: ${event.details}',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    maxLines: null, // Allow unlimited lines
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //bottom navigation
      bottomNavigationBar: CustomFooter(passUser: passUser),
    );
  }

  void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false,
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
