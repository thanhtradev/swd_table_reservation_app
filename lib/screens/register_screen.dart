import 'package:flutter/material.dart';
import 'package:table_reservation_app/constants/contant.dart';
import 'package:table_reservation_app/utils/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            buildButton(true, "Register", () {
              debugPrint("Username: $username");
              debugPrint("Password: $password");
              if (username == "" || password == "") {
                showAlertDialog(
                    context, "Error", "Username or password is empty");
                return null;
              } else {
                ApiService().post('/auth/register', {
                  "username": username,
                  "password": password,
                }).then((data) {
                  debugPrint("Data: $data");
                  if (data['status'] == 200) {
                    showAlertDialog(context, "Success", "Register success");
                  } else {
                    showAlertDialog(context, "Error", data['message']);
                  }
                });
              }
            }),
          ],
        ),
      ),
    );
  }
}
