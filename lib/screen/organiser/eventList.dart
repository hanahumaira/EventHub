import 'package:eventhub/screen/organiser/organiser_homepage.dart';
import 'package:flutter/material.dart';

class EventList extends StatelessWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.purple, // Changing the AppBar color to purple
         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrganiserHomePage(passUser: null,),
                      ),
                    );
                  },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search events',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 20), // Adding a gap between sections
         Expanded(
  child: ListView.builder(
    itemCount: 5, // Replace with the actual number of events
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5), // Adjust the bottom padding as needed
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailPage(
                  eventName: 'Event $index',
                  imageUrl: 'https://via.placeholder.com/150', // Example image URL
                  eventDate: 'May ${10 + index}, 2024',
                  eventLocation: 'Location $index',
                  eventFee: '\$10',
                  numRegistered: 100,
                  organizer: 'Organizer Name',
                  details: 'Event Details...',
                ),
              ),
            );
          },
          child: EveCard(
            eventName: 'Event $index',
            eventDate: 'May ${10 + index}, 2024',
            eventLocation: 'Location $index',
            imageUrl: 'https://via.placeholder.com/150', // Example image URL
          ),
        ),
      );
    },
  ),
),

        ],
      ),
    );
  }
}

class EveCard extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventLocation;
  final String imageUrl;

  const EveCard({
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 10), // Add gap above the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10), // Add padding around the image
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
              child: Image.network(
                imageUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 3), // Add gap below the image
          Padding(
            padding: EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Date: $eventDate',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Location: $eventLocation',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class EventDetailPage extends StatelessWidget {
  final String eventName;
  final String imageUrl;
  final String eventDate;
  final String eventLocation;
  final String eventFee;
  final int numRegistered;
  final String organizer;
  final String details;

  const EventDetailPage({
    required this.eventName,
    required this.imageUrl,
    required this.eventDate,
    required this.eventLocation,
    required this.eventFee,
    required this.numRegistered,
    required this.organizer,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Event Details'),
        backgroundColor: Colors.purple, // Setting app bar color to purple
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            SizedBox(
              height: 150, // Set the height of the image container
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            // Event Name
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[900], // Box background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Event Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailItem(
                        icon: Icons.calendar_today,
                        label: 'Date',
                        value: eventDate,
                      ),
                      DetailItem(
                        icon: Icons.location_on,
                        label: 'Location',
                        value: eventLocation,
                      ),
                      DetailItem(
                        icon: Icons.attach_money,
                        label: 'Fee',
                        value: eventFee,
                      ),
                      DetailItem(
                        icon: Icons.people,
                        label: 'Number Registered',
                        value: numRegistered.toString(),
                      ),
                      DetailItem(
                        icon: Icons.person,
                        label: 'Organizer',
                        value: organizer,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Event Description
                  Text(
                    'Details:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// class OrganiserHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Organiser Home'),
//       ),
//       body: Center(
//         child: Text('Organiser Home Page'),
//       ),
//     );
//   }
// }