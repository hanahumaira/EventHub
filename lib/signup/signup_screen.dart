// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eventhub/profile/edit_profile_screen.dart';
import 'package:eventhub/profile/widget/profile_menu.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:get/get.dart';



void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black, // Set navigation bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventHub',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignUp(title: 'Sign Up'),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.title});

  

  final String title;

  @override
  State<SignUp> createState() => _SignUpState();
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



class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      
        title: Text("Create An Account",
        style: TextStyle(
          color: Colors.white, // set tet color
          fontSize: 24,
          fontWeight: FontWeight.bold
        )),
              
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Round edge border
                        borderSide: BorderSide(color: Colors.white), // Set border color
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Round edge border
                        borderSide: BorderSide(color: Colors.white), // Set border color
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: TextFormField(
                  controller: phoneNumController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10), // Round edge border
                      borderSide: BorderSide(color: Colors.white), // Set border color
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), // Round edge border
                        borderSide: BorderSide(color: Colors.white), // Set border color
                      ), 
                      filled: true, // Enable filling
                      fillColor: Colors.white, // Set fill color to white
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      ),
                  style: TextStyle(color: Colors.black), // Set text color   
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                child: Center(
                  child: ElevatedButton(
                    
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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
                              content: Text('Password must be at least 6 characters'),
                            ),
                          );
                          return; // Exit the function if password is invalid
                        }

                        // Check if credentials are valid
                        if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                email: enteredEmail,
                                name: nameController.text,
                                phoneNumber: phoneNumController.text,
                                ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid Credentials'),
                            ),
                          );
                        }

                       
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all required fields'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 100, 8, 222), padding: EdgeInsets.symmetric(horizontal: 50, vertical: 9),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    
                    
                    
                    child: Text(
                      'CREATE MY ACCOUNT',
                      style: TextStyle(
                        fontSize: 14, // Adjust the font size as needed
                        fontWeight: FontWeight.bold, // Optional: You can specify the font weight
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






class HomePage extends StatelessWidget {
  final String email;
  final String name;
  final String phoneNumber;

  const HomePage({
    Key? key,
    required this.email,
    required this.name,
    required this.phoneNumber,
  }) : super(key: key);

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
          icon: const Icon(LineAwesomeIcons.angle_left),
          color: Colors.white,
        ),
        title: Text(
          'Home Page',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.white, fontSize: 24),),
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
              _buildInfoRow('Email', email,Icons.email ),

              // Display Name
              _buildInfoRow('Name', name, Icons.person),

              // Display Phone Number
              _buildInfoRow('Phone Number', phoneNumber, Icons.phone_android),
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

