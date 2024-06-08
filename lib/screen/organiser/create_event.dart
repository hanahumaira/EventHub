//Page with form to create a new event by organizer
import 'dart:io';

//firebase related import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//page related impot
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/myevent.dart';
import 'package:eventhub/screen/organiser/organiser_homepage.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';

//dart import
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateEventPage extends StatefulWidget {
  final User passUser;
  const CreateEventPage({Key? key, required this.passUser}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  //List of categories
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

  //Variable
  String? _selectedCategory;
  File? _selectedImage;
  DateTime? _selectedDateTime;
  bool _isFreeEvent = true;

  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _dateTimeController = TextEditingController();
  final _locationController = TextEditingController();
  final _feeController = TextEditingController();
  final _feeLinkController = TextEditingController();
  final _organiserController = TextEditingController();
  final _detailsController = TextEditingController();
  // final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fillOrganiserInformation();
  }

  //Method to put organizer by default based on login account
  void _fillOrganiserInformation() {
    _organiserController.text =
        widget.passUser.name; // Assuming user's name is stored in passUser.name
  }

  //method to pick any image from gallery
  void _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }

  //To connect with database
  Future<void> _createEvent() async {
    print('Creating event...');
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      if (_selectedImage == null) {
        throw 'Please select an image';
      }
      print('image not null...');

      // Upload the selected image by organizer to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
          FirebaseStorage.instance.ref().child('eventImages').child(fileName);
      print('Uploading image..');

      final UploadTask uploadTask = storageReference.putFile(_selectedImage!);
      print('image uploaded part 1');

      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      print('image uploaded part 2');

      // Get the download URL of the uploaded image
      final String imageURL = await taskSnapshot.ref.getDownloadURL();
      // final String imageURL = await storageReference.getDownloadURL();
      print('Image URL: $imageURL');

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
      DocumentReference docRef = await _firestore.collection('eventData').add({
        'imageURL': imageURL, // Store event image
        'event': _eventNameController.text, // Store event name
        'dateTime': _dateTimeController.text, // Store event date & time
        'location': _locationController.text, // Store event location
        'fee': _isFreeEvent ? 'Free' : _feeController.text, // Store event fee
        'feeLink': _feeLinkController.text, // Store fee link if any
        'category': _selectedCategory, // Store event category
        'details': _detailsController.text, // Store event details
        'organiser': _organiserController.text, // Store event organizer
        'timestamp': Timestamp.now(), // Store timestamp
      });

      print('Event created with ID: ${docRef.id}');

      // Navigate to EventPage after event creation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyEvent(passUser: widget.passUser)),
      );
    } catch (e) {
      print('Error creating event: $e');
      print('Error creating event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating event: $e')),
      );
      // Handle error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
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
        //Create event form
        title: Text(
          "Create Event",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set app bar text color to white
          ),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
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
                        border: Border.all(color: Colors.white, width: 2.0),
                        color: Colors.transparent,
                      ),
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : SizedBox(),
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
                            _pickImageFromGallery();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Upload a photo",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
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
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      'Is this event free?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    value: _isFreeEvent,
                    onChanged: (value) {
                      setState(() {
                        _isFreeEvent = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                if (!_isFreeEvent) ...[
                  // Fee fields
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

                  //paymentLink
                  TextFormField(
                    controller: _feeLinkController,
                    decoration: InputDecoration(
                      labelText: 'Fee Link',
                      hintText: 'https://www.utm.my/',
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
                        return 'Please enter a fee link';
                      }
                      if (!Uri.parse(value).isAbsolute) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // Category
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    hintText: 'Select the category of the event.',
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
                      return 'Please select a category';
                    }
                    return null;
                  },
                  dropdownColor: Colors.deepPurple,
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
                //Organiser
                TextFormField(
                  controller: _organiserController,
                  decoration: InputDecoration(
                    labelText: 'Organiser',
                    hintText: 'Enter the organizer name',
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
                  readOnly: true, // Set the text field to read-only
                  onTap:
                      _fillOrganiserInformation, // Disable tapping on the text field
                ),
                const SizedBox(height: 20),

                //buttons
                Container(
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
                          if (_formKey.currentState!.validate()) {
                            print('Form is valid');
                            _createEvent();
                          } else {
                            print('Form is not valid');
                          }
                        },
                        child: Text(
                          'Create Event',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 100, 8, 222),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      //bottom navigation
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 100, 8, 222),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FooterIconButton(
              icon: Icons.home,
              label: "Home",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrganiserHomePage(passUser: widget.passUser),
                  ),
                );
              },
            ),
            FooterIconButton(
              icon: Icons.event,
              label: "My Event",
              onPressed: () {
                // var widget;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        OrganiserHomePage(passUser: widget.passUser),
                  ),
                );
              },
            ),
            FooterIconButton(
              icon: Icons.add,
              label: "Create Event",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateEventPage(passUser: widget.passUser),
                  ),
                );
              },
            ),
            FooterIconButton(
              icon: Icons.person,
              label: "Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(passUser: widget.passUser),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logoutAndNavigateToLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
  }
}

class FooterIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FooterIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
