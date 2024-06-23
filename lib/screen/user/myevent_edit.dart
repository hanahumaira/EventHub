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
          .where('email', isEqualTo: widget.user.email)
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
        title: Text(
          'Edit Registration',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(), // Enable scrolling behavior
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 24,
          ),
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16), // Added space before TextFormField
                  TextFormField(
                    controller: _eventNameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      labelText: 'IC Number',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      labelText: 'Age',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
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
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _saveFormData();
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              const Color.fromARGB(255, 100, 8, 222),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveFormData() async {
    final updatedRegistration = {
      'age': _ageController?.text,
      'email': _emailController?.text,
      'phone_number': _phoneNumberController?.text,
      'gender': _genderController?.text ?? '',
      'ic': _icController?.text ?? '',
      'full_name': _fullNameController?.text ?? '',
      'event_name': _eventNameController?.text ?? '',
    };

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('registrations')
          .where('event_id', isEqualTo: widget.event_id)
          .where('email', isEqualTo: widget.user.email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('registrations')
            .doc(docId)
            .update(updatedRegistration);
        print('Registration updated successfully');
      } else {
        print(
            'No registration found for event ID: ${widget.event_id} and email: ${widget.user.email}');
      }
    } catch (error) {
      print('Failed to update registration: $error');
    }
  }
}
