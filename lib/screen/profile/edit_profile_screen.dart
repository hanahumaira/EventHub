import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:eventhub/screen/organiser/organiser_widget.dart';
import 'package:eventhub/screen/login_page.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class EditProfileScreen extends StatefulWidget {
  final User passUser;
  final String appBarTitle;

  const EditProfileScreen({super.key, required this.passUser, this.appBarTitle = 'Edit Profile'});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}
bool _isValidPhoneNumber(String input) {
  final RegExp phoneRegex = RegExp(
    r'^(?:\+?1[-.●]?)?(?:\(\d{3}\)|\d{3})[-.●]?\d{3}[-.●]?\d{4}$',
  );
  return phoneRegex.hasMatch(input);
}


class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController sectorController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }


  void _initializeControllers() {
    nameController.text = widget.passUser.name;
    emailController.text = widget.passUser.email;
    phoneNumController.text = widget.passUser.phoneNum;
    passwordController.text = widget.passUser.password;
    addressController.text = widget.passUser.address ?? '';
    websiteController.text = widget.passUser.website ?? '';
    sectorController.text = widget.passUser.sector ?? '';
  }

  Future<void> _fetchUpdatedUserData() async {
    try {
      String userId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
      DocumentSnapshot updatedUserData = await FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .get();

      setState(() {
        widget.passUser.name = updatedUserData['name'];
        widget.passUser.email = updatedUserData['email'];
        widget.passUser.phoneNum = updatedUserData['phoneNum'];
        widget.passUser.password = updatedUserData['password'];
        widget.passUser.address = updatedUserData['address'];
        widget.passUser.website = updatedUserData['website'];
        widget.passUser.sector = updatedUserData['sector'];
        widget.passUser.accountType = updatedUserData['accountType'];
      });

      _initializeControllers();
    } catch (error) {
      print('Error fetching updated user data: $error');
    }
  }

  Future<void> updateUserProfile() async {
    try {
      String userId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception("User not authenticated");
      }

      final userData = {
        'name': nameController.text,
        'email': emailController.text,
        'phoneNum': phoneNumController.text,
        'password': passwordController.text,
        'address': addressController.text,
        'website': websiteController.text,
        'sector': sectorController.text,
        'accountType': widget.passUser.accountType,
      };

      await FirebaseFirestore.instance
          .collection('userData')
          .doc(userId)
          .update(userData);

      await _fetchUpdatedUserData();

      Get.to(() => ProfileScreen(passUser: widget.passUser, appBarTitle: 'Profile'));
    } catch (error) {
      print('Error updating user profile: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user profile: $error')),
      );
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : const Image(
                            image: AssetImage('lib/images/dp.png'),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showImagePicker(context);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                      ),
                      child: const Icon(
                        LineAwesomeIcons.camera,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(157, 247, 247, 247)),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                    TextFormField(
                      controller: emailController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(157, 247, 247, 247)),
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      enabled: true, // Disable editing
                      //initialValue: widget.passUser.email, // Set initial value
                    ),
                    const SizedBox(height: 30),
                  TextFormField(
                    controller: phoneNumController,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone No',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(157, 247, 247, 247)),
                      prefixIcon: const Icon(Icons.call),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!_isValidPhoneNumber(value)) {
                        return 'Invalid Phone Number Format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  //!
                  if (widget.passUser.accountType == 'Organizer') ...[
                    TextFormField(
                      controller: addressController,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(157, 247, 247, 247)),
                        prefixIcon: const Icon(Icons.home),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: websiteController,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Website',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(157, 247, 247, 247)),
                        prefixIcon: const Icon(Icons.web),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: sectorController,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Sector',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(157, 247, 247, 247)),
                        prefixIcon: const Icon(Icons.business),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                    TextFormField(
                    controller: passwordController,
                    readOnly: true,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(157, 247, 247, 247)),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      ),
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                      }
                      return null;
                    },
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateUserProfile();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const  Color.fromARGB(255, 100, 8, 222),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logoutAndNavigateToLogin(BuildContext context) {
    auth.FirebaseAuth.instance.signOut().then((_) {
      Get.offAll(() => const Login());
    });
  }
}
