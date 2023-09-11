import 'package:agendasync1/DatabaseHelper.dart';
import 'dart:convert';

import 'package:agendasync1/views/calendar.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends StatefulWidget {
   Authentication({super.key});


  @override
  State<Authentication> createState() => _AuthenticationState();
}

Future auth() async {
  String? configData = await loadConfiguration();
  if (configData != null) {
    Map<String, dynamic> configMap = json.decode(configData);
    List<dynamic> applications = configMap['applications'];
    String firstPath = applications[0]['path'];

    Map<String, dynamic> firstApplication = applications[0];

    List<dynamic> apiList = firstApplication['api'];


    Map<String, dynamic> firstApi = apiList[0];

    String first_path = firstApi['path'];



    String apiUrl = "$firstPath$first_path";
    try {
      http.Response response = await http.post(
        headers: {'Content-type': 'application/json',
        },
        encoding: Encoding.getByName('Utf-8'),
        Uri.parse(apiUrl),
        body: json.encode({
          'username': 'root',
          'password': 'password',
        }),
      );

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        var token = data['token'];
        await saveTokenToSharedPreferences(token);
      } else if (response.statusCode == 400) {
        print('Mot de passe incorrect');
      }

      else {
        print('Erreur lors de la requête HTTP : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur  auth: $e');
    }
  }
}

Future<void> saveTokenToSharedPreferences(String token) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token saved ');
  } catch (e) {
    print('Error saving token to SharedPreferences: $e');
  }
}

Future<String?> getTokenFromSharedPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

class _AuthenticationState extends State<Authentication> {
  @override
  void initState() {
    super.initState();
    auth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Form(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/1.png',
                  width: 270, // Set the desired width
                  height: 270, // Set the desired height
                  alignment: Alignment.topCenter,
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 380, // Set the desired width
                  height: 70, // Set the desired height
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      labelText:
                          'Nom d utilisateur', // Label text for the input field
                      hintText: ' Nom d utilisateur', // Placeholder text
                      suffixIcon:
                          const Icon(Icons.person), // Suffix icon (optional)
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ), // Border styling (optional)
                    ),
                    onChanged: (input) {
                      setState(() {
                        name: input;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  width: 380,
                  height: 70,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      labelText: 'Mot de passe', // Label text for the input field
                      hintText: 'Mot de passe', // Placeholder text
                      suffixIcon:
                          const Icon(Icons.lock), // Suffix icon (optional)
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onChanged: (pswd) {
                      // Handle the text input change
                      print('Input: $pswd');
                    },
                  ),
                ),
                const SizedBox(height: 55.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Calendar()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(200.0, 50.0),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Change the border radius here
                        side: const BorderSide(
                            color: Colors.green,
                            width: 2.0), // Change the border color and width here
                      ),
                    ),
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(fontSize: 20.0),
                    ),
                  ),
                  child: const Text('Authentifier'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
