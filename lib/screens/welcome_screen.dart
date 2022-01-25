import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/registration_screen.dart';
import 'package:untitled/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  //init state
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.decelerate,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 100,
                    width: 80,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width-140,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 35,
                      color: Colors.blueGrey,
                    ),
                    child: AnimatedTextKit(
                      pause: Duration(seconds: 3),
                      repeatForever: true,
                      animatedTexts: [
                        TypewriterAnimatedText(
                            'FLASH CHAT',
                          speed: Duration(milliseconds: 100)
                        ),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton('Log In', Colors.lightBlueAccent, () {
              Navigator.pushNamed(context, LoginScreen.id);
            }),
            RoundedButton('Register', Colors.blueAccent, () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            })
          ],
        ),
      ),
    );
  }
}
