import 'dart:io';

// Firebase related imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Page or model related imports
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/organiser/organiser_widget.dart';

// Other imports
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  final User passUser;
  final String appBarTitle;

  const CreateEventPage({super.key, required this.passUser, required this.appBarTitle});

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  // List of categories
  final List<String> categories = [
    'Education',
    'Sport',
    'Charity',
    'Festival',
    'Entertainment',
    'Workshop',
    'Talk',
    'Conference',
    'Exhibition'
  ];

  // Variables
  String? _selectedCategory;
  DateTime? _selectedDateTime;
  bool _isFreeEvent = true;
  int? _selectedSlots;
  List<XFile> imageFileList = [];

  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _feeController = TextEditingController();
  final _feeLinkController = TextEditingController();
  final _organiserController = TextEditingController();
  final _detailsController = TextEditingController();
  final _slotsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fillOrganiserInformation();
  }

  // Method to fill organizer information by default based on the login account
  void _fillOrganiserInformation() {
    _organiserController.text = widget.passUser.name; // Assuming user's name is stored in passUser.name
  }

  // Method to pick images from the gallery
  Future<void> selectImages() async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        imageFileList.addAll(selectedImages);
      });
    }
  }

  // To connect with the database
  Future<void> _createEvent() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      if (imageFileList.isEmpty) {
        throw 'Please select an image';
      }

      List<String> imageUrls = [];

      // Upload the selected images to Firebase Storage
      for (XFile imageFile in imageFileList) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageReference = FirebaseStorage.instance.ref().child('eventImages').child(fileName);

        final UploadTask uploadTask = storageReference.putFile(File(imageFile.path));
        final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

        // Get the download URL of the uploaded image
        final String imageURL = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(imageURL);
      }

      // Ensure all fields are properly filled before adding to Firestore
      if (_eventNameController.text.isEmpty ||
          _dateTimeController.text.isEmpty ||
          _locationController.text.isEmpty ||
          (!_isFreeEvent && _feeController.text.isEmpty) ||
          _detailsController.text.isEmpty ||
          _organiserController.text.isEmpty ||
          _selectedCategory == null) {
        throw 'Please fill all required fields';
      }

      // Add event data to Firestore
      DocumentReference docRef = await firestore.collection('eventData').add({
        'imageURLs': imageUrls,  // Store event images
        'event': _eventNameController.text, // Store event name
        'dateTime': _dateTimeController.text, // Store event date & time
        'location': _locationController.text, // Store event location
        'fee': _isFreeEvent ? 'Free' : _feeController.text, // Store event fee
        'feeLink': _feeLinkController.text, // Store fee link if any
        'slots': _slotsController.text, // Store the slots
        'category': _selectedCategory, // Store event category
        'details': _detailsController.text, // Store event details
        'organiser': _organiserController.text, // Store event organizer
        'timestamp': Timestamp.now(), // Store timestamp
      });

      // Navigate to EventPage after event creation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyEvent(
                passUser: widget.passUser, appBarTitle: 'Create Event')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event: $e')),
      );
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
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Upload photos
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Wrap(
                      spacing: 10,
                      children: imageFileList.map((image) {
                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            color: Colors.transparent,
                          ),
                          child: Image.file(File(image.path), fit: BoxFit.cover),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200], // Grey background color
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            selectImages();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Upload photos",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Event Name
                TextFormField(
                  controller: _eventNameController,
                  decoration: InputDecoration(
                    labelText: 'Event Name',
                    hintText: 'Enter the name of the event.',
                    labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                    prefixIcon: const Icon(Icons.event, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                TextFormField(
                  onTap: () async {
                    DateTime? pickedDateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
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
                              DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime!);
                        });
                      }
                    }
                  },
                  controller: _dateTimeController,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Event Date and Time',
                    hintText: 'Select the date and time of the event.',
                    labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                    prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
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
                const SizedBox(height: 20),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    hintText: 'Enter the location of the event.',
                    labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                    prefixIcon: const Icon(Icons.location_on, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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

                // Number of slots
                TextFormField(
                  controller: _slotsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of Slots',
                    hintText: 'Enter the number of available slots.',
                    labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                    prefixIcon: const Icon(Icons.people, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number of slots';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    hintText: 'Select the category of the event.',
                    labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                    prefixIcon: const Icon(Icons.category, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  dropdownColor: Colors.grey[800],
                  style: const TextStyle(color: Colors.white),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Fee toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Is this a free event?',
                        style: TextStyle(color: Colors.white)),
                    Switch(
                      value: _isFreeEvent,
                      onChanged: (value) {
                        setState(() {
                          _isFreeEvent = value;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red[200],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Event Fee
                if (!_isFreeEvent)
                  TextFormField(
                    controller: _feeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Event Fee',
                      hintText: 'Enter the fee for the event.',
                      labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                      prefixIcon: const Icon(Icons.attach_money, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (!_isFreeEvent && (value == null || value.isEmpty)) {
                        return 'Please enter the event fee';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),

                // Fee Payment Link
                if (!_isFreeEvent)
                  TextFormField(
                    controller: _feeLinkController,
                    decoration: InputDecoration(
                      labelText: 'Payment Link',
                      hintText: 'Enter the payment link for the event.',
                      labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                      prefixIcon: const Icon(Icons.link, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (!_isFreeEvent && (value == null || value.isEmpty)) {
                        return 'Please enter the payment link';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),

                // Organizer Information
                TextFormField(
                  controller: _organiserController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Organizer',
                    hintText: 'Enter the name of the organizer.',
                    labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Event Details
                TextFormField(
                  controller: _detailsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Event Details',
                    hintText: 'Enter the details of the event.',
                    labelStyle: const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                    prefixIcon: const Icon(Icons.description, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the event details';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _createEvent();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text('Create Event',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  // Method for logging out and navigating to the login page
void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false,
    );
  }
}
