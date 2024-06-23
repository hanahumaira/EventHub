//firebase related import
import 'package:cloud_firestore/cloud_firestore.dart';

//page or model import
import 'package:eventhub/screen/login_page.dart';
import 'package:eventhub/screen/organiser/organiser_widget.dart';
import 'package:eventhub/model/user.dart';
import 'package:eventhub/model/event.dart';
import 'package:fl_chart/fl_chart.dart';

//others import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

//Test test

class ReportPage extends StatefulWidget {
  final User passUser;
  final String appBarTitle;

  const ReportPage(
      {super.key, required this.passUser, required this.appBarTitle});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool showOverview = true;
  int pastEventsCount = 0;
  int futureEventsCount = 0;
  int totalRegistrations = 0;
  int totalShared = 0;
  int totalSaved = 0;
  List<FlSpot> spots = [];

  List<Event> _myevent = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    fetchEventData();
  }

  // Future<void> fetchEventData() async {
  //   DateTime now = DateTime.now().toUtc();
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('eventData')
  //         .where('organiser', isEqualTo: widget.passUser.name)
  //         .get();

  //     List<Event> allEvents =
  //         querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();

  //     List<Event> pastEvents = [];
  //     List<Event> futureEvents = [];
  //     int registrations = 0;
  //     int shared = 0;
  //     int saved = 0;

  //     for (Event event in allEvents) {
  //       if (event.dateTime.isBefore(now)) {
  //         pastEvents.add(event);
  //       } else {
  //         futureEvents.add(event);
  //       }
  //       registrations += event.registration ?? 0;
  //       shared += event.shared ?? 0;
  //       saved += event.saved ?? 0;
  //     }

  //     setState(() {
  //       pastEventsCount = pastEvents.length;
  //       futureEventsCount = futureEvents.length;
  //       totalRegistrations = registrations;
  //       totalShared = shared;
  //       totalSaved = saved;
  //       _myevent = allEvents;
  //     });
  //   } catch (e) {
  //     print('Error fetching and filtering events: $e');
  //   }
  // }

  Future<void> fetchEventData() async {
    setState(() {
      pastEventsCount = 0;
      futureEventsCount = 0;
      totalShared = 0;
      totalSaved = 0;
      _myevent = [];
    });

    DateTime now = DateTime.now().toUtc();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('eventData')
          .where('organiser', isEqualTo: widget.passUser.name)
          .get();

      List<Event> allEvents =
          querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();

      List<Event> pastEvents = [];
      List<Event> futureEvents = [];

      for (Event event in allEvents) {
        if (event.dateTime.isBefore(now)) {
          pastEvents.add(event);
        } else {
          futureEvents.add(event);
        }
        totalShared += event.shared ?? 0;

        final registrationSnapshot = await FirebaseFirestore.instance
            .collection('registrations')
            .where('event_id', isEqualTo: event.id)
            .get();

        totalRegistrations += registrationSnapshot.size;

        final savedSnapshot = await FirebaseFirestore.instance
            .collection('mysave_event')
            .where('event_id', isEqualTo: event.id)
            .get();

        totalSaved += savedSnapshot.size;
      }

      // Group registrations by day
      Map<DateTime, int> registrationsPerDay = {};
      await _fetchRegistrationsPerDay(registrationsPerDay);

      // Process registrations data for line chart
      List<FlSpot> spots = [];
      registrationsPerDay.forEach((date, count) {
        spots.add(
            FlSpot(date.millisecondsSinceEpoch.toDouble(), count.toDouble()));
      });

      setState(() {
        pastEventsCount = pastEvents.length;
        futureEventsCount = futureEvents.length;
        _myevent = allEvents;
      });

      // Display line chart or other UI elements with `spots` data
    } catch (e) {
      print('Error fetching and filtering events: $e');
    }
  }

  Future<void> _fetchRegistrationsPerDay(
      Map<DateTime, int> registrationsPerDay) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('registrations')
          .where('organiser', isEqualTo: widget.passUser.name)
          .get();

      querySnapshot.docs.forEach((doc) {
        Timestamp timestamp = doc['timestamp'] as Timestamp;
        DateTime date = timestamp.toDate();
        // Extract date without time (only year, month, day)
        DateTime day = DateTime(date.year, date.month, date.day);
        if (registrationsPerDay.containsKey(day)) {
          registrationsPerDay[day] = registrationsPerDay[day]! + 1;
        } else {
          registrationsPerDay[day] = 1;
        }
      });
    } catch (e) {
      print('Error fetching registrations: $e');
    }
  }

  Future<void> _fetchEvents() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('eventData')
          .where('organiser', isEqualTo: widget.passUser.name)
          .get();

      final events = querySnapshot.docs.map((doc) {
        // Access registration data directly from 'doc'
        print('Registration data: ${doc.data()['registration']}');
        return Event.fromSnapshot(doc);
      }).toList();

      setState(() {
        _myevent = events;
      });
      print('Successfully fetching event!');
      // Inside _fetchEvents method
    } catch (e) {
      print('Error fetching event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        onNotificationPressed: () {},
        onLogoutPressed: () => _logoutAndNavigateToLogin(context),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Center(
              child: ToggleButtons(
                isSelected: [showOverview, !showOverview],
                onPressed: (index) {
                  setState(() {
                    showOverview = index == 0;
                  });
                },
                color: Colors.white,
                selectedColor: const Color.fromARGB(255, 100, 8, 222),
                fillColor: Colors.white,
                borderColor: Colors.white,
                selectedBorderColor: const Color.fromARGB(255, 100, 8, 222),
                borderRadius: BorderRadius.circular(8.0),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 140, // Increase width as needed
                      height: 40, // Increase height as needed
                      child: Center(
                        child: Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 140, // Increase width as needed
                      height: 40, // Increase height as needed
                      child: Center(
                        child: Text(
                          'Events',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: showOverview ? buildOverview() : buildEventList(),
          ),
        ],
      ),
      bottomNavigationBar: CustomFooter(passUser: widget.passUser),
    );
  }

  Widget buildOverview() {
    double pastEventsPercentage = pastEventsCount / (_myevent.length) * 100;
    double futureEventsPercentage = futureEventsCount / (_myevent.length) * 100;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Events',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 8, 222),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem(
                            color: Colors.grey, text: 'Past Events'),
                        const SizedBox(width: 16),
                        _buildLegendItem(
                            color: Colors.green, text: 'Future Events'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: Colors.grey,
                              value: pastEventsPercentage,
                              title:
                                  '${pastEventsPercentage.toStringAsFixed(2)}% (${pastEventsCount})',
                              radius: 80,
                              titleStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              color: Colors.green,
                              value: futureEventsPercentage,
                              title:
                                  '${futureEventsPercentage.toStringAsFixed(2)}% ($futureEventsCount)',
                              radius: 80,
                              titleStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Event Statistics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 8, 222),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: TotalMetricsBarChart(
                        totalRegistrations: totalRegistrations,
                        totalShared: totalShared,
                        totalSaved: totalSaved,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add the new bar chart here
          ],
        ),
      ),
    );
  }

  Widget buildEventList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _myevent.length,
      itemBuilder: (context, index) {
        final event = _myevent[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          child: ListTile(
            leading: Icon(
              Icons.event,
              color: Color.fromARGB(255, 100, 8, 222),
            ),
            title: Text(
              event.event,
              style: TextStyle(
                color: Color.fromARGB(255, 100, 8, 222),
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${DateFormat.yMMMMd().format(event.dateTime)} at ${event.location}',
              style: const TextStyle(color: Color.fromARGB(179, 72, 60, 70)),
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 100, 8, 222)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              event.event,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 67, 12, 139)),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _BarChart(
                                    registrations: event.registration ?? 0,
                                    shared: event.shared ?? 0,
                                    saved: event.saved ?? 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 100, 8, 222)),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class RegistrationsLineChart extends StatelessWidget {
  final List<FlSpot> spots;

  RegistrationsLineChart({required this.spots});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.black),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            colors: [Colors.blue],
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minY: 0,
        maxY: spots.isNotEmpty
            ? spots.map((spot) => spot.y).reduce(max).toDouble() * 1.2
            : 10,
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final int registrations;
  final int shared;
  final int saved;

  const _BarChart({
    Key? key,
    required this.registrations,
    required this.shared,
    required this.saved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String title;
                switch (groupIndex) {
                  case 0:
                    title = 'Registrations';
                    break;
                  case 1:
                    title = 'Shared';
                    break;
                  case 2:
                    title = 'Saved';
                    break;
                  default:
                    title = '';
                }
                return BarTooltipItem(
                  title,
                  TextStyle(color: Colors.yellow),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\n${rod.y.round()}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value, _) => const TextStyle(
                color: Color.fromARGB(255, 56, 50, 50),
                // color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              margin: 10,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Registrations';
                  case 1:
                    return 'Shared';
                  case 2:
                    return 'Saved';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: registrations.toDouble(),
                  width: 16,
                  colors: [Colors.blue],
                ),
              ],
              // showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  y: shared.toDouble(),
                  width: 16,
                  colors: [Colors.green],
                ),
              ],
              // showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  y: saved.toDouble(),
                  width: 16,
                  colors: [Colors.orange],
                ),
              ],
              // showingTooltipIndicators: [0],
            ),
          ],
        ),
      ),
    );
  }
}

class FooterIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FooterIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

Widget _buildLegendItem({required Color color, required String text}) {
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        color: color,
      ),
      const SizedBox(width: 4),
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 100, 8, 222),
        ),
      ),
    ],
  );
}

class TotalMetricsBarChart extends StatelessWidget {
  final int totalRegistrations;
  final int totalShared;
  final int totalSaved;

  const TotalMetricsBarChart({
    Key? key,
    required this.totalRegistrations,
    required this.totalShared,
    required this.totalSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY:
              max(totalRegistrations, max(totalShared, totalSaved)).toDouble() *
                  1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, x, rod, rodIndex) {
                String title;
                switch (x) {
                  case 0:
                    title = 'Registrations';
                    break;
                  case 1:
                    title = 'Shared';
                    break;
                  case 2:
                    title = 'Saved';
                    break;
                  default:
                    title = '';
                }
                return BarTooltipItem(
                  title,
                  TextStyle(color: Colors.yellow),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\n${rod.y.round()}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value, _) => const TextStyle(
                color: Color.fromARGB(255, 56, 50, 50),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              margin: 10,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Registrations';
                  case 1:
                    return 'Shared';
                  case 2:
                    return 'Saved';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: totalRegistrations.toDouble(),
                  width: 16,
                  colors: [Colors.blue],
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  y: totalShared.toDouble(),
                  width: 16,
                  colors: [Colors.green],
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  y: totalSaved.toDouble(),
                  width: 16,
                  colors: [Colors.orange],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _logoutAndNavigateToLogin(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const Login()),
    (Route<dynamic> route) => false,
  );
}
