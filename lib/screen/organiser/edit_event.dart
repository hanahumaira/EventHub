import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/model/event.dart';
import 'package:eventhub/model/user.dart';

class EditEventPage extends StatefulWidget {
  final Event event;
  final User passUser;
  final double? fee;

  const EditEventPage(
      {super.key, required this.event, required this.passUser, this.fee});

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
    _detailsController =
        TextEditingController(text: widget.event.details ?? '');
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
          imageURL: widget.event.imageURL,
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
        title: const Text('Edit Event', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _eventController,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateTimeController,
                decoration: const InputDecoration(
                  labelText: 'Date and Time',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date and time';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _categoryController.text,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
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
              ),
              if (widget.fee != null && widget.fee != 0.0) ...[
                TextFormField(
                  controller: _feeController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Event Fee',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
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
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Event Details',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _updateEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 100, 8, 222),
                    ),
                    child: const Text(
                      'Update Event',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
