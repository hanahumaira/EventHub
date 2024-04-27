import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    title: 'Reset Password Page',
    initialRoute: '/',
    routes: {
      '/': (context) => ResetPasswordPage(),
      '/main': (context) => MainPage(),
    },
  ));
}

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: _buildResetPasswordForm(context),
      ),
    );
  }

  Widget _buildResetPasswordForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Enter your email'),
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/notification');
          },
          child: Text('Send'),
        ),
        SizedBox(height: 20.0),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'New Password'),
          obscureText: true,
        ),
        SizedBox(height: 10.0),
        TextField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(labelText: 'Confirm New Password'),
          obscureText: true,
        ),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () {
            // Check password and confirm password match
            if (_passwordController.text == _confirmPasswordController.text) {
              _showPasswordResetSuccess(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Passwords do not match.'),
              ));
            }
          },
          child: Text('Reset'),
        ),
      ],
    );
  }

  void _showPasswordResetSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Password Reset Successful'),
          content: Text('Your password has been successfully reset.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('OK'),
            ),
          ],
        );
      },
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
        child: Text('Welcome to the Main Page!'),
      ),
    );
  }
}
