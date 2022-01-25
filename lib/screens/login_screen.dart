import 'package:flutter/material.dart';
import 'package:untitled/rounded_button.dart';
import 'package:untitled/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  late String email;
  late String password;
  String errorMessage = '';
  bool obscurevalue=true;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
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
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kLoginScreentextdeco),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: obscurevalue,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    suffixIcon: IconButton(onPressed: (){setState(() {
                      if(obscurevalue==true){
                        obscurevalue=false;
                      }else{
                        obscurevalue=true;
                      }
                    });}, icon:Icon(
                        obscurevalue? Icons.visibility : Icons.visibility_off) ),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  )),
              Text(
                '$errorMessage ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.redAccent, fontFamily: 'Montserrat'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton('Login', Colors.lightBlueAccent, () async {
                context.loaderOverlay.show();
                try {
                  final newUser = await _auth.signInWithEmailAndPassword(
                      email: email, password: password);
                  if (newUser != null) {
                    Navigator.pushNamed(context, ChatScreen.id);
                    context.loaderOverlay.hide();
                  }
                } catch (e) {
                  print(e);
                  setState(() {
                    if (e.toString() == '[firebase_auth/invalid-email] The email address is badly formatted.') {
                      errorMessage = 'Email is invalid';
                      context.loaderOverlay.hide();
                    }if(e.toString()=='[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.'){
                      errorMessage='You dont have a Chat account please create one';
                      context.loaderOverlay.hide();
                    }if(e.toString()=='[firebase_auth/wrong-password] The password is invalid or the user does not have a password.'){
                      errorMessage='The password is invalid or the user does not have a password.';
                      context.loaderOverlay.hide();
                    }if(e.toString()=='[firebase_auth/unknown] Given String is empty or null'){
                      errorMessage='Please enter your email and password in the fields';
                      context.loaderOverlay.hide();
                    }if(e.toString()=="LateInitializationError: Field 'email' has not been initialized."){
                      errorMessage='Please enter your email and password in the fields';
                      context.loaderOverlay.hide();
                    }
                  });
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
