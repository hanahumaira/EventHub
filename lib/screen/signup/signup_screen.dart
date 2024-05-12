// ignore_for_file: prefer_const_constructors

import 'package:eventhub/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/services.dart';

// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:get/get.dart';

// void main() {
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     systemNavigationBarColor: Colors.black, // Set navigation bar color
//   ));
//   runApp(const UserSignUp());
// }

// class UserSignUp extends StatelessWidget {
//   const UserSignUp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'EventHub',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const SignUp(title: 'Sign Up'),
//     );
//   }
// }

class SignUp extends StatefulWidget {
  final FirebaseFirestore firestore;
  final String accountType;

  const SignUp({super.key, required this.accountType, required this.firestore});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _phoneNum = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phoneNum.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        //Button to go back to Login
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login()), //go back to sign in
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: Colors.white,
        ),
        //Text at the top
        backgroundColor: Colors.black,
        title: Text("Create Account as ${widget.accountType}",
            style: TextStyle(
                color: Colors.white, // set tet color
                fontSize: 24,
                fontWeight: FontWeight.bold)),
      ),
      //Form to register
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Full Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Round edge border
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    filled: true, // Enable filling
                    fillColor: Colors.white, // Set fill color to white
                    labelText: "Full Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),

                  style: TextStyle(color: Colors.black), // Set text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
              ),
              //Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: TextFormField(
                  controller: _email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Round edge border
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    filled: true, // Enable filling
                    fillColor: Colors.white, // Set fill color to white
                    labelText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                  ),
                  style: TextStyle(color: Colors.black), // Set text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
              ),
              //Phone Number
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: TextFormField(
                  controller: _phoneNum,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Round edge border
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    filled: true, // Enable filling
                    fillColor: Colors.white, // Set fill color to white
                    labelText: "Phone Number",
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.black,
                    ),
                  ),
                  style: TextStyle(color: Colors.black), // Set text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!_isValidPhoneNumber(value)) {
                      return 'Invalid Phone Number Format';
                    }
                    return null; // Return null if validation passes
                  },
                ),
              ),
              //Password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Round edge border
                      borderSide:
                          BorderSide(color: Colors.white), // Set border color
                    ),
                    filled: true, // Enable filling
                    fillColor: Colors.white, // Set fill color to white
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Colors.black), // Set text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              //SignUp
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> userData = {
                          'name': _name.text,
                          'email': _email.text,
                          'password': _password.text,
                          'phoneNum': _phoneNum.text,
                          'accountType': widget.accountType,
                        };

                        try {
                          widget.firestore
                              .collection('userData')
                              .doc(_email.text)
                              .set(userData);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Successfully Registered'),
                              duration: Duration(seconds: 3),
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        } catch (e) {
                          print('Error adding user data to Firestore');
                        }

                        // // Validate email format
                        // if (!_isValidEmail(enteredEmail)) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text('Invalid Email Format'),
                        //     ),
                        //   );
                        //   return; // Exit the function if email is invalid
                        // }

                        // // Validate password criteria (e.g., minimum length)
                        // if (enteredPassword.length < 6) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text(
                        //           'Password must be at least 6 characters'),
                        //     ),
                        //   );
                        //   return; // Exit the function if password is invalid
                        // }

                        // // Check if credentials are valid
                        // if (_email.text.isNotEmpty &&
                        //     _password.text.isNotEmpty) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => HomePage(
                        //         email: enteredEmail,
                        //         name: _name.text,
                        //         phoneNumber: _phoneNum.text,
                        //       ),
                        //     ),
                        //   );
                        // } else {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //       content: Text('Invalid Credentials'),
                        //     ),
                        //   );
                        // }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all required fields'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 100, 8, 222),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'CREATE MY ACCOUNT',
                      style: TextStyle(
                        fontSize: 14, // Adjust the font size as needed
                        fontWeight: FontWeight
                            .bold, // Optional: You can specify the font weight
                        // Other text styles can be added here (e.g., color, font family, etc.)
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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

class HomePage extends StatelessWidget {
  final String email;
  final String name;
  final String phoneNumber;

  const HomePage({
    super.key,
    required this.email,
    required this.name,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Home Page',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white, fontSize: 24),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 100, 8, 222), // Set background color
            borderRadius: BorderRadius.circular(10.0), // Add border radius
          ),
          padding: EdgeInsets.all(16.0), // Add padding inside the container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Use minimum height for the Column
            children: [
              // Display Email
              _buildInfoRow('Email', email, Icons.email),

              // Display Name
              _buildInfoRow('Name', name, Icons.person),

              // Display Phone Number
              _buildInfoRow('Phone Number', phoneNumber, Icons.phone_android),

              SizedBox(height: 24), // Spacer for vertical spacing

              // Button Widget
              ElevatedButton(
                onPressed: () {
                  // Add functionality for button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()), //go back to sign in
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, // Button background color
                  backgroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Go Back To Login Page',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData iconData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[800],
          ),
          child: Row(
            children: [
              Icon(
                iconData, // Use the specified icon for this row
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8), // Add space between icon and text
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
