import 'package:flutter/material.dart';

class MyEventReg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Events'),
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      ),
      body: Center(
        child: Text('Your registered events will be displayed here.'),
      ),
      backgroundColor: Colors.black,
    );
  }
}
