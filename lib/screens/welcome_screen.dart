import 'package:chat_rawro/screens/login_screen.dart';
import 'package:chat_rawro/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_rawro/components/reusable_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

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
    //Ticker Animation
    controller = AnimationController(
      //Specifies what is going to act as the ticker
      vsync:
          this, //Refers to the object that the class creates with the SingleTickerProviderMixin

      // length of animation
      duration: Duration(seconds: 1),
    );

    //Color tween animation that transitions from grey to white
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);

    //Animation type - goes from 0 to 1
    controller.forward();

    controller.addListener(() {
      setState(() {
        //Required to change state
      });
    });
  }

  @override
  void dispose() {
    // Trashes animation when you go to a different screen
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Background color has animation transition
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                //Hero Animation transitions a shared widget (the logo) from one screen to another
                Hero(
                  //Tag is required
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    //Logo grows from 0% - 100%
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  //Loading indicator -> 0% - 100%
                  //'${controller.value.toInt()}%',
                  text: ['Rawro Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ReusableButton(
              text: 'Log In',
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              color: Colors.lightBlueAccent,
            ),
            ReusableButton(
              text: 'Register',
              onPress: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
