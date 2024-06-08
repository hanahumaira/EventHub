//import dart
import 'package:flutter/material.dart';

//import firebase
import 'package:cloud_firestore/cloud_firestore.dart';

//import screen & model
import 'package:eventhub/model/user.dart';
import 'package:eventhub/screen/admin/admin_homepage.dart';
import 'package:eventhub/screen/forgot_password.dart';
import 'package:eventhub/screen/organiser/organiser_homepage.dart';
import 'package:eventhub/screen/signup/signup_screen.dart';
import 'package:eventhub/screen/user/user_homepage.dart';

class Login extends StatefulWidget {
  Login({Key? key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isChecked = false; // Variable to hold checkbox state
  bool _isPasswordVisible = false;
  String? _passwordError;
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo and welcome
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 70),
                  child: Column(
                    children: [
                      Image.asset(
                        'lib/images/mainpage.png',
                        height: 150,
                      ),
                      SizedBox(height: 30),
                      // Add some spacing between the image and text
                      const Text(
                        'Welcome to EventHub!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
                ),

                // Email, password, and submit button container
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal:
                          15), // Add margin for spacing from the screen edges
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 20), // Adjust padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Round edge border
                          ),
                          labelText: "Email",
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                        ),
                        validator: _validateEmail,
                      ),
                      SizedBox(
                          height:
                              10), // Add some vertical spacing between the email and password fields
                      // Password
                      TextFormField(
                        controller: _password,
                        obscureText: !_isPasswordVisible, //Toggle visibility
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: _validatePassword,
                      ),
                      SizedBox(
                          height:
                              30), // Add some vertical spacing between the password field and the submit button

                      // Submit button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String? validationResult = await _validateUser();
                            if (validationResult == null) {
                              try {
                                DocumentSnapshot userSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('userData')
                                        .doc(_email.text)
                                        .get();

                                if (userSnapshot.exists) {
                                  //ADMIN
                                  if (userSnapshot['accountType'] == 'ADMIN' &&
                                      userSnapshot['password'] ==
                                          _password.text) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdminHomePage(
                                          passUser: User(
                                            name: userSnapshot['name'],
                                            email: userSnapshot['email'],
                                            password: userSnapshot['password'],
                                            phoneNum: userSnapshot['phoneNum'],
                                            accountType:
                                                userSnapshot['accountType'],
                                          ),
                                        ),
                                      ),
                                    );
                                  } //ORGANIZER
                                  else if (userSnapshot['accountType'] ==
                                          'Organizer' &&
                                      userSnapshot['password'] ==
                                          _password.text) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrganiserHomePage(
                                          passUser: User(
                                            name: userSnapshot['name'],
                                            email: userSnapshot['email'],
                                            password: userSnapshot['password'],
                                            phoneNum: userSnapshot['phoneNum'],
                                            accountType:
                                                userSnapshot['accountType'],
                                          ),
                                        ),
                                      ),
                                    );

                                    //PARTICIPANT
                                  } else if (userSnapshot['accountType'] ==
                                          'Participant' &&
                                      userSnapshot['password'] ==
                                          _password.text) {
                                    User passUser = User(
                                      name: userSnapshot['name'],
                                      email: userSnapshot['email'],
                                      password: userSnapshot['password'],
                                      phoneNum: userSnapshot['phoneNum'],
                                      accountType: userSnapshot['accountType'],
                                    );

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserHomePage(passUser: passUser),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      _passwordError = 'Incorrect password';
                                      _emailError = null;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _emailError = 'User not found';
                                    _passwordError = null;
                                  });
                                }
                              } catch (error) {
                                print('Error fetching user data: $error');
                              }
                            } else {
                              // Display validation error message
                              setState(() {
                                _passwordError = validationResult;
                                _emailError = null;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 100, 8, 222),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('LOGIN'),
                      ),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            // Navigate to forgot password page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()), //to go to sign up page
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Don't have an account? Create one
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(
                                    firestore: FirebaseFirestore.instance,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Create an account",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //To check if the email is empty
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  //To check if the password is empty
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  //To validate if user is valid or not found or incorrect password
  Future<String?> _validateUser() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('userData')
          .doc(_email.text)
          .get();

      if (userSnapshot.exists) {
        if (userSnapshot['password'] == _password.text) {
          return null; // User is valid
        } else {
          return 'Incorrect password';
        }
      } else {
        return 'User not found';
      }
    } catch (error) {
      return 'Error fetching user data: $error';
    }
  }
}
