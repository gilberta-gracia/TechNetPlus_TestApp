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
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    if (_scaffoldKey.currentState != null) {
      // _scaffoldKey.currentState.showSnackBar();
    }
  }

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
                padding: const EdgeInsets.all(10.0),
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
                            return 'Please enter email';
                          }
                          email = emailValue;
                          return null;
                        },
                      ),
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
                            hintText: "Password",
                            hintStyle: GoogleFonts.mukta(fontSize: 20)),
                        validator: (passwordValue) {
                          if (passwordValue!.isEmpty) {
                            return 'Please enter some text';
                          }
                          password = passwordValue;
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 10, right: 10),
                              child: Text(
                                _isLoading ? 'Proccessing...' : 'Login',
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
      Navigator.push(
        context,
        // ignore: unnecessary_new
        new MaterialPageRoute(builder: (context) => Accueil()),
      );
    } else {
      _showMsg(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
