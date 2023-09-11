import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:agendasync1/models/appointment.dart';
import 'package:http/http.dart' as http;
import '../DatabaseHelper.dart';
import 'auth.dart';

class AddEvent extends StatefulWidget {
  final DateTime selectedDay;
  Appointement? appointement;

  AddEvent({
    Key? key,
    required this.selectedDay,
  }) : super(key: key);

  @override
  _AddEvent createState() =>  _AddEvent(this.selectedDay);
}

bool isValidDateFormat(String input) {
  // Expression régulière pour le format "jj/mm/aaaa"
  RegExp regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
  return regex.hasMatch(input);
}
class _AddEvent extends State<AddEvent> {
  DateTime selectedDay;


  _AddEvent(this.selectedDay);
  List<String> reasons = [];
  var selectedReason='';

  @override
  void initState() {
    super.initState();
    fetchReasonsFromApi();
  }

  // Function to fetch reasons from the Pratisoft
  Future fetchReasonsFromApi() async {
    String? configData = await loadConfiguration();
    if (configData != null) {
      Map<String, dynamic> configMap = json.decode(configData);
      List<dynamic> applications = configMap['applications'];
      String firstPath = applications[0]['path'];

      Map<String, dynamic> firstApplication = applications[0];

      List<dynamic> apiList = firstApplication['api'];


      Map<String, dynamic> thirdApi = apiList[2];

      String thirdPath = thirdApi['path'];


      String url = "$firstPath$thirdPath";

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
            'Content-type': 'application/json',
          },
        );


        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);


          for (var data in jsonData) {
            String title = data['title'];
            reasons.add(title);
          }
          print(reasons);
        } else {
          print('Error: ${response.statusCode}' ' ' 'Failed to fetch reasons');
        }
      }
      catch (e) {
        print('Error motifs: $e');
      }
    }
  }


  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _cnieController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateDeNaissanceController = TextEditingController();
  final TextEditingController _etatCivilController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _salleController = TextEditingController();
  final TextEditingController _agendaController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _physicianController = TextEditingController();
  final TextEditingController _rappelController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();


  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("Rendez-vous"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),

                        SizedBox(
                          width: 380, // Set the desired width
                          height: 70,

                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                              icon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            controller: _fullNameController,
                            /*
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },*/
                          ),
                        ),
                        const SizedBox(width: 1),
                        SizedBox(
                          width: 380, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              icon: Icon(Icons.person),
                              labelText: 'Prenom',
                            ),
                            controller: _firstNameController,
                            /*
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },*/
                          ),
                        ),

                    const SizedBox(height: 5),

                        SizedBox(
                          width: 380, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              icon: Icon(Icons.location_city),
                              labelText: 'Ville',
                            ),
                            controller: _cityController,
                            /*
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },*/
                          ),
                        ),
                        const SizedBox(width: 1),
                        SizedBox(
                          width: 380, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              icon: Icon(Icons.credit_card),
                              labelText: 'CNIE',
                            ),
                            controller: _cnieController,
                            /*
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },*/
                          ),
                        ),

                    const SizedBox(height: 5),

                        SizedBox(
                          width: 380, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              icon: Icon(Icons.phone),
                              labelText: 'Téléphone',
                            ),
                            controller: _phoneController,
                            /*
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },*/
                          ),
                        ),
                        const SizedBox(width: 1),
                        SizedBox(
                          width: 380, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              icon: Icon(Icons.alternate_email_outlined),
                              labelText: 'Email',
                            ),
                            controller: _emailController,
                            /*
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },*/
                          ),
                        ),

                    const SizedBox(height: 5),
                        SizedBox(
                          width: 380, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.date_range_rounded),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelText: 'Date de naissance',
                            ),
                            controller: _dateDeNaissanceController,
                            /*
                            validator: (value) {
                              if (isValidDateFormat(value!)){}
                              else{
                                return 'Format non valide. Essayer un format jj/mm/aaaa';
                              }
                              return null;
                            },*/
                          ),
                        ),
                        const SizedBox(width: 1),
                        SizedBox(
                          width: 380, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              icon: Icon(Icons.people_alt_outlined),
                              labelText: 'Etat civil',
                            ),
                            controller: _etatCivilController,
                            /*
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },*/
                          ),
                        ),

                    const SizedBox(height: 5),
                    SizedBox(
                      width: 380, // Set the desired width
                      height: 70,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelText: 'Date',
                        ),
                        controller: _dateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 150, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelText: 'Début',
                            ),
                            controller: _startTimeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 60),
                        SizedBox(
                          width: 150, // Set the desired width
                          height: 70,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelText: ' Fin',
                            ),
                            controller: _endTimeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Salle de consultation',
                      ),
                      controller: _salleController,
                      /*
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ obligatoire';
                        }
                        return null;
                      },*/
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Agenda',
                      ),
                      controller: _agendaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Champ obligatoire';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedReason,
                      items: reasons.map((String reason) {
                        return DropdownMenuItem<String>(
                          value: reason,
                          child: Text(reason),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedReason = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Motif',
                        border: OutlineInputBorder(),
                      ),
                    ),


                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Docteur',
                      ),
                      controller: _physicianController,

                      validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Champ obligatoire';
                              }
                              return null;
                            },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Rappel',
                      ),
                      controller: _rappelController,

                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelText: 'Description',
                      ),
                      controller: _commentController,
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          _saveAppointment();
                        },
                        child: Text('Enregistrer'),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              )),
        ),
      ),
    );
  }

// Function to send appointments created in the app to pratisoft
  Future<void> sendAppointmentToApi(Appointement appointment) async {
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
      } // Replace with your API endpoint

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'JWT $token',
          },
          body: json.encode(appointment.toJson()),
        );

        if (response.statusCode == 201) {
          print('Appointment sent successfully!');
          print(appointment);
          print(response.body);
        } else {
          print(
              'Failed to send appointment. Status code: ${response
                  .statusCode}');
          print('Response body: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }


  void _saveAppointment() {
    Appointement newAppointment = Appointement(
      patient: _fullNameController.text,
      date: _dateController.text,
      startTime: _startTimeController.text,
      endTime: _endTimeController.text,
      agenda: _agendaController.text,
      reason: _reasonController.text,
      physician: _physicianController.text,
      comment: _commentController.text,
    );

    sendAppointmentToApi(newAppointment);

      Navigator.pop(context);

  }

}

