// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/Pages/accueil.dart';
import 'package:frontend/Pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TestApp',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        primaryColor: Colors.brown,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        // useMaterial3: true,
      ),
      home: const CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    // localStorage.clear();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isAuth) {
      return Accueil();
    } else {
      return Login();
    }
  }
}
