// Declare all the colors used in the app

import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFF2AC06);
const Color secondaryColor = Color(0xFFD9D9D9);

const Color primaryBackgroundColor = Color(0xFFFFFFFF);

const Color primaryTextColor = Color(0xFF000000);
const Color secondaryTextColor = Color(0xFFFFFFFF);

TextButton buildButton(bool status, String text, Function onPressed) {
  return TextButton(
    onPressed: () => onPressed(),
    child: Container(
      width: 200,
      height: 60,
      decoration: BoxDecoration(
        color: status ? primaryColor : secondaryColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: status ? secondaryTextColor : primaryTextColor,
          ),
        ),
      ),
    ),
  );
}

// Show dialog
void showAlertDialog(BuildContext context, String title, String content) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
