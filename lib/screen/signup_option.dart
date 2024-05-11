import 'package:flutter/material.dart';
import 'package:eventhub/screen/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpOption extends StatelessWidget {
  const SignUpOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Account Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(
                        accountType: 'Organizer',
                        firestore: FirebaseFirestore.instance),
                  ),
                );
              },
              child: Text('Sign Up as Organizer'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(
                        accountType: 'Participant',
                        firestore: FirebaseFirestore.instance),
                  ),
                );
              },
              child: Text('Sign Up as Participant'),
            ),
          ],
        ),
      ),
    );
  }
}
