import 'package:flutter/material.dart';
import 'package:untitled/screens/welcome_screen.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/registration_screen.dart';
import 'package:untitled/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}
class FlashChat extends StatelessWidget {
  const FlashChat({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.white,
        hintColor: Colors.grey,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context)=> WelcomeScreen(),
        ChatScreen.id: (context)=> ChatScreen(),
        RegistrationScreen.id: (context)=> RegistrationScreen(),
        LoginScreen.id: (context)=> LoginScreen(),
      },
    );
  }
}
