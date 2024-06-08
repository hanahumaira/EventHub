import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDeletePage extends StatelessWidget {
  final String event;

  const MyDeletePage({Key? key, required this.event}) : super(key: key);

  Future<void> deleteDocument(String event) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('event')
          .where('event', isEqualTo: event)
          .get();

      // Check if there's any matching document
      if (querySnapshot.docs.isNotEmpty) {
        // Loop through each matching document and delete it
        for (DocumentSnapshot document in querySnapshot.docs) {
          await document.reference.delete();
        }
        print('Documents with event: $event deleted successfully.');
      } else {
        print('No documents found with event: $event');
      }
    } catch (e) {
      print('Error deleting documents: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Documents by event'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            deleteDocument(event); // Pass the event to the delete method
          },
          child: Text('Delete Documents by event'),
        ),
      ),
    );
  }
}
