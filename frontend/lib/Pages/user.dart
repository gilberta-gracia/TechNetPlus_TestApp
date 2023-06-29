// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously, unused_element, constant_identifier_names, unused_field, prefer_final_fields, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  var userId, roleId;
  var user;
  TextEditingController roleController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController nomUp = TextEditingController();
  TextEditingController mailUp = TextEditingController();
  TextEditingController passwordUp = TextEditingController();
  int updateID = 0;

  Future<List<dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/users'));

    if (response.statusCode == 200) {
      // La requête a réussi, convertissez les données JSON en objets Dart
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      // La requête a échoué, affichez l'erreur ou effectuez une autre action appropriée
      throw Exception(
          'Erreur lors de la récupération des données depuis l\'API');
    }
  }

  Future<void> sendData() async {
    final Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Succès : les données ont été envoyées à Laravel
    } else {
      // Échec : les données n'ont pas pu être envoyées
    }
  }

  Future<void> deleteData(id) async {
    final response =
        await http.delete(Uri.parse('http://10.0.2.2:8000/api/users/$id'));
    if (response.statusCode == 200) {
      // Succès : la ressource a été supprimée depuis l'API
    } else {
      // Échec : la suppression de la ressource a échoué
    }
  }

  Future<void> updateData(id) async {
    final Map<String, dynamic> data = {
      'name': nomUp.text,
      'email': mailUp.text,
      'password': passwordUp.text
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<void> sendRole() async {
    final Map<String, dynamic> data = {
      'user_name': user,
      'role_name': roleController.text,
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/users/add_role'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Succès : les données ont été envoyées à Laravel
    } else {
      // Échec : les données n'ont pas pu être envoyées
    }
  }

  var getRole;
  Future<void> showRole() async {
    final Map<String, dynamic> data = {
      'user_name': user,
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/users/see_role'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      setState(() {
        getRole = response.body;
      });
    }
  }

  void createUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create', style: TextStyle(fontSize: 26)),
          content: SizedBox(
              height: 280,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.amber),
                        hintText: "Nom",
                        hintStyle: GoogleFonts.mukta(fontSize: 20)),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail, color: Colors.amber),
                        hintText: "Email",
                        hintStyle: GoogleFonts.mukta(fontSize: 20)),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: passwordController,
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key, color: Colors.amber),
                        hintText: "Password",
                        hintStyle: GoogleFonts.mukta(fontSize: 20)),
                  ),
                ],
              )),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Annuler', style: GoogleFonts.mukta(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Valider', style: GoogleFonts.mukta(fontSize: 18)),
              onPressed: () {
                setState(() {
                  sendData();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void updateUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update', style: TextStyle(fontSize: 26)),
          content: SizedBox(
              height: 280,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: nomUp,
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.amber),
                        hintText: "Nom",
                        hintStyle: GoogleFonts.mukta(fontSize: 20)),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: mailUp,
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail, color: Colors.amber),
                        hintText: "Email",
                        hintStyle: GoogleFonts.mukta(fontSize: 20)),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: passwordUp,
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.key, color: Colors.amber),
                        hintText: "Password",
                        hintStyle: GoogleFonts.mukta(fontSize: 20)),
                  ),
                ],
              )),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Annuler', style: GoogleFonts.mukta(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Valider', style: GoogleFonts.mukta(fontSize: 18)),
              onPressed: () {
                setState(() {
                  updateData(updateID);
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void Role(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Role', style: TextStyle(fontSize: 26)),
            content: SizedBox(
              height: 280,
              width: 300,
              child: Column(children: [
                Padding(padding: EdgeInsets.all(8)),
                Text(user, style: TextStyle(fontSize: 26)),
                SizedBox(height: 25),
                // Text(getRole, style: TextStyle(fontSize: 26)),
                SizedBox(height: 25),
                TextField(
                  controller: roleController,
                  style: const TextStyle(color: Color(0xFF000000)),
                  cursorColor: Color(0xFF9b9b9b),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon:
                          Icon(Icons.accessibility, color: Colors.amber),
                      hintText: getRole,
                      hintStyle: GoogleFonts.mukta(fontSize: 20)),
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text('Create',
                          style: GoogleFonts.mukta(fontSize: 18)),
                      onPressed: () {
                        setState(() {
                          sendRole();
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: Text('Update',
                          style: GoogleFonts.mukta(fontSize: 18)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text('Delete',
                          style: GoogleFonts.mukta(fontSize: 18)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ]),
            ),
          );
        });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
          backgroundColor: Colors.brown,
          title: Text('Gestion des utilisateurs',
              style: GoogleFonts.barlow(
                  fontSize: 22, fontWeight: FontWeight.bold))),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          SizedBox(height: 10),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.yellow.shade100),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              onPressed: () {
                nameController.clear();
                emailController.clear();
                passwordController.clear();
                setState(() {
                  createUser(context);
                });
              },
              child: Text('Nouvel utilisateur',
                  style: GoogleFonts.barlow(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold))),
          SizedBox(height: 30),
          FutureBuilder<List<dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Affichez les données dans votre interface utilisateur ici
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.yellow.shade100),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.black,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            user =
                                                snapshot.data?[index]['name'];
                                            showRole();
                                            Role(context);
                                          });
                                          roleController.clear();
                                        },
                                        child: Text('Role',
                                            style: GoogleFonts.barlow(
                                                fontSize: 18,
                                                color: Colors.black))),
                                    // Text(getRole,
                                    //     style: GoogleFonts.barlow(
                                    //         fontSize: 18, color: Colors.black)),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(snapshot.data?[index]['name'],
                                    style: GoogleFonts.barlow(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),

                                // Text(snapshot.data?[index]['role'],
                                //     style: GoogleFonts.barlow(
                                //         fontSize: 20,
                                //         color: Colors.deepOrange,
                                //         fontWeight: FontWeight.bold))
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data?[index]['email'],
                                    style: GoogleFonts.barlow(
                                        fontSize: 20, color: Colors.black)),
                                SizedBox(height: 12),
                              ],
                            ),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.green,
                                onPressed: () {
                                  nomUp.text = snapshot.data?[index]['name'];
                                  mailUp.text = snapshot.data?[index]['email'];
                                  passwordUp.text = '';
                                  setState(() {
                                    updateID = snapshot.data?[index]['id'];
                                    updateUser(context);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () async {
                                  ConfirmAction? action =
                                      await _asyncConfirmDialog(context);
                                  if (action == ConfirmAction.Cancel) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Users()));
                                  } else if (action == ConfirmAction.Accept) {
                                    setState(() {
                                      int id = snapshot.data?[index]['id'];
                                      deleteData(id);
                                    });
                                  }
                                },
                              ),
                            ])),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ]),
      ),
    );
  }
}

enum ConfirmAction { Cancel, Accept }

Future<ConfirmAction?> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete', style: TextStyle(fontSize: 26)),
        content: Text('Êtes-vous sûr(e) de vouloir supprimer cet utilisateur?',
            style: GoogleFonts.mukta(fontSize: 20)),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Annuler', style: GoogleFonts.mukta(fontSize: 18)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Supprimer', style: GoogleFonts.mukta(fontSize: 18)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Accept);
            },
          )
        ],
      );
    },
  );
}
