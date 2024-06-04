import 'package:flutter/material.dart';

class OrganizerApprovalPage extends StatefulWidget {
  const OrganizerApprovalPage({super.key});

  @override
  _OrganizerApprovalPageState createState() => _OrganizerApprovalPageState();
}

class _OrganizerApprovalPageState extends State<OrganizerApprovalPage> {
  final List<Organizer> organizers = [
    Organizer(
      name: "John Doe",
      contact: "123-456-7890",
      email: "john.doe@example.com",
      website: "www.johndoe.com",
      isApproved: false,
    ),
    Organizer(
      name: "Jane Smith",
      contact: "987-654-3210",
      email: "jane.smith@example.com",
      website: "www.janesmith.com",
      isApproved: false,
    ),
    Organizer(
      name: "Alice Johnson",
      contact: "456-789-1234",
      email: "alice.johnson@example.com",
      website: "www.alicejohnson.com",
      isApproved: false,
    ),
    Organizer(
      name: "Bob Brown",
      contact: "321-654-9870",
      email: "bob.brown@example.com",
      website: "www.bobbrown.com",
      isApproved: false,
    ),
    Organizer(
      name: "Charlie Davis",
      contact: "789-123-4567",
      email: "charlie.davis@example.com",
      website: "www.charliedavis.com",
      isApproved: false,
    ),
  ];

  void _approveOrganizer(int index) {
    setState(() {
      organizers[index].isApproved = true;
    });
  }

  void _rejectOrganizer(int index) {
    setState(() {
      organizers[index].isApproved = false;
    });
  }

  void _showOrganizerDetails(BuildContext context, Organizer organizer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            organizer.name,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Contact: ${organizer.contact}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Email: ${organizer.email}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Website: ${organizer.website}",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizer Approval'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: ListView.builder(
        itemCount: organizers.length,
        itemBuilder: (context, index) {
          final organizer = organizers[index];
          return Card(
            color: Colors.grey[900],
            child: ListTile(
              title: Text(
                organizer.name,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                organizer.isApproved ? "Approved" : "Not Approved",
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _approveOrganizer(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _rejectOrganizer(index),
                  ),
                ],
              ),
              onTap: () => _showOrganizerDetails(context, organizer),
            ),
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}

class Organizer {
  final String name;
  final String contact;
  final String email;
  final String website;
  bool isApproved;

  Organizer({
    required this.name,
    required this.contact,
    required this.email,
    required this.website,
    this.isApproved = false,
  });
}
