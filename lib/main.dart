
import 'package:flutter/material.dart';

import 'views/auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:agendasync1/DatabaseHelper.dart';

void main() {
  initializeDateFormatting().then((_) => runApp( MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,

      ),
      home: MyHomePage(),
    );
  }

}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/4.png', // Replace with your image path
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: ( context)=>  Authentication()),
                  );
                  },

                  style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(200.0, 50.0),
                    // Set the button width and height
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Change the border radius here
                      side: const BorderSide(color: Colors.green, width: 2.0), // Change the border color and width here
                    ),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 20.0),
                  ),
                  ),

                child: const Text('Suivant'),

              ),
            ],
          ),
        ),
      );
  }
}
