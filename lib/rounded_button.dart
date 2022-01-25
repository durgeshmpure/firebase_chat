import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Color colour;
  final VoidCallback Onpressed;
  const RoundedButton(this.title,this.colour, this.Onpressed,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: Onpressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }
}
