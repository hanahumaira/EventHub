//firebase related import
import 'package:cloud_firestore/cloud_firestore.dart';

//model related impot
import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/organiser/organiser_widget.dart';
import 'package:eventhub/screen/login_page.dart';

//others import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditEventPage extends StatefulWidget {
  final Event event;
  final User passUser;
  final double? fee;
  final String appBarTitle;

  const EditEventPage(
      {super.key,
      required this.event,
      required this.passUser,
      this.fee,
      this.appBarTitle = 'Edit Event'});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventController;
  late TextEditingController _locationController;
  late TextEditingController _dateTimeController;
  late TextEditingController _categoryController;
  late TextEditingController _feeController;
  late TextEditingController _feeLinkController;
  late TextEditingController _detailsController;
  late TextEditingController _slotsController;
  late TextEditingController _organiserController;
  DateTime? _selectedDateTime;
  int? _selectedSlots;

  List<String> categories = [
    'Education',
    'Sport',
    'Charity',
    'Festival',
    'Entertainment',
    'Workshop',
    'Talk',
    'Conference',
    'Exhibition',
  ];

  @override
  void initState() {
    super.initState();
    _eventController = TextEditingController(text: widget.event.event);
    _locationController = TextEditingController(text: widget.event.location);
    _dateTimeController =
        TextEditingController(text: widget.event.dateTime.toString());
    _categoryController = TextEditingController(text: widget.event.category);
    _feeController = TextEditingController(text: widget.fee?.toString() ?? '');
    _feeLinkController =
        TextEditingController(text: widget.event.paymentLink ?? '');
    _detailsController = TextEditingController(text: widget.event.details);
    _slotsController =
        TextEditingController(text: widget.event.slots?.toString() ?? '0');
    _organiserController = TextEditingController(text: widget.event.organiser);
    print("Fee Link: ${_feeLinkController.text}");
    print("Event Payment Link: ${widget.event.paymentLink}");
  }

  @override
  void dispose() {
    _eventController.dispose();
    _locationController.dispose();
    _dateTimeController.dispose();
    _categoryController.dispose();
    _feeController.dispose();
    _feeLinkController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _fillOrganiserInformation() {
    _organiserController.text =
        widget.passUser.name; // Assuming user's name is stored in passUser.name
  }

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedEvent = Event(
          id: widget.event.id,
          event: _eventController.text,
          location: _locationController.text,
          dateTime: DateTime.parse(_dateTimeController.text),
          category: _categoryController.text,
          organiser: widget.passUser.name,
          imageURLs: widget.event.imageURLs,
          fee: widget.fee,
          paymentLink: _feeLinkController.text,
          details: _detailsController.text,
          timestamp: Timestamp.now(),
        );

        await FirebaseFirestore.instance
            .collection('eventData')
            .doc(widget.event.id)
            .update(updatedEvent.toMap());

        Navigator.pop(context, updatedEvent);
      } catch (e) {
        print('Error updating event: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update event")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        onNotificationPressed: () {},
        onLogoutPressed: () => _logoutAndNavigateToLogin(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _eventController,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Event Name',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(157, 247, 247, 247)),
                  prefixIcon: const Icon(Icons.event, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                onTap: () async {
                  DateTime? pickedDateTime = await showDatePicker(
                    context: context,
                    initialDate: _selectedDateTime ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (pickedDateTime != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          _selectedDateTime ?? DateTime.now()),
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
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Date and Time',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(157, 247, 247, 247),
                  ),
                  prefixIcon:
                      const Icon(Icons.calendar_today, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (_selectedDateTime == null) {
                    return 'Please select the date and time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _locationController,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(157, 247, 247, 247)),
                  prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              if (widget.fee != null && widget.fee != 0.0) ...[
                const SizedBox(height: 30),
                TextFormField(
                  controller: _feeController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Event Fee',
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(157, 247, 247, 247)),
                    prefixIcon:
                        const Icon(Icons.attach_money, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
              ],
              const SizedBox(height: 30),
              TextFormField(
                controller: _organiserController,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Organiser',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(157, 247, 247, 247)),
                  prefixIcon: const Icon(Icons.person, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                readOnly: true, // Set the text field to read-only
                onTap:
                    _fillOrganiserInformation, // Disable tapping on the text field
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _slotsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Slots',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(157, 247, 247, 247)),
                  prefixIcon:
                      const Icon(Icons.check_circle, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  // Parse the input string to int and update the selectedSlots
                  setState(() {
                    _selectedSlots = int.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _categoryController.text,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(157, 247, 247, 247)),
                  prefixIcon: const Icon(Icons.category, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                style: const TextStyle(fontSize: 18, color: Colors.white),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _categoryController.text = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
                dropdownColor: Color.fromARGB(255, 100, 8, 222),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _detailsController,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Event Details',
                  labelStyle: const TextStyle(
                      color: Color.fromARGB(157, 247, 247, 247)),
                  prefixIcon: const Icon(Icons.description, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 100, 8, 222),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Update Event',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
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
