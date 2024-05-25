// ignore_for_file: use_super_parameters, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventPage extends StatefulWidget {
  final String event;

  const EditEventPage({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch event details based on widget.event and populate controllers
    _fetchEventDetails();
  }

  Future<void> _fetchEventDetails() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await _firestore
          .collection('event')
          .where('event', isEqualTo: widget.event)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot eventSnapshot = querySnapshot.docs.first;
        setState(() {
          _locationController.text = eventSnapshot['location'];
          _feeController.text = eventSnapshot['fee'];
          _organizerController.text = eventSnapshot['organizer'];
          _detailsController.text = eventSnapshot['details'];
        });
      }
    } catch (e) {
      print('Error fetching event details: $e');
      // Handle error accordingly (e.g., show a snackbar or dialog)
    }
  }

  Future<void> _updateEvent() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      // Update event data in Firestore based on event name
      QuerySnapshot querySnapshot = await _firestore
          .collection('event')
          .where('event', isEqualTo: widget.event)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot eventSnapshot = querySnapshot.docs.first;
        await eventSnapshot.reference.update({
          'location': _locationController.text,
          'fee': _feeController.text,
          'organizer': _organizerController.text,
          'details': _detailsController.text,
          'timestamp': Timestamp.now(),
        });
        // Show a success message (e.g., snackbar) after updating event
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully')),
        );
      } else {
        print('Event not found with name: ${widget.event}');
        // Handle event not found error
      }
    } catch (e) {
      print('Error updating event: $e');
      // Handle error accordingly (e.g., show a snackbar or dialog)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit Event",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location *',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Fee
            TextFormField(
              controller: _feeController,
              decoration: const InputDecoration(
                labelText: 'Fee *',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Organizer
            TextFormField(
              controller: _organizerController,
              decoration: const InputDecoration(
                labelText: 'Organizer *',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Details
            TextFormField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: 'Details *',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              maxLines: null,
            ),
            const SizedBox(height: 20),

            // Update Event button
            ElevatedButton(
              onPressed: _updateEvent,
              child: const Text('Update Event'),
            ),
          ],
        ),
      ),
    );
  }
}
