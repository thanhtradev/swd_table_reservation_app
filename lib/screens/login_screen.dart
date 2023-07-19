import 'package:flutter/material.dart';
import 'package:table_reservation_app/screens/home_screen.dart';
import 'package:table_reservation_app/utils/api_service.dart';

import '../constants/contant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // The button should be disabled if the username or password is empty
            TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                }),
            const SizedBox(height: 20),
            TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                }),
            buildButton(true, "Login", () async {
              debugPrint("Username: $username");
              debugPrint("Password: $password");
              if (username == "" || password == "") {
                showAlertDialog(
                    context, "Error", "Username or password is empty");
                return null;
              } else {
                ApiService().post('/auth/login', {
                  "username": username,
                  "password": password,
                }).then((data) {
                  debugPrint("Data: $data");
                  if (data['result'] == true) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  }
                }).catchError((err) {
                  debugPrint("Error: $err");
                  showAlertDialog(context, "Error", err.toString());
                });
              }
            }),
          ],
        ),
      ),
    );
  }
}
