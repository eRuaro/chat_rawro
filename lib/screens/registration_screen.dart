import 'package:chat_rawro/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_rawro/components/reusable_button.dart';
import 'package:chat_rawro/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email;
  String password;

  //Authentication
  final _auth = FirebaseAuth.instance;

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
              text: 'Register',
              onPress: () async {
                // print(email);
                // print(password);

                //Creates a new user
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  if (newUser != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                } catch (e) {
                  print(e);
                }
              },
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
