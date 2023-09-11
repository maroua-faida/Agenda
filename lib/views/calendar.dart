import 'dart:convert';
import 'dart:core';
import 'package:agendasync1/models/appointment.dart';
import 'package:http/http.dart' as http;
import 'package:agendasync1/views/add_event.dart';
import 'package:agendasync1/views/search.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'auth.dart';
import 'menu.dart';
import 'package:agendasync1/DatabaseHelper.dart';
class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat format = CalendarFormat.month;
  DateTime day = DateTime.now();
  DateTime focusedDay = DateTime.now();
   final path="http://192.111.1.11";



  final TextEditingController _appointmentController = TextEditingController();
  List<Appointement> appointments = [];


  @override
  void initState() {
    fetchDataWithToken(day);
    super.initState();
  }


// Function to get appointments from pratisoft
  Future fetchDataWithToken(DateTime selectedDay) async {
    String? configData = await loadConfiguration();
    if (configData != null) {
      Map<String, dynamic> configMap = json.decode(configData);
      List<dynamic> applications = configMap['applications'];
      String firstPath = applications[0]['path'];

      Map<String, dynamic> firstApplication = applications[0];

      List<dynamic> apiList = firstApplication['api'];


      Map<String, dynamic> secondApi = apiList[1];

      String secondPath = secondApi['path'];


      String url = "$firstPath$secondPath";
      String? token = await getTokenFromSharedPreferences();

      if (token == null) {
        print('Token not found in Shared Preferences. Please authenticate.');
        return [];
      }

      try {
        http.Response response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'JWT $token',
          },
        );

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);

          for (var data in jsonData) {
            final appointment = Appointement(
              patient: data['patient'],
              date: data['date'],
              startTime: data['start_time'],
              endTime: data['end_time'],
              agenda: data['agenda'],
              reason: data['reason'],
              physician: data['physician'],
              comment: data['other_comment'],
            );
            appointments.add(appointment);
          }
        } else {
          print('Error: ${response.statusCode}' ' ' 'Failed to fetch events');
        }
      } catch (e) {
        print('Erreurr fetching : $e');
      }
    }
  }
// stock the appointments in a variable that will be used later in the eventLoader to be displayed
  List<Appointement> _getAppointmentsForDate(DateTime date,
      List<Appointement> allAppointments) {
    List<Appointement> appointmentsForDate =
    allAppointments.where((appointment) {
      return date.compareTo(day) == 0;
    }).toList();

    return appointmentsForDate;
  }

  @override
  void dispose() {
    _appointmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.transparent,
        // Set transparent background
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green], // Set the gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text("AgendaSync"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyAppointmentsScreen(
                          appointments: appointments,
                        )),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: 'fr_FR',
              focusedDay: day,
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekVisible: true,
              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  day = selectDay;
                  focusedDay = focusDay;
                });
                print(focusedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(day, date);
              },

              eventLoader: (selectedDay) =>
                  _getAppointmentsForDate(selectedDay, appointments),

              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ..._getAppointmentsForDate(day, appointments).map(
                  (Appointement appointment) =>
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Détails du rendez-vous'),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  alignment: Alignment.center,
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                Text('Nom complet: ${appointment.patient}'),
                                Text('Date: ${appointment.date.toString()}'),
                                Text('Début: ${appointment.startTime
                                    .toString()}'),
                                Text('Fin: ${appointment.endTime.toString()}'),
                                Text('Motif: ${appointment.reason.toString()}'),
                                Text(
                                    'Docteur: ${appointment.physician
                                        .toString()}'),
                                Text(
                                    'Commentaire: ${appointment.comment
                                        .toString()}'),
                                // Add more appointment details here
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Modifier'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _deleteAppointment(appointment);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Supprimer'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      leading: Text(appointment.startTime.toString()),
                      title: Text(
                        appointment.patient,
                      ),
                      subtitle: Text(appointment.reason.toString()),
                      trailing: Text(appointment.physician.toString()),
                    ),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddEvent(selectedDay: this.day))),
        label: const Text("Nouveau rendez-vous"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
    );
  }


  //Function to delete appointments
  void _deleteAppointment(Appointement appointment) async {
    setState(() {
      appointments.remove(appointment);
    });
    String? configData = await loadConfiguration();
    if (configData != null) {
      Map<String, dynamic> configMap = json.decode(configData);
      List<dynamic> applications = configMap['applications'];
      String firstPath = applications[0]['path'];

      Map<String, dynamic> firstApplication = applications[0];

      List<dynamic> apiList = firstApplication['api'];


      Map<String, dynamic> secondApi = apiList[1];

      String secondPath = secondApi['path'];


      String url = "$firstPath$secondPath";
      String? token = await getTokenFromSharedPreferences();

      if (token == null) {
        print('Token not found in Shared Preferences. Please authenticate.');
        return;
      }

      try {
        http.Response response = await http.delete(
          Uri.parse(url),
          headers: {
            'Authorization': 'JWT $token',
          },
        );


        if (response.statusCode == 204) {
          print('Appointment deleted successfully from the server!');
        } else {
          print('Failed to delete appointment from the server.');
          print('Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error deletion: $e');
      }
    }
  }
}





