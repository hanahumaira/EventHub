import 'package:flutter/material.dart';
import 'package:eventhub/login/components/my_button.dart';
import 'package:eventhub/login/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Login user method
  void loginUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            // Logo and welcome text
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image.asset(
                    'lib/images/mainpage.png',
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome back to EventHub!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Email, password, remember me, forgot password, login button
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  SizedBox(height: 10),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: true, // Example value, change it as needed
                        onChanged: (value) {
                          // Handle checkbox state change
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

                  //login button
                  MyButton(
                    onTap: loginUser,
                  ),
                  
                ],
              ),
            ),
            SizedBox(height: 10),
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


                    // Navigate to create account page
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
    );
  }
}
