import 'package:flutter/material.dart';
import 'package:flash_chat/components/constants.dart';

class Contacts extends StatefulWidget {
  static const id = 'contacts';
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  String contact;
List<String> listContacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (value){
             contact = value;
            },
            textAlign:  TextAlign.center,
            decoration: kInputDecoration.copyWith(hintText: 'añade contacto'),
          ),
          ListView(
            
          )
        ],
      ),
    );
  }
}
