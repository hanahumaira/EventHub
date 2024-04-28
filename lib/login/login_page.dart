// ignore_for_file: prefer_const_constructors

import 'package:eventhub/signup/signup_screen.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isChecked = false; // Variable to hold checkbox state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //logo and welcome
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    
                child: Column(
                  children: [
                    
                    Image.asset(
                      'lib/images/mainpage.png',
                      height: 100,
                    ),
                    SizedBox(
                        height:
                            20), // Add some spacing between the image and text
                    Text(
                      'Welcome to EventHub!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

// Email, password, and submit button container
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal:
                        20), // Add margin for spacing from the screen edges
                padding: EdgeInsets.symmetric(
                    horizontal: 30, vertical: 20), // Adjust padding
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Round edge border
                      // borderSide:
                      //     BorderSide(color: Colors.white), // Set border color
                        ),
                        labelText: "Email",
                        prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                        height:
                            10), // Add some vertical spacing between the email and password fields
                    // Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        labelText: "Password",
                        prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                        height:
                            10), // Add some vertical spacing between the password field and the submit button
                    //checkbox and forget me
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked, // Example value, change it as needed
                          onChanged: (value) {
                            // Update the state of the checkbox
                            setState(() {
                              _isChecked = value!;
                            });
                          },
                        ),
                        Text('Remember me'),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            // Navigate to forgot password page
                          },
                          child: Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Submit button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (emailController.text == "nadiya@gmail.com" &&
                              passwordController.text == "12345") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  email: emailController.text,
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
                            const SnackBar(content: Text('Please fill input')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 100, 8, 222), padding: EdgeInsets.symmetric(horizontal: 50, vertical: 9),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                      child: const Text('LOGIN'),
                    ),
                    // Don't have an account? Create one
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UserSignUp()), //to go to sign up page
                            );
                          },
                          child: Text(
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
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Text(email),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _logoutAndNavigateToLogin(context);
              },
              child: const Text("Logout"),
            ),
          ),
        ],
      ),
    );
  }

  void _logoutAndNavigateToLogin(BuildContext context) {
    // After logout, navigate back to the login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false, // Clear all previous routes
    );
  }
}
