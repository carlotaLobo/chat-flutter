
import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final Color colors;
  final Function onpress;
  final String texts;
  ReusableButton(
      {@required this.colors, @required this.onpress, @required this.texts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colors,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            texts,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
