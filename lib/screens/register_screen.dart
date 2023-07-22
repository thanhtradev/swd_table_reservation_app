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
  String phone = "";
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
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 180,
              height: 180,
            ),
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: // The button should be disabled if the username or password is empty
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
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  }),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  }),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45),
              child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                  onChanged: (value) {
                    setState(() {
                      phone = value;
                    });
                  }),
            ),
            buildButton(true, "Register", () async {
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
                  "phoneNumber": phone,
                }).then((data) {
                  debugPrint("Data: $data");
                  if (data['result'] == true) {
                    showAlertDialog(context, "Success", "Register success");
                  } else {
                    showAlertDialog(context, "Error", data['message']);
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
