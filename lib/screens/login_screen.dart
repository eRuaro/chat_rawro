import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_rawro/components/reusable_button.dart';
import 'package:chat_rawro/constants.dart';
import 'package:chat_rawro/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;

  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  //Must have same tag
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
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
                onPress: () async {
                  // print(email);
                  // print(password);

                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final oldUser = await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    if (oldUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });

                  } catch (e) {
                    print(e);
                  }
                },
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
