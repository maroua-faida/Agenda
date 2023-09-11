import 'package:agendasync1/views/parametres.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool isChecked = false;

  void toggleCheckbox() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  void initState() {
    super.initState();

  }

  String name='f.marwa';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Image.asset(
            'assets/images/1.png',
            width: 160, // Set the desired width
            height: 160, // Set the desired height
            alignment: Alignment.topCenter,
          ),
          Container(
            height: 80.0,
            child: UserAccountsDrawerHeader(
              accountName: Text(''),
              accountEmail:  Text(name,
                style: const TextStyle(
                  color: Colors.black, // Set the desired text color
                ),),
              currentAccountPicture: const CircleAvatar(
                radius: 50,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
            ),
          ),

          const SizedBox(
            height: 40.0,
          ),
          Container(
            height: 80.0,
            child: UserAccountsDrawerHeader(
              accountName: const Text(''),
              accountEmail: const Text("root",
                style: TextStyle(
              color: Colors.black, // Set the desired text color
            ),),
              //currentAccountPicture: CircleAvatar(),
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
            ),
          ),

          const SizedBox(
            height: 60.0,
          ),
          Container(
            height: 1,
            color: Colors.green,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(" Paramètres"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Parametres()),
            ),
          ),
        ],
      ),
    );
  }
}
