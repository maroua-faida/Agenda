import 'package:flutter/material.dart';


class Parametres extends StatefulWidget {
  const Parametres({super.key});

  @override
  State<Parametres> createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child:  Column(
            children: [
              const SizedBox(height: 30.0),

              Container(
                alignment: Alignment.topLeft,
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                },
                    icon: const Icon(Icons.arrow_back),),
              ),

              const SizedBox(height: 20.0),
              const Row(
                children: [
                  SizedBox(width: 26),
                  Icon(Icons.settings),
                  SizedBox(width: 8),
                  Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
SizedBox(height:100.0),

              ElevatedButton(
                onPressed: () {

              },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(350.0, 50.0),
                    // Set the button width and height
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Change the border radius here
                      side: const BorderSide(color: Colors.grey, width: 2.0), // Change the border color and width here
                    ),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 20.0),
                  ),
                ),
                  child: const Text("Compte"),
              ),


              const SizedBox(height:50.0),

              ElevatedButton(
                onPressed: () {

                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(350.0, 50.0),
                    // Set the button width and height
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Change the border radius here
                      side: const BorderSide(color: Colors.grey, width: 2.0), // Change the border color and width here
                    ),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 20.0),
                  ),
                ),
                child: const Text("Théme"),
              ),

              const SizedBox(height:50.0),

              ElevatedButton(
                onPressed: () {

                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(350.0, 50.0),
                    // Set the button width and height
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Change the border radius here
                      side: const BorderSide(color: Colors.grey, width: 2.0), // Change the border color and width here
                    ),
                  ),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(fontSize: 20.0),
                  ),
                ),
                child: const Text("Langue"),
              ),


            ],
      ),
    ),
    ),
    );
  }
}
