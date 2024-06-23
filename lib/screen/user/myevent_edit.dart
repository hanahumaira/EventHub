import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/model/user.dart'; // Import the User class from model/user.dart
import 'package:eventhub/model/event.dart'; // Import the Event class from model/event.dart

class EditEventRegPage extends StatefulWidget {
  final Event event;
  final String event_id; // Add event_id parameter here
  final User user;

  const EditEventRegPage({
    Key? key,
    required this.event,
    required this.event_id,
    required this.user,
  }) : super(key: key);

  @override
  _EditEventRegPageState createState() => _EditEventRegPageState();
}

class _EditEventRegPageState extends State<EditEventRegPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _ageController;
  TextEditingController? _emailController;
  TextEditingController? _eventNameController;
  TextEditingController? _fullNameController;
  TextEditingController? _genderController;
  TextEditingController? _icController;
  TextEditingController? _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController();
    _emailController = TextEditingController();
    _eventNameController = TextEditingController();
    _fullNameController = TextEditingController();
    _genderController = TextEditingController();
    _icController = TextEditingController();
    _phoneNumberController = TextEditingController();

    _fetchEvents(); // Call _fetchEvents here
  }

  @override
  void dispose() {
    _ageController?.dispose();
    _emailController?.dispose();
    _eventNameController?.dispose();
    _fullNameController?.dispose();
    _genderController?.dispose();
    _icController?.dispose();
    _phoneNumberController?.dispose();
    super.dispose();
  }

  Future<void> _fetchEvents() async {
    try {
      print('Fetching registration details for event ID: ${widget.event_id}');
      final querySnapshot = await FirebaseFirestore.instance
          .collection('registrations')
          .where('event_id', isEqualTo: widget.event_id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final registrationData = querySnapshot.docs.first.data();
        setState(() {
          _ageController?.text = registrationData['age'] ?? '';
          _emailController?.text = registrationData['email'] ?? '';
          _eventNameController?.text = registrationData['event_name'] ?? '';
          _fullNameController?.text = registrationData['full_name'] ?? '';
          _genderController?.text = registrationData['gender'] ?? '';
          _icController?.text = registrationData['ic'] ?? '';
          _phoneNumberController?.text = registrationData['phone_number'] ?? '';
        });
        print('Registration details fetched successfully');
      } else {
        print('No registration found for event ID: ${widget.event_id}');
      }
    } catch (e) {
      print('Error fetching registration details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Registration'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                enabled: false, // Make the field uneditable
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _icController,
                decoration: InputDecoration(labelText: 'IC Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your IC number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveFormData();
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveFormData() {
    final updatedRegistration = {
      'age': _ageController?.text,
      'email': _emailController?.text,
      'phone_number': _phoneNumberController?.text,
      'gender': _genderController?.text ??
          '', // Ensure to handle null case for optional fields
      'ic': _icController?.text ??
          '', // Ensure to handle null case for optional fields
      // Add other fields as needed
    };

    // Update registration data in Firestore
    FirebaseFirestore.instance
        .collection('registrations')
        .where('event_id', isEqualTo: widget.event_id)
        .where('full_name', isEqualTo: widget.user.name)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        FirebaseFirestore.instance
            .collection('registrations')
            .doc(docId)
            .update(updatedRegistration)
            .then((_) {
          print('Registration updated successfully');
        }).catchError((error) {
          print('Failed to update registration: $error');
        });
      } else {
        print(
            'No registration found for event ID: ${widget.event_id} and full name: ${widget.user.name}');
      }
    }).catchError((error) {
      print('Error fetching registration: $error');
    });
  }
}


// betulkan UI
// tambah IC number