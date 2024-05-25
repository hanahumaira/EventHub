import 'dart:io';

import 'package:eventhub/screen/profile/profile_screen.dart';
import 'package:eventhub/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  final User passUser;

  const EditProfileScreen({Key? key, required this.passUser}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

bool _isValidEmail(String email) {
  // Simple email validation using a regular expression
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

bool _isValidPhoneNumber(String input) {
  // Define a regex pattern for phone number formats
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
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.passUser.name;
    emailController.text = widget.passUser.email;
    phoneNumController.text = widget.passUser.phoneNum;
    passwordController.text = widget.passUser.password;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> updateUserProfile() async {
      try {
        // Get the current user ID
        String userId = widget.passUser.email;

        // Update user data in Firestore
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(userId)
            .update({
          'name': nameController.text,
          'email': emailController.text,
          'phoneNum': phoneNumController.text,
          'password': passwordController.text,
        });

        // Navigate back to the ProfileScreen after updating profile
        Get.to(() => ProfileScreen(passUser: widget.passUser));
      } catch (error) {
        print('Error updating user profile: $error');
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

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
          color: Colors.white,
        ),
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: Colors.white, fontSize: 24), // Set title color to white
        ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
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
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(157, 247, 247, 247)),
                      prefixIcon: const Icon(Icons.fingerprint),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.blueGrey,
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
                        String enteredEmail = emailController.text.trim();
                        String enteredPassword = passwordController.text;

                        // Validate email format
                        if (!_isValidEmail(enteredEmail)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid Email Format'),
                            ),
                          );
                          return; // Exit the function if email is invalid
                        }

                        // Validate password criteria (e.g., minimum length)
                        if (enteredPassword.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Password must be at least 6 characters'),
                            ),
                          );
                          return; // Exit the function if password is invalid
                        }

                        updateUserProfile();

                        Get.to(() => ProfileScreen(passUser: widget.passUser));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
