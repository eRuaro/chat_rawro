import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {

  ReusableButton({@required this.onPress, this.text, this.color});


  final void Function() onPress;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPress,
            //Go to login screen.
            // onPressed();
            // Navigator.pushNamed(context, LoginScreen.id);
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}
