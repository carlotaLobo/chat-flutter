// import 'dart:html';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/Components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance; // base de datos
FirebaseUser loggedInUser; // objecto de nuevos usuarios firebase

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth
      .instance; // variable que nos sirve para acceder a los metodos de Auth de firebase
  final textController =
      TextEditingController(); // para eliminar el string una vez enviado el mensaje

  String messageText;
  void getCurrentUser() async {
    // son peticiones, promesas
    try {
      final user = await _auth.currentUser(); // si es null es que no existe
      if (user != null) {
        loggedInUser =
            user; // asociamos el usuario a la variable de Firebase de User
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();

    getCurrentUser(); // generamos el usuario conectado segun se carga la pagina
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
               
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(), // viene del widget externo
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController, // controlamos el input,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textController.clear(); //limpiamos ese campo de texto
                      _firestore // guardamos en la bbdd el mensaje
                          .collection('messages')
                          .add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'date':DateTime.now()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print(snapshot);
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> listmessages = [];

        for (var message in messages) {
          final text = message.data['text'];
          final sender = message.data['sender'];
          final date= message.data['date'];

          final messageBubble = MessageBubble(
            text: text,
            sender: sender,
            date: date,
            isMe: sender ==
                loggedInUser
                    .email, // comparamos si el mensaje que leemos es de la misma persona que esta conectada, true o false, asi cambiamos los estilos UI
          );

          listmessages.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            // para que los mensajes nuevos aparezcan abajo, despues ponemos reverse en la variable messages para que imprima los al reves los mensajes.
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: listmessages,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final Timestamp date;
  final bool isMe;
  MessageBubble({this.sender, this.text, this.isMe, this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            this.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(color: Colors.black54),
          ),
          Material(
            // bloques individuales de textos
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: this.isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 20.0,
                  color: this.isMe ? Colors.white : Colors.lightBlueAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
