// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventhub/screen/organiser/edit_event.dart';
import 'package:eventhub/screen/organiser/delete_event.dart';
import 'package:eventhub/screen/organiser/organiser_homepage.dart';
import 'package:flutter/material.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Events'),
        backgroundColor: Colors.purple, // Changing the AppBar color to purple
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrganiserHomePage(
                  passUser: null,
                ),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("event").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Filter events based on search query
          List<QueryDocumentSnapshot> filteredEvents =
              snapshot.data!.docs.where((event) {
            String eventName = event['event'].toString().toLowerCase();
            String searchQuery = _searchController.text.toLowerCase();
            return eventName.contains(searchQuery);
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search your event',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild on text change
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    var eventData = filteredEvents[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventdetailsPage(
                                eventName: eventData['event'],
                                eventLocation: eventData['location'],
                                eventdetails: eventData['details'],
                                fee: eventData['fee'],
                                organizer: eventData['organizer'],
                              ),
                            ),
                          );
                        },
                        child: EveCard(
                          eventName: eventData['event'],
                          eventLocation: eventData['location'],
                          eventdetails: eventData['details'],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class EveCard extends StatelessWidget {
  final String eventName;
  final String eventLocation;
  final String eventdetails;

  const EveCard({
    required this.eventName,
    required this.eventLocation,
    required this.eventdetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 8,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Location: $eventLocation',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Text(
              'Details: $eventdetails',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            
          ],
        ),
       
      ),
    );
  }
}

class EventdetailsPage extends StatefulWidget {
  final String eventName;
  final String eventLocation;
  final String eventdetails;
  final String fee;
  final String organizer;

  const EventdetailsPage({
    required this.eventName,
    required this.eventLocation,
    required this.eventdetails,
    required this.fee,
    required this.organizer,
  });

  @override
  _EventdetailsPageState createState() => _EventdetailsPageState();
}

class _EventdetailsPageState extends State<EventdetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Event details'),
        backgroundColor: Colors.purple, // Setting app bar color to purple
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                Text(
                  widget.eventName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Location: ${widget.eventLocation}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Fee: ${widget.fee}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Organizer: ${widget.organizer}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Details:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.eventdetails,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditEventPage(event: widget.eventName,)
                        )
                        );
              },
                child: Text(
                  'Edit Event',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyDeletePage(event: widget.eventName),
                  ),
                );
              },
                child: Text(
                  'Delete Event',
                  style: TextStyle(fontSize: 16),
                ),
              ),



          ],
        ),
      ),
    );
  }
}
