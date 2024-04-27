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
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
  child: Column(
    children: [
      Image.asset(
        'images/mainpage.png',
        height: 100,
      ),
      SizedBox(height: 20), // Add some spacing between the image and text
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
  margin: EdgeInsets.symmetric(horizontal: 20), // Add margin for spacing from the screen edges
  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20), // Adjust padding
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
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Email",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
      ),
      SizedBox(height: 10), // Add some vertical spacing between the email and password fields
      // Password
      TextFormField(
        controller: passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Password",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
      SizedBox(height: 10), // Add some vertical spacing between the password field and the submit button
      //checkbox and forget me
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
        child: const Text('Submit'),
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

            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.email});

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
                  Navigator.pop(context);
                },
                child: const Text("Go back!"),
              ),
            ),
          ],
        ));
  }
}