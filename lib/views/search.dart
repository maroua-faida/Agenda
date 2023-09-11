import 'package:flutter/material.dart';
import 'package:agendasync1/models/appointment.dart';



import 'auth.dart';

class MyAppointmentsScreen extends StatefulWidget {
  final List<Appointement> appointments;

  MyAppointmentsScreen({required this.appointments});

  @override
  _MyAppointmentsScreenState createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Appointement> filteredAppointments = [];

  @override
  void initState() {
    filteredAppointments = widget.appointments;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes rendez-vous'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),

            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterAppointments(value);
              },
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredAppointments[index].patient),
                  leading: Text(filteredAppointments[index].startTime.toString()),
                  subtitle:  Text(filteredAppointments[index].reason.toString()),

                );
              },
            ),
          ),

        ],
      ),
    );
  }

  List<Appointement>? _filterAppointments(String value) {
    setState(() {
      if (value.isEmpty) {
        filteredAppointments = widget.appointments;
      }
      else {
        filteredAppointments = widget.appointments
            .where((appointment) =>
            appointment.patient.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }
}
