import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool showOverview = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 8, 222),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 100, 8, 222),
        elevation: 0,
        title: const Text(
          "Report",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterButton(
                  label: 'Overview',
                  selected: showOverview,
                  onPressed: () {
                    setState(() {
                      showOverview = true;
                    });
                  },
                ),
                FilterButton(
                  label: 'Events',
                  selected: !showOverview,
                  onPressed: () {
                    setState(() {
                      showOverview = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: showOverview ? buildOverview() : buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget buildOverview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Past Events: 10',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Upcoming Events: 5',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Total Registrations: 150',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildEventList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10, // Replace with actual number of events
      itemBuilder: (context, index) {
        return Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: ListTile(
            title: Text('Event ${index + 1}',
                style: TextStyle(
                  color: const Color.fromARGB(255, 100, 8, 222),
                )),
            subtitle: Text('Date: 2024-06-0${index + 1}'),
            onTap: () {
              // Display event details, such as registration number, shared number, and saved number
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Event ${index + 1} Details'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Registrations: ${index * 10}'),
                        Text('Shared: ${index * 5}'),
                        Text('Saved: ${index * 3}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: selected
            ? const Color.fromARGB(255, 100, 8, 222)
            : const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: selected
            ? const Color.fromARGB(255, 255, 255, 255)
            : const Color.fromARGB(255, 100, 8, 222),
        textStyle: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: selected
              ? const Color.fromARGB(255, 100, 8, 222)
              : const Color.fromARGB(255, 255, 255, 255),
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
