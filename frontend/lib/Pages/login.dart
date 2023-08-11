// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Pages/accueil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.amber,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('TestApp',
            style:
                GoogleFonts.barlow(fontSize: 26, fontWeight: FontWeight.bold)),

        // backgroundColor: Colors.brown,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 4.0,
              color: Colors.white,
              margin: const EdgeInsets.only(left: 20, right: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        // controller: mailController,
                        style: const TextStyle(color: Color(0xFF000000)),
                        cursorColor: Color(0xFF9b9b9b),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.amber,
                            ),
                            hintText: "Email",
                            hintStyle: GoogleFonts.mukta(fontSize: 20)),
                        validator: (emailValue) {
                          if (emailValue!.isEmpty) {
                            return 'Entrer un email';
                          }
                          email = emailValue;
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        style: TextStyle(color: Color(0xFF000000)),
                        cursorColor: Color(0xFF9b9b9b),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Colors.amber,
                            ),
                            hintText: "Mot de passe",
                            hintStyle: GoogleFonts.mukta(fontSize: 20)),
                        validator: (passwordValue) {
                          if (passwordValue!.isEmpty) {
                            return 'Mot de passe requis';
                          }
                          password = passwordValue;
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: 4, bottom: 4, left: 5, right: 5),
                              child: Text(
                                _isLoading ? 'connexion...' : 'Se connecter',
                                style: GoogleFonts.mukta(fontSize: 19),
                                textDirection: TextDirection.ltr,
                              )),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState != null) {
                              _formKey.currentState?.validate();
                              _login();
                            }
                            // if (_formKey.currentState.validate()) {
                            //   _login();
                            // }
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => Accueil()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'password': password};
    var res = await ApiClient().authData(data);
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('role', json.encode(body['role']));
      Navigator.push(
        context,
        // ignore: unnecessary_new
        new MaterialPageRoute(builder: (context) => Accueil()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerte', style: TextStyle(fontSize: 26)),
            content: Text('Email ou mot de passe incorrect',
                style: GoogleFonts.mukta(fontSize: 20)),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Fermer',
                    style:
                        GoogleFonts.mukta(fontSize: 18, color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
  }
}
