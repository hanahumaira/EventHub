import 'package:eventhub/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
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
                            image: AssetImage('lib/profile/img/dp.png'),
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
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                      hintText: 'Nadiya Binti Ahmadi',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(163, 158, 158, 158)),
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter your full name';
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                      hintText: 'nadiya@gmail.com',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(163, 158, 158, 158)),
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter your email';
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: phoneNumController,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Phone No',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                      hintText: '0123456789',
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(163, 158, 158, 158)),
                      prefixIcon: const Icon(Icons.call),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter your phone number';
                    //   }
                    //   if (!_isValidPhoneNumber(value)) {
                    //   return 'Invalid Phone Number Format';
                    // }
                    // return null;
                    // },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: passwordController,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          const TextStyle(color: Color.fromARGB(157, 247, 247, 247)),
                      prefixIcon: const Icon(Icons.fingerprint),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter your password';
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        String enteredEmail = emailController.text.trim();
                        // String enteredPassword = passwordController.text;

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
                        // if (enteredPassword.length < 6) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text('Password must be at least 6 characters'),
                        //     ),
                        //   );
                        //   return; // Exit the function if password is invalid
                        // }
                        Get.to(() => const ProfileScreen());
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