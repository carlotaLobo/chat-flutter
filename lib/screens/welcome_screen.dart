// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:flash_chat/components/reusables.dart';

// las animaciones son con el widget Hero y tienen un parametro tag. en ambas páginas tiene que existir esa tag, es la misma para ambos

class WelcomeScreen extends StatefulWidget {
  static const String id =
      'welcome'; // static porque pertenece a la clase y cuando se llama a la variable desde fuera no se ponen los ()
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: [
                    'Flash Chat',
                  ],
                  speed: Duration(seconds: 1),
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ReusableButton(
              colors: Colors.lightBlueAccent,
              texts: 'Log In',
              onpress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            ReusableButton(
                colors: Colors.blueAccent,
                onpress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                texts: 'Register'),
          ],
        ),
      ),
    );
  }
}
