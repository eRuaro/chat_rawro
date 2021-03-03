import 'package:flutter/material.dart';
import 'package:chat_rawro/screens/welcome_screen.dart';
import 'package:chat_rawro/screens/login_screen.dart';
import 'package:chat_rawro/screens/registration_screen.dart';
import 'package:chat_rawro/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RawroChat());
}

class RawroChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black54),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
