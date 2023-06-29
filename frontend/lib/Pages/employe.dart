// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unused_element, constant_identifier_names, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Employe extends StatefulWidget {
  const Employe({super.key});

  @override
  State<Employe> createState() => _EmployeState();
}

class _EmployeState extends State<Employe> {
  TextEditingController nomController = TextEditingController();
  TextEditingController salaireController = TextEditingController();
  TextEditingController posteController = TextEditingController();

  TextEditingController nomUp = TextEditingController();
  TextEditingController salaireUp = TextEditingController();
  TextEditingController posteUp = TextEditingController();
  int updateID = 0;

  Future<List<dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/employes'));

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
      'nom': nomController.text,
      'salaire': salaireController.text,
      'poste': posteController.text
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/employes'),
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
        await http.delete(Uri.parse('http://10.0.2.2:8000/api/employes/$id'));
    if (response.statusCode == 200) {
      // Succès : la ressource a été supprimée depuis l'API
    } else {
      // Échec : la suppression de la ressource a échoué
    }
  }

  Future<void> updateData(id) async {
    final Map<String, dynamic> data = {
      'nom': nomUp.text,
      'salaire': salaireUp.text,
      'poste': posteUp.text
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/api/employes/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Succès : les données ont été mises à jour dans l'API
    } else {
      // Échec : les données n'ont pas pu être mises à jour
    }
  }

  void createEmploye(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create', style: TextStyle(fontSize: 26)),
          content: SizedBox(
            height: 240,
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: nomController,
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
                  controller: salaireController,
                  style: const TextStyle(color: Color(0xFF000000)),
                  cursorColor: Color(0xFF9b9b9b),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.monetization_on_outlined,
                          color: Colors.amber),
                      hintText: "Salaire",
                      hintStyle: GoogleFonts.mukta(fontSize: 20)),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: posteController,
                  style: const TextStyle(color: Color(0xFF000000)),
                  cursorColor: Color(0xFF9b9b9b),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.work, color: Colors.amber),
                      hintText: "Poste",
                      hintStyle: GoogleFonts.mukta(fontSize: 20)),
                ),
              ],
            ),
          ),
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

  void updateEmploye(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update', style: TextStyle(fontSize: 26)),
          content: SizedBox(
              height: 240,
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
                    controller: salaireUp,
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.monetization_on_outlined,
                            color: Colors.amber),
                        hintText: "Salaire",
                        hintStyle: GoogleFonts.mukta(fontSize: 20)),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: posteUp,
                    style: const TextStyle(color: Color(0xFF000000)),
                    cursorColor: Color(0xFF9b9b9b),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.work, color: Colors.amber),
                        hintText: "Poste",
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
            backgroundColor: Colors.brown,
            title: Text(
              'Gestion des employés',
              style:
                  GoogleFonts.barlow(fontSize: 22, fontWeight: FontWeight.bold),
            )),
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
                  nomController.clear();
                  salaireController.clear();
                  posteController.clear();
                  createEmploye(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Nouvel employé',
                    style: GoogleFonts.barlow(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )),
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
                          child: ListTile(
                              title: Text(
                                snapshot.data?[index]['nom'],
                                style: GoogleFonts.barlow(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.all(4)),
                                    // SizedBox(width: 20),
                                    Text(
                                      snapshot.data?[index]['poste'],
                                      style: GoogleFonts.barlow(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      snapshot.data![index]['salaire']
                                          .toString(),
                                      style: GoogleFonts.barlow(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    SizedBox(height: 8),
                                  ]),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.green,
                                      onPressed: () {
                                        nomUp.text =
                                            snapshot.data?[index]['nom'];
                                        salaireUp.text = snapshot.data![index]
                                                ['salaire']
                                            .toString();
                                        posteUp.text =
                                            snapshot.data?[index]['poste'];
                                        setState(() {
                                          updateID =
                                              snapshot.data?[index]['id'];
                                          updateEmploye(context);
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
                                          // Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Employe()));
                                        } else if (action ==
                                            ConfirmAction.Accept) {
                                          setState(() {
                                            int id =
                                                snapshot.data?[index]['id'];
                                            deleteData(id);
                                          });
                                        }
                                        // Action de suppression
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
        ));
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
        content: Text('Êtes-vous sûr(e) de vouloir supprimer cet employé?',
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
