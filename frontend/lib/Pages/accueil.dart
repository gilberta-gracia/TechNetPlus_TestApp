// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Pages/employe.dart';
import 'package:frontend/Pages/user.dart';
import 'package:frontend/core/api_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Accueil extends StatefulWidget {
  // final String accesstoken;
  // const Accueil({Key? key, required this.accesstoken}) : super(key: key);
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  var name;
  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user').toString());
    if (user != null) {
      setState(() {
        name = user['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('TestApp',
                style: GoogleFonts.barlow(
                    fontSize: 28, fontWeight: FontWeight.bold))),
        body: Container(
            padding: EdgeInsets.all(20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Text('Hi, $name',
                      style: GoogleFonts.barlow(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 64),
                  ElevatedButton(
                    onPressed: () {
                      logout();
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade700),
                    child:
                        Text('Logout', style: GoogleFonts.mukta(fontSize: 22)),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Card(
                elevation: 4,
                shadowColor: Colors.black,
                color: Colors.amber.shade200,
                child: SizedBox(
                  width: 400,
                  height: 460,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.yellow.shade100),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Employe()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text('Employés',
                                  style: GoogleFonts.mukta(
                                      fontSize: 35, color: Colors.black)),
                            )),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.yellow.shade100),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Users()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text('Utilisateurs',
                                  style: GoogleFonts.mukta(
                                      fontSize: 35, color: Colors.black)),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ])));
  }

  void logout() async {
    var res = await ApiClient().getData();
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
