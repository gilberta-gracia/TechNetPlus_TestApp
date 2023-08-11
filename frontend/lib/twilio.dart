// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field, prefer_typing_uninitialized_variables, non_constant_identifier_names, avoid_print, use_build_context_synchronously, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class TwilioLogin extends StatefulWidget {
  const TwilioLogin({super.key});

  @override
  State<TwilioLogin> createState() => _TwilioLoginState();
}

class _TwilioLoginState extends State<TwilioLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _twilioCodeController = TextEditingController();
  TextEditingController _countryCodeController = TextEditingController();
  var _phoneNumber;
  var _codeAcces;
  bool showVerifyCode = false;
  bool showSendCodeButton = true;
  bool showVerifyCodeButton = false;

  Future<void> SendCode() async {
    final data = {
      'phone_number': _phoneNumberController.text,
      'country_code': _countryCodeController.text,
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/sendCode'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    if (response.statusCode == 200) {
      print("code envoyé -- code envoyé");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Code envoyé'),
              content:
                  Text('Le code de vérification a été envoyé avec succès.'),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    setState(() {
                      showVerifyCode = true;
                      showVerifyCodeButton = true;
                      showSendCodeButton = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } else {
      print("error -- error");
    }
  }

  Future<void> VerifyCode() async {
    final data = {
      'phone': _countryCodeController.text + _phoneNumberController.text,
      'CODE': _twilioCodeController.text,
    };
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/verifyCode'),
      headers: {'Accept': 'application/json'},
      body: data,
    );
    if (response.statusCode == 200) {
      print("code correct -- page d'accueil");
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccueilTwilio()));
      });
    } else {
      print("code incorrect -- code incorrect");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Code erroné'),
              content: Text(
                  'Le code de vérification que vous avez saisi est incorrect.'),
              actions: [
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TwilioLogin()));
                    });
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: Form(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 8.0,
            ),
            child: Text(
              "Se connecter",
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          //formulaire
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(right: 5.0, left: 5.0),
                child: CountryCodePicker(
                  initialSelection: 'TG',
                  showFlagDialog: true,
                  //Get the country information relevant to the initial selection
                  onInit: (code) =>
                      _countryCodeController.text = code!.dialCode!,
                  onChanged: (code) =>
                      _countryCodeController.text = code.dialCode!,
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone), hintText: "numéro"),
                  validator: (val) {
                    return val!.isNotEmpty ? null : "Entrez votre numéro";
                  },
                  onSaved: (newValue) {
                    _phoneNumber = newValue;
                  },
                ),
              )
            ],
          ),
          SizedBox(height: 20.0),
          Visibility(
            visible: showVerifyCode,
            child: TextFormField(
              controller: _twilioCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.keyboard_control,
                    color: Colors.grey,
                  ),
                  hintText: " code d'accès "),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Veuillez saisir le code envoyé sur ce numéro de téléphone.';
                }
                return null;
              },
              onSaved: (newValue) {
                _codeAcces = newValue;
              },
            ),
          ),
          SizedBox(height: 20.0),
// sendCodeButton
          Visibility(
            visible: showSendCodeButton,
            child: ElevatedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  'Recevoir le code',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              ),
              onPressed: () {
                print('country_code: = ' +
                    _countryCodeController.text +
                    ' ; phone = ' +
                    _phoneNumberController.text);
                setState(() {
                  SendCode();
                }); // verifyCodeButton
              },
            ),
          ),
          Visibility(
              visible: showVerifyCodeButton,
              child: ElevatedButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    'connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                onPressed: () {
                  print('twilioCode: = ' +
                      _twilioCodeController.text +
                      ' ; phone = ' +
                      _countryCodeController.text +
                      _phoneNumberController.text);
                  VerifyCode();
                },
              ))
        ],
      )),
    );
  }
}

class AccueilTwilio extends StatelessWidget {
  const AccueilTwilio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Padding(
        padding: EdgeInsetsDirectional.all(50),
        child: Text(
          'ACCUEIL',
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
