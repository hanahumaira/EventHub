// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key, User? user}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  File? _selectedImage;
  DateTime? _selectedDateTime;
  final _dateTimeController = TextEditingController();
  final _eventNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _feeController = TextEditingController();
  final _organizerController = TextEditingController();
  final _detailsController = TextEditingController();

  Future<void> _createEvent() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Add event data to Firestore
      DocumentReference docRef = await _firestore.collection('event').add({
        'event': _eventNameController.text,
        'location': _locationController.text,
        'fee': _feeController.text,
        'organizer': _organizerController.text,
        'details': _detailsController.text,
        'date': _dateTimeController.text,
        'timestamp': Timestamp.now(),
      });

      print('Event created with ID: ${docRef.id}');

      // Navigate to EventPage after event creation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyEvent()),
      );
    } catch (e) {
      print('Error creating event: $e');
      // Handle error accordingly
    }
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
                  // Upload photo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0),
                          color: Colors.grey,
                        ),
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : SizedBox(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: MaterialButton(
                          color: Colors.transparent,
                          onPressed: () {
                            _pickImageFromGallery();
                          },
                          child: const Text(
                            "Upload a photo",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Event Name
                  TextFormField(
                    controller: _eventNameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      hintText: 'Enter the name of the event.',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Date and Time
                  TextFormField(
                    onTap: () async {
                      DateTime? pickedDateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );

                      if (pickedDateTime != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            _selectedDateTime = DateTime(
                              pickedDateTime.year,
                              pickedDateTime.month,
                              pickedDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );

                            _dateTimeController.text =
                                DateFormat('yyyy-MM-dd HH:mm')
                                    .format(_selectedDateTime!);
                          });
                        }
                      }
                    },
                    controller: _dateTimeController,
                    decoration: InputDecoration(
                      labelText: 'Event Date and Time',
                      hintText: 'Select the date and time of the event.',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    readOnly: true,
                    validator: (value) {
                      if (_selectedDateTime == null) {
                        return 'Please select the date and time';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Event Location',
                      hintText: 'Location Address',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the event location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Fee
                  TextFormField(
                    controller: _feeController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Event Fee',
                      hintText: 'RM XX.XX',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the fee of the ticket';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid fee amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Organizer
                  TextFormField(
                    controller: _organizerController,
                    decoration: InputDecoration(
                      labelText: 'Event Organiser(s)',
                      hintText: 'Company Name(s)',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the organiser(s) name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Details
                  TextFormField(
                    controller: _detailsController,
                    decoration: InputDecoration(
                      labelText: 'Event Details',
                      hintText: 'Write the event details information.',
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please write the event details information';
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
                  onPressed: _createEvent,
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

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key});

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
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

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
