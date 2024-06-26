import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventhub/model/event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/model/user.dart';

class RegisterEventPage extends StatelessWidget {
  final Event event;
  final User user; // Add the user parameter

  const RegisterEventPage(
      {required this.event, required this.user}); // Update constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register for ${event.event}'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset(event.imageURL),
            const SizedBox(height: 16),
            Text(
              event.event,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.date_range, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  DateFormat.yMMMMd().format(event.dateTime),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  DateFormat.jm().format(event.dateTime),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  event.location,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  '\$${event.fee.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Register for the Event',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            EventRegistrationForm(
                event: event, user: user), // Pass user to form
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

class EventRegistrationForm extends StatefulWidget {
  final Event event;
  final User user; // Add the user parameter

  const EventRegistrationForm(
      {required this.event, required this.user}); // Update constructor

  @override
  _EventRegistrationFormState createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _icController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;

  void _registerEvent() async {
    if (_formKey.currentState!.validate()) {
      final registrationData = {
        'event_id': widget.event.id,
        'event_name': widget.event.event,
        'full_name': _fullNameController.text,
        'email': _emailController.text,
        'phone_number': _phoneNumberController.text,
        'ic': _icController.text,
        'age': _ageController.text,
        'gender': _selectedGender,
        'timestamp': Timestamp.now(),
      };

      try {
        await FirebaseFirestore.instance
            .collection('registrations')
            .add(registrationData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event registered successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EventWebsitePage(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register event: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _fullNameController,
            label: 'Full Name',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Full Name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildGenderField(),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _icController,
            label: 'IC',
            icon: Icons.credit_card,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your IC';
              } else if (value.length != 12) {
                return 'IC must be exactly 12 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _ageController,
            label: 'Age',
            icon: Icons.calendar_today,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Age';
              } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'Please enter a valid Age';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid Email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneNumberController,
            label: 'Phone Number',
            icon: Icons.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your Phone Number';
              } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                return 'Please enter a valid Phone Number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _registerEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 140, 40, 222),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_available, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Register Event',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title:
                    const Text('Male', style: TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  activeColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title:
                    const Text('Female', style: TextStyle(color: Colors.white)),
                leading: Radio<String>(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  activeColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EventWebsitePage extends StatelessWidget {
  const EventWebsitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Payment'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You will be redirected to the event website to complete your payment.',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Redirect to the event website
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Scaffold(
                      body: Center(
                        child: Text(
                          'Redirecting to event website...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
                Future.delayed(Duration(seconds: 1), () {
                  // Use the browser to navigate to the event website
                  _launchURL('https://www.jomrun.com/event/Daiman-Run-2024');
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 140, 40, 222),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Go to Event Website',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  void _launchURL(String url) async {
    // You can use a package like url_launcher to launch URLs
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
