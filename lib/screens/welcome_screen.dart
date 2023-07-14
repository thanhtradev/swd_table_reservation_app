import 'package:flutter/material.dart';
import 'package:table_reservation_app/constants/contant.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 180,
                height: 180,
              ),
            ),
            // Rounded text button
            buildButton(false, 'Login'),
            TextButton(
              onPressed: () {},
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 20,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  TextButton buildButton(bool status, String text) {
    return TextButton(
      onPressed: () {},
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
}
