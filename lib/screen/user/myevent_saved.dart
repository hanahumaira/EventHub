import 'package:flutter/material.dart';

class MyEventSaved extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Events'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: Center(
        child: Text('Your saved events will be displayed here.'),
      ),
      backgroundColor: Colors.black,
    );
  }
}
