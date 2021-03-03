import 'package:flutter/material.dart';
import 'package:chat_rawro/components/reusable_button.dart';
import 'package:chat_rawro/constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email;
  String password;

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
            Hero(
              //Must have same tag
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              //Changes keyboard appearance
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: kHintText.copyWith(
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              //Password
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: kHintText.copyWith(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            ReusableButton(
              text: 'Log In',
              onPress: () {
                print(email);
                print(password);
              },
              color: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
