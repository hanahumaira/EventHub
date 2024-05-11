import 'dart:io';

import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  File? image;

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicked == null) return;
    setState(() {
      image = File(imagePicked.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // _logoutAndNavigateToLogin(context);
            },
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
          "Create Event",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                  image != null
                      ? Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(image!, fit: BoxFit.cover),
                        )
                      : Container(),
                  // Upload photo
                  MaterialButton(
                    color: Colors.black,
                    onPressed: () async {
                      await _pickImageFromGallery();
                    },
                    child: const Text(
                      "Upload a photo",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Event Name
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Event Name *',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Date and Time
                  // TODO: Implement date and time picker
                  // Example:
                  // DateTimeField(
                  //   decoration: InputDecoration(
                  //     labelText: 'Date and Time *',
                  //     labelStyle: TextStyle(color: Colors.white),
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   format: DateFormat('dd/MM/yyyy hh:mm a'),
                  //   onShowPicker: (context, currentValue) async {
                  //     final date = await showDatePicker(...);
                  //     final time = await showTimePicker(...);
                  //     return DateTimeField.combine(date!, time);
                  // },
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Please select the date and time';
                  //   }
                  //   return null;
                  // },

                  // Location
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Location *',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Fee
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Fee *',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the fee';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Organizer
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Organizer *',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the organizer';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Details
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Details *',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: null, // Allow multiple lines for details
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          //buttons
          Container(
            color: const Color.fromARGB(255, 100, 8, 222),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //cancel button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                //create event button
                ElevatedButton(
                  onPressed: () {
                    //functions & go to event page
                  },
                  child: const Text('Create Event'),
                ),
              ],
            ),
          ),

          //footer
          Container(
            color: const Color.fromARGB(255, 100, 8, 222),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FooterIconButton(
                    icon: Icons.home, label: "Home", onPressed: () {}),
                FooterIconButton(
                    icon: Icons.event, label: "My Event", onPressed: () {}),
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
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              color: Colors.grey,
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
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Date: DD/MM/YYYY",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 2),
                Text(
                  "Location: XXXXX",
                  style: TextStyle(fontSize: 12),
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
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          iconSize: 30,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
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