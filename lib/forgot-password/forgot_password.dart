import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ForgotPasswordPage(),
  ));
}

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your registered email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Code to send email and show notification
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Password reset email sent'),
                  ),
                );
                // Simulate redirection to mockup-gmail page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MockupGmailPage()),
                );
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}

class MockupGmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mockup Gmail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Email content here'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate redirection to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Simulate redirection to enter new password page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EnterNewPasswordPage()),
                );
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulate automatic login and redirection to main page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          },
          child: Text('Log In'),
        ),
      ),
    );
  }
}

class EnterNewPasswordPage extends StatelessWidget {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter New Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                hintText: 'Enter new password',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                hintText: 'Re-enter new password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Code to update password
                // Redirect to login page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Text('Welcome to the main page!'),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// // import 'package:eventhub/forgot-password/email_validator.dart';


// void main() {
//   runApp(MaterialApp(
//     title: 'Reset Password Page',
//     initialRoute: '/',
//     routes: {
//       '/': (context) => EmailEntryPage(),
//       '/password': (context) => PasswordEntryPage(),
//       '/main': (context) => MainPage(),
//     },
//   ));
// }

// class EmailEntryPage extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reset Password'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Enter your email'),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 String email = _emailController.text.trim();
//                 var EmailValidator;
//                 if (EmailValidator.validate(email)) {
//                   Navigator.pushNamed(context, '/password', arguments: email);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Please enter a valid email.'),
//                   ));
//                 }
//               },
//               child: Text('Send'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PasswordEntryPage extends StatelessWidget {
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final String email = ModalRoute.of(context)?.settings.arguments as String;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reset Password'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text('Reset Password for: $email'),
//             SizedBox(height: 20.0),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'New Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 10.0),
//             TextField(
//               controller: _confirmPasswordController,
//               decoration: InputDecoration(labelText: 'Confirm New Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Check password and confirm password match
//                 if (_passwordController.text ==
//                     _confirmPasswordController.text) {
//                   _showPasswordResetSuccess(context);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: Text('Passwords do not match.'),
//                   ));
//                 }
//               },
//               child: Text('Reset'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showPasswordResetSuccess(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Password Reset Successful'),
//           content: Text('Your password has been successfully reset.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.popUntil(context, ModalRoute.withName('/'));
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Main Page'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Main Page!'),
//       ),
//     );
//   }
// }
